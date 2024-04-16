import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../mainScreen/order_detail_screen.dart';
import '../models/items.dart';


class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateItemQuantitiesList;

  OrderCard(
      {this.itemCount,
      this.data,
      this.separateItemQuantitiesList,
      this.orderID});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailScreen(orderID: orderID)));
      },
      child: Container(
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
              Colors.black12,
              Colors.white54,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
          itemCount: itemCount,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Items model =
                Items.fromJson(data![index].data()! as Map<String, dynamic>);
            return placeOrderDesignWidget(
                model, context, separateItemQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(
    Items model, BuildContext context, separateItemQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey,
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
          width: 120,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                  model.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Acme",
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  model.price.toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "VNĐ",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "x ",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Expanded(
                    child: Text(
                  separateItemQuantitiesList,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontFamily: "Acme",
                  ),
                ))
              ],
            )
          ],
        ))
      ],
    ),
  );
}
