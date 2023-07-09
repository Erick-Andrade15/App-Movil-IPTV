class ClsChannel {
  String? numChannel;
  String? idChannel;
  String? nameChannel;
  String? urlChannel; //URL
  String? streamImg;
  String? categoryId;
  bool isFavorite; // Nuevo campo

  // List<ClsCategory> categories;
  ClsChannel({
    this.numChannel,
    this.idChannel,
    this.nameChannel,
    this.urlChannel,
    this.streamImg,
    this.categoryId,
    this.isFavorite = false, // Valor predeterminado es false
  });

  factory ClsChannel.fromJson(Map<String, dynamic> jsonData) => ClsChannel(
        numChannel: jsonData["num"].toString(),
        idChannel: jsonData["stream_id"].toString(),
        nameChannel: jsonData["name"].toString(),
        urlChannel: jsonData["url"].toString(),
        streamImg: jsonData["stream_icon"].toString(),
        categoryId: jsonData["category_id"].toString(),
        isFavorite: jsonData["is_favorite"] as bool? ?? false,

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
        "is_favorite": isFavorite,

        // "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
