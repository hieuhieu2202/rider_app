import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/authentication/auth_screen.dart';
import '../global/global.dart';
import '../mainScreen/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Vui lòng nhập emal và mật khẩu",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialog(
          message: "Đang kiểm tra thông tin",
        );
      },
    );

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
      //     .then((value) {
      //   Navigator.pop(context);
      //   // Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      //
      // });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharePreferences!.setString("uid", currentUser.uid);
        await sharePreferences!
            .setString("email", snapshot.data()!["riderEmail"]);
        await sharePreferences!
            .setString("name", snapshot.data()!["riderName"]);
        await sharePreferences!
            .setString("photoURL", snapshot.data()!["riderAvatarURL"]);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        // Get.back();
        // Get.to(const HomeScreen());
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Tài khoản không tồn tại!",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/signin.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
            child: const Text(
              "Đăng nhập",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
