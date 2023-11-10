import 'dart:convert';

class ClsDetailTvShows {
  List<ClsSeasonTvShow>? seasonsTvShows;
  //final ClsTvShows? infoTvShows;
  final Map<String, List<ClsEpisodeTvShow?>?>? episodesTvShows;

  ClsDetailTvShows({
    this.seasonsTvShows,
    //  this.infoTvShows,
    this.episodesTvShows,
  });

  factory ClsDetailTvShows.fromJson(Map<String, dynamic> json) {
    //SEASONS
    final seasons = json['seasons'] as List?;
    final parsedSeasons = seasons?.map((season) {
      return ClsSeasonTvShow.fromJson(season as Map<String, dynamic>);
    }).toList();
    //INFO  SERIE
    //  final info = json['info'] as Map<String, dynamic>?;
    // final parsedInfo = info != null ? ClsTvShows.fromJson(info) : null;
    //EPISODES
    final episodesJson = json['episodes'] as Map<String, dynamic>?;
    final parsedEpisodes = episodesJson?.map((key, value) {
      final episodesList = value as List<dynamic>?;
      final parsedEpisodesList = episodesList?.map((episode) {
        return ClsEpisodeTvShow.fromJson(episode as Map<String, dynamic>);
      }).toList();
      return MapEntry(key, parsedEpisodesList);
    });

    return ClsDetailTvShows(
      seasonsTvShows: parsedSeasons,
      //   infoTvShows: parsedInfo,
      episodesTvShows: parsedEpisodes,
    );
  }

  Map<String, dynamic> toJson() => {
        'seasons': seasonsTvShows?.map((season) => season.toJson()).toList(),
        // 'info': infoTvShows?.toJson(),
        'episodes': episodesTvShows?.map((key, value) {
          return MapEntry(
              key, value?.map((episode) => episode?.toJson()).toList());
        }),
      };
}

class ClsSeasonTvShow {
  final String? idSeason;
  final String? nameSeason;
  final String? numberSeason;
  final String? airDateSeason;
  final String? episodeCount;
  // final String? overview;
  // final String? cover;
  // final String? coverBig;

  ClsSeasonTvShow({
    this.idSeason,
    this.nameSeason,
    this.numberSeason,
    this.airDateSeason,
    this.episodeCount,
  });

  factory ClsSeasonTvShow.fromJson(Map<String, dynamic> json) =>
      ClsSeasonTvShow(
        idSeason: json['id'].toString(),
        nameSeason: json['name'].toString(),
        numberSeason: json['season_number'].toString(),
        airDateSeason: json['air_date'].toString(),
        episodeCount: json['episode_count'].toString(),
        //seasonNumber: json['season_number'] as String?,
        // cover: json['cover'] as String?,
        // coverBig: json['cover_big'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': idSeason,
        'name': nameSeason,
        'season_number': numberSeason,
        'air_date': airDateSeason,
        'episode_count': episodeCount,
        //  'season_number': seasonNumber,
        //  'cover': cover,
        //  'cover_big': coverBig
      };
}

class ClsEpisodeTvShow {
  final String? idEpisode;
  final String? idSeason;
  final String? numEpisode;
  final String? titleEpisode;
  String? urlEpisode; //URL
  final String? extensionUrl;
  final InfoEpisode? infoEpisode;

  // final String? customSid;
  // final String? added;
  //final String? directSource;

  ClsEpisodeTvShow({
    this.idEpisode,
    this.idSeason,
    this.numEpisode,
    this.titleEpisode,
    this.urlEpisode,
    this.extensionUrl,
    this.infoEpisode,
    //this.directSource,
  });

  factory ClsEpisodeTvShow.fromJson(Map<String, dynamic> json) =>
      ClsEpisodeTvShow(
        idEpisode: json['id'].toString(),
        idSeason: json['season'].toString(),
        numEpisode: json['episode_num'].toString(),
        titleEpisode: decodeTitle(json['title']),
        //titleEpisode: json['title'].toString(),
        urlEpisode: json['url'].toString(),
        extensionUrl: json['container_extension'].toString(),
        infoEpisode: json['info'] != null && json['info'].runtimeType != List
            ? InfoEpisode.fromJson(json['info'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': idEpisode,
        'season': idSeason,
        'episode_num': numEpisode,
        'title': titleEpisode,
        'url': urlEpisode,
        'container_extension': extensionUrl,
        'info': infoEpisode?.toJson(),
      };
}

class InfoEpisode {
  final String? idTMDB;
  final String? releaseDateEpisode;
  final String? plotEpisode;
  final String? durationEpisode;
  final String? imageEpisode;
  final String? ratingEpisode;

  // final String? name;
  // final String? durationSecs;
  // final String? bitrate;

  InfoEpisode({
    this.idTMDB,
    this.releaseDateEpisode,
    this.plotEpisode,
    this.durationEpisode,
    this.imageEpisode,
    this.ratingEpisode,
    // this.duration,
    // this.bitrate,
  });

  factory InfoEpisode.fromJson(Map<String, dynamic> json) => InfoEpisode(
        idTMDB: json['tmdb_id'].toString(),
        releaseDateEpisode: json['release_date'].toString(),
        plotEpisode: json['plot'] == null ? "" : json['plot'].toString(),
        durationEpisode: json['duration'].toString(),
        imageEpisode: json['movie_image'].toString(),
        ratingEpisode: json['rating'].toString(),
        //duration: json['duration']?.toString(),
        // bitrate: json['bitrate']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'tmdb_id': idTMDB,
        'release_date': releaseDateEpisode,
        'plot': plotEpisode,
        'duration': durationEpisode,
        'movie_image': imageEpisode,
        'rating': ratingEpisode,
        // 'duration': duration,
        // 'bitrate': bitrate
      };
}

//DECODIFICAR UTF8 - TILDES Y CARACTERES ESPECIALES
String decodeTitle(String title) {
  try {
    return utf8.decode(latin1.encode(title));
  } catch (e) {
    // Manejar la excepción, por ejemplo, devolver una cadena vacía o el título original
    return title;
  }
}
