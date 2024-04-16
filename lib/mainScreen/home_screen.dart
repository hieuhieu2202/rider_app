import 'package:flutter/material.dart';
import 'package:rider_app/mainScreen/new_order_screen.dart';
import 'package:rider_app/mainScreen/order_detail_screen.dart';
import 'package:rider_app/mainScreen/parcel_in_progress_screen.dart';

import '../assistant_method/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => NewOrderScreen()));
            }
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => ParcelInProgressScreen()));
            }
            if (index == 2) {}
            if (index == 3) {}
            if (index == 4) {}
            if (index == 5) {
              firebaseAuth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation userLocation = UserLocation();
    userLocation.getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
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
          ),
          title: Text(
            sharePreferences!.getString("name")!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontFamily: "Signatra",
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 1.0),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(2),
            children: [
              makeDashboardItem("Đơn hàng mới", Icons.assignment, 0),
              makeDashboardItem("Đang giao", Icons.airport_shuttle, 1),
              makeDashboardItem(
                  "Đơn hàng đang xử lý", Icons.location_history, 2),
              makeDashboardItem("Lịch sử", Icons.done_all, 3),
              makeDashboardItem("Thu nhập", Icons.monetization_on, 4),
              makeDashboardItem("Đăng xuất", Icons.logout, 5),
            ],
          ),
        ));
  }
}
