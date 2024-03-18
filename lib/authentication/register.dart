import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../mainScreen/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageURL = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Yêu cầu quyền nếu chưa được cấp
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Hiển thị thông báo hoặc hướng dẫn người dùng cách bật quyền từ cài đặt thiết bị.
      }
    }
    // Lấy vị trí hiện tại từ thiết bị
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Lưu vị trí vào biến 'position' để sử dụng sau này
    position = newPosition;

    // Lấy địa chỉ chi tiết từ tọa độ vị trí
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    // Chọn địa chỉ đầu tiên từ danh sách các địa chỉ (thường chỉ có một)
    Placemark pMark = placeMarks![0];

    // Tạo một chuỗi đầy đủ thông tin địa chỉ
    completeAddress = '${pMark.name ?? ''}, ' // Tên địa điểm (nếu có)
        '${pMark.subThoroughfare ?? ''} ' // Số nhỏ nhất
        '${pMark.thoroughfare ?? ''}, ' // Tên đường
        '${pMark.subLocality ?? ''}, ' // Phường/Xã
        // '${pMark.locality ?? ''}, ' // Thành phố
        '${pMark.subAdministrativeArea ?? ''}, ' // Quận/Huyện
        '${pMark.administrativeArea ?? ''} ' // Tỉnh/Thành phố
        '${pMark.postalCode ?? ''}' // Mã bưu chính
        '${pMark.country ?? ''}'; // Quốc gia

    // Sử dụng setState để cập nhật trạng thái của widget
    setState(() {
      // Đặt chuỗi thông tin địa chỉ vào ô văn bản
      // completeAddress.trim();
      locationController.text = completeAddress;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Chọn ảnh đại diện của bạn",
          );
        },
      );
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Đang đăng ký tài khoản",
                );
              });
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child("riders")
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageURL = url;
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Hãy nhập đầy đủ thông tin",
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Mật khẩu không gống nhau",
            );
          },
        );
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          },
        );
      }
    });
    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set({
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameController.text.toString(),
      "riderAvatarURL": sellerImageURL,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earning": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    sharePreferences = await SharedPreferences.getInstance();
    await sharePreferences!.setString('uid', currentUser.uid);
    await sharePreferences!.setString('email', emailController.text.trim());
    await sharePreferences!.setString('name', nameController.text.trim());
    await sharePreferences!.setString('photoURL', sellerImageURL);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        data: Icons.person,
                        controller: nameController,
                        hintText: "Họ và tên",
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.lock,
                        controller: passwordController,
                        hintText: "Mật khẩu",
                        isObsecre: true,
                      ),
                      CustomTextField(
                        data: Icons.lock,
                        controller: confirmPasswordController,
                        hintText: "Nhập lại mật khẩu",
                        isObsecre: true,
                      ),
                      CustomTextField(
                        data: Icons.phone,
                        controller: phoneController,
                        hintText: "Số điện thoại",
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.my_location,
                        controller: locationController,
                        hintText: "Địa chỉ",
                        isObsecre: false,
                        enabled: true,
                      ),
                      Container(
                        width: 400,
                        height: 40,
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          label: const Text(
                            "Địa chỉ hiện tại",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getCurrentLocation();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  //=> print("Clicked Đăng ký"),
                  formValidation();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10)),
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
