import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuID;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailURL;
  String? status;

  Menus(
      {this.menuID,
      this.sellerUID,
      this.menuTitle,
      this.menuInfo,
      this.publishedDate,
      this.thumbnailURL,
      this.status});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    sellerUID = json["sellerUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    thumbnailURL = json["thumbnailURL"];
    status = json["status"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data=new Map<String, dynamic> ();

    data["menuID"]=menuID;
    data["sellerUID"]=sellerUID;
    data["menuTitle"]=menuTitle;
    data["menuInfo"]=menuInfo;
    data["publishedDate"]=publishedDate;
    data["thumbnailURL"]=thumbnailURL;
    data["status"]=status;

    return data;
  }
}
