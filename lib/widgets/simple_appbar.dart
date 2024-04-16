import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSize? bottom;
  String? title;

  SimpleAppBar({this.bottom, this.title});

  @override
  // TODO: implement preferredSize
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
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
            )),
      ),
      elevation: 0.0,
      title:  Text(
        title!,
        style: TextStyle(
            color: Colors.red,
            fontFamily: "Signatra",
            fontSize: 40,
            letterSpacing: 3),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
