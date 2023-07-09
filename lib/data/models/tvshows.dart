class ClsTvShows {
  String? numTvShow;
  String? idTvShow;
  String? nameTvShow;
  String? titleTvShow;
  String? streamImg;
  String? ratingTvShow;
  String? categoryId;
  //List<ClsCategory> categories;

  ClsTvShows({
    this.numTvShow,
    this.idTvShow,
    this.nameTvShow,
    this.titleTvShow,
    this.streamImg,
    this.ratingTvShow,
    this.categoryId,
  });

  factory ClsTvShows.fromJson(Map<String, dynamic> json) => ClsTvShows(
        numTvShow: json["num"].toString(),
        idTvShow: json["series_id"].toString(),
        nameTvShow: json["name"].toString(),
        titleTvShow: json["title"].toString(),
        streamImg: json["cover"].toString(),
        ratingTvShow: json["rating"].toString(),
        categoryId: json["category_id"].toString(),
        //categories: List<ClsCategory>.from(
        //    json["categories"].map((x) => ClsCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "num": numTvShow,
        "series_id": idTvShow,
        "name": nameTvShow,
        "title": titleTvShow,
        "cover": streamImg,
        "rating": ratingTvShow,
        "category_id": categoryId,
      };
}
