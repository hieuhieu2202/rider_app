import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/assistant_method/get_current_location.dart';
import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreen/parcel_delivering_screen.dart';
import 'package:rider_app/maps/map_utils.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderID;

  ParcelPickingScreen(
      {this.purchaserId,
      this.purchaserAddress,
      this.purchaserLat,
      this.purchaserLng,
      this.sellerId,
      this.getOrderID});

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLat, sellerLng;

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((DocumentSnapshot) {
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }

  confirmParcelHasBeenPicked(getOrderId, sellerId, purcharserId,
      purcharserAddress, purcharserLat, purcharserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => ParcelDeliveringScreen(
                  purchaserId: purcharserId,
                  purchaserAddress: purcharserAddress,
                  purchaserLat: purcharserLat,
                  purchaserLng: purcharserLng,
                  sellerId: sellerId,
                  getOrderID: getOrderId,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerData();
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
                  position!.longitude, sellerLat!, sellerLng!);
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
                  confirmParcelHasBeenPicked(
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
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Xác nhận đơn hàng đã được lấy",
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
