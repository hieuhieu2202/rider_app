import 'package:flutter/material.dart';

import '../mainScreen/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;

  StatusBanner({this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;
    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Thành công" : message = "Không thành công";
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Màu sắc bóng đổ
            offset: const Offset(0, 10), // Vị trí bóng đổ
            blurRadius: 5.0, // Độ lan tỏa của bóng đổ
          )
        ],
        gradient: const LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => HomeScreen()));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            orderStatus == "ended"
                ? "Đơn hàng đã được giao $message"
                : "Đặt hàng $message",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5,),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
