import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/splashScreen/splash_screen.dart';

import '../assistant_method/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utils.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderID;

  ParcelDeliveringScreen({this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderID});

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {

  confirmParcelHasBeenDelivered(getOrderId, sellerId, purcharserId,
      purcharserAddress, purcharserLat, purcharserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": "",
    }).then((value) {
      FirebaseFirestore.instance.collection("riders")
          .doc(widget.sellerId).update({
        "earnings": "",
      });
    }).then((value) {
      FirebaseFirestore.instance.collection("sellers").doc(
          sharePreferences!.getString("uid"))
          .update({
        "earnings": "",
      });
    }).then((value) {
      FirebaseFirestore.instance.collection("users")
          .doc(purcharserId)
          .collection("orders")
          .doc(getOrderId).update({
        "status": "ended",
        "riderUID" :sharePreferences!.getString("uid"),
      });
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              MapUtils.launchMapFromSourceToDestination(position!.latitude,
                  position!.longitude, widget.purchaserLat!,
                  widget.purchaserLng!);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/restaurant.png",
                  width: 50,
                ),
                SizedBox(
                  width: 7,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      "Địa chỉ của cửa hàng",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 22,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  UserLocation userLocation = UserLocation();
                  userLocation.getCurrentLocation();
                  confirmParcelHasBeenDelivered(
                      widget.getOrderID,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.amber,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Đơn hàng đã được giao. Vui lòng xác nhận",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
