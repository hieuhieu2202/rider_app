import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistant_method/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appbar.dart';

class ParcelInProgressScreen extends StatefulWidget {
  const ParcelInProgressScreen({super.key});

  @override
  State<ParcelInProgressScreen> createState() => _ParcelInProgressScreenState();
}

class _ParcelInProgressScreenState extends State<ParcelInProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Đơn hàng đang trong quá trình giao",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "picking")
            .orderBy("orderTime", descending: false)
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID",
                                whereIn: separateOrderItemId(
                                    (snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>)["productIDs"]))
                            .where("orderBy",
                                whereIn: (snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>)["uid"])
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data!.docs.length,
                                  data: snap.data!.docs,
                                  orderID: snapshot.data!.docs[index].id,
                                  separateItemQuantitiesList:
                                      separateOrderItemQuantities(
                                          (snapshot.data!.docs[index].data()!
                                                  as Map<String, dynamic>)[
                                              "productIDs"]),
                                )
                              : Center();
                        });
                  },
                )
              : Center(
                  child: circularProgress(),
                );
        },
      ),
    ));
  }
}
