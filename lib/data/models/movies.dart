class ClsMovies {
  String? numMovie;
  String? idMovie;
  String? nameMovie;
  String? titleMovie;
  String? urlMovie; //URL
  String? extensionUrl;
  String? streamImg;
  String? ratingMovie;
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
        numMovie: json["num"].toString(),
        idMovie: json["stream_id"].toString(),
        nameMovie: json["name"].toString(),
        titleMovie: json["title"].toString(),
        urlMovie: json["url"].toString(),
        extensionUrl: json["container_extension"].toString(),
        streamImg: json["stream_icon"].toString(),
        ratingMovie: json["rating"].toString(),
        categoryId: json["category_id"].toString(),
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
