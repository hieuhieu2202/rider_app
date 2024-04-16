import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  Items(
      {this.menuID,
      this.sellerUID,
      this.itemID,
      this.title,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.price});

  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    sellerUID = json['sellerUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailURL'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuID']=menuID;
    data['sellerUID']=sellerUID;
    data['itemID']=title;
    data['shortInfo']=shortInfo;
    data['publishedDate']=publishedDate;
    data['thumbnailURL']=thumbnailUrl;
    data['longDescription']=longDescription;
    data['status']=status;
    data['price']=price;

    return data;
  }
}
