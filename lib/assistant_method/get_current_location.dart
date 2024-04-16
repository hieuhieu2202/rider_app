import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../global/global.dart';

class UserLocation {


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
    // setState(() {
    //   // Đặt chuỗi thông tin địa chỉ vào ô văn bản
    //   // completeAddress.trim();
    //   locationController.text = completeAddress;
    // });
  }
}
