class ClsMovies {
  int? numMovie;
  int? idMovie;
  String? nameMovie;
  String? titleMovie;
  String? urlMovie; //URL
  String? extensionUrl;
  String? streamImg;
  dynamic ratingMovie;
  String? categoryId;

  //List<ClsCategory> categories;

  ClsMovies({
    this.numMovie,
    this.idMovie,
    this.nameMovie,
    this.titleMovie,
    this.urlMovie,
    this.extensionUrl,
    this.streamImg,
    this.ratingMovie,
    this.categoryId,
  });

  factory ClsMovies.fromJson(Map<String, dynamic> json) => ClsMovies(
        numMovie: json["num"] ?? "",
        idMovie: json["stream_id"] ?? "",
        nameMovie: json["name"] ?? "",
        titleMovie: json["title"] ?? "",
        urlMovie: json["url"] ?? "",
        extensionUrl: json["container_extension"] ?? "",
        streamImg: json["stream_icon"] ?? "",
        ratingMovie: json["rating"] ?? "",
        categoryId: json["category_id"] ?? "",
        // categories: List<ClsCategory>.from(
        //  json["categories"].map((x) => ClsCategory.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "num": numMovie,
        "stream_id": idMovie,
        "name": nameMovie,
        "title": titleMovie,
        "url": urlMovie,
        "container_extension": extensionUrl,
        "stream_icon": streamImg,
        "rating": ratingMovie,
        "category_id": categoryId,
        // "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
