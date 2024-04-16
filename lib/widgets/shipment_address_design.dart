import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/assistant_method/get_current_location.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreen/parcel_picking_screen.dart';

import '../models/address.dart';
import '../splashScreen/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;

  ShipmentAddressDesign(
      {this.model,
      this.orderStatus,
      this.orderId,
      this.sellerId,
      this.orderByUser});

  confirmedParcelShipment(BuildContext context, String getOrderID,
      String sellerId, String purchaserId) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "riderUID": sharePreferences!.getString("uid"),
      "riderName": sharePreferences!.getString("name"),
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ParcelPickingScreen(
          purchaserId: purchaserId,
          purchaserAddress: model!.fullAddress,
          purchaserLat: model!.lat,
          purchaserLng: model!.lng,
          sellerId: sellerId,
          getOrderID: getOrderID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Chi tiết vận chuyển",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  "Tên",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.name!),
              ]),
              TableRow(children: [
                Text(
                  "Số điện thoại",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.phoneNumber!),
              ])
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),

        orderStatus == "ended"
            ? Container()
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                UserLocation uLocation = UserLocation();
                uLocation.getCurrentLocation();

                confirmedParcelShipment(context, orderId!, sellerId!, orderByUser!);
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Xác nhận giao đơn hàng này",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Trở về",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20,),
      ],
    );
  }
}
