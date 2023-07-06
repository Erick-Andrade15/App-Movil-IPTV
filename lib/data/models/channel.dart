class ClsChannel {
  int? numChannel;
  int? idChannel;
  String? nameChannel;
  String? urlChannel; //URL
  String? streamImg;
  String? categoryId;
  // List<ClsCategory> categories;

  ClsChannel({
    this.numChannel,
    this.idChannel,
    this.nameChannel,
    this.urlChannel,
    this.streamImg,
    this.categoryId,
  });

  factory ClsChannel.fromJson(Map<String, dynamic> jsonData) => ClsChannel(
        numChannel: jsonData["num"] ?? "",
        idChannel: jsonData["stream_id"] ?? "",
        nameChannel: jsonData["name"] ?? "",
        urlChannel: jsonData["url"] ?? "",
        streamImg: jsonData["stream_icon"] ?? "",
        categoryId: jsonData["category_id"] ?? "",

        // categories: List<ClsCategory>.from(
        //   jsonData["categories"].map((x) => ClsCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "num": idChannel,
        "stream_id": idChannel,
        "name": nameChannel,
        "url": urlChannel,
        "stream_icon": streamImg,
        "category_id": categoryId,

        // "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
