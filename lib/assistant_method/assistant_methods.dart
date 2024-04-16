import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

separateOrderItemId(orderIDs) {
  List<String> separateItemIdList = [], defaultItemList = [];
  defaultItemList = List<String>.from(orderIDs);

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getIdItem = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now here  = " + getIdItem);

    separateItemIdList.add(getIdItem);
  }
  print("\nThis is item list now here  = ");
  print(separateItemIdList);
  return separateItemIdList;
}

separateItemId() {
  List<String> separateItemIdList = [], defaultItemList = [];
  defaultItemList = sharePreferences!.getStringList("userCart")!;

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getIdItem = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now here  = " + getIdItem);

    separateItemIdList.add(getIdItem);
  }
  print("\nThis is item list now here  = ");
  print(separateItemIdList);
  return separateItemIdList;
}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemIdQuanlityList = [];
  List<String> defaultItemList = [];
  defaultItemList = List<String>.from(orderIDs);

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();
    var quanNuber = int.parse(listItemCharacters[1].toString());

    print("\nThis is quanlity now here  = " + quanNuber.toString());

    separateItemIdQuanlityList.add(quanNuber.toString());
  }
  print("\nThis is Quanlity list now here  = ");
  print(separateItemIdQuanlityList);
  return separateItemIdQuanlityList;
}

separateItemQuantities() {
  List<int> separateItemIdQuanlityList = [];
  List<String> defaultItemList = [];
  defaultItemList = sharePreferences!.getStringList("userCart")!;

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();
    var quanNuber = int.parse(listItemCharacters[1].toString());

    print("\nThis is quanlity now here  = " + quanNuber.toString());

    separateItemIdQuanlityList.add(quanNuber);
  }
  print("\nThis is Quanlity list now here  = ");
  print(separateItemIdQuanlityList);
  return separateItemIdQuanlityList;
}

clearCartNow(context) {
  sharePreferences!.setStringList('userCart', ['garbageValue']);
  List<String>? emptyList = sharePreferences!.getStringList("userCart");
  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    sharePreferences!.setStringList('userCart', emptyList!);
    // Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
    // Fluttertoast.showToast(msg: "Đã xóa giỏ hàng.");
  });
}
