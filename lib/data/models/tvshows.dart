class ClsTvShows {
  int? numTvShow;
  int? idTvShow;
  String? nameTvShow;
  String? titleTvShow;
  String? streamImg;
  dynamic ratingTvShow;
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
        numTvShow: json["num"] ?? "",
        idTvShow: json["series_id"] ?? "",
        nameTvShow: json["name"] ?? "",
        titleTvShow: json["title"] ?? "",
        streamImg: json["cover"] ?? "",
        ratingTvShow: json["rating"] ?? "",
        categoryId: json["category_id"] ?? "",
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
