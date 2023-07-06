class ClsDetailTvShows  {
  String tvshows;
  String name;
  int season;
  int episode;
  String url;

  ClsDetailTvShows({
    required this.tvshows,
    required this.name,
    required this.season,
    required this.episode,
    required this.url,
  });

  factory ClsDetailTvShows.fromJson(Map<String, dynamic> json) =>
      ClsDetailTvShows(
        tvshows: json["tvshows"] ?? "",
        name: json["name"] ?? "",
        season: json["season"] ?? "",
        episode: json["episode"] ?? "",
        url: json["url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "tvshows": tvshows,
        "name": name,
        "season": season,
        "episode": episode,
        "url": url,
      };
}
