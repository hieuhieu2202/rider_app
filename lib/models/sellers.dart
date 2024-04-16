class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarURL;
  String? sellerEmail;

  Sellers(
      {this.sellerUID,
      this.sellerName,
      this.sellerAvatarURL,
      this.sellerEmail});

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvatarURL = json["sellerAvatarURL"];
    sellerEmail = json["sellerEmail"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["sellerAvatarURL"] = sellerAvatarURL;
    data["sellerEmail"] = sellerEmail;
    return data;
  }
}


