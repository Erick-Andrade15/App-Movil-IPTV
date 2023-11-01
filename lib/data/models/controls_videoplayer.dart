import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';

class ClsControlsVideoPlayer {
  final VideoType videoType;
  final int? idTMDB;
  //TV
  final ClsChannel? clsChannel;
  final void Function(ClsChannel)? updateFutureChannelGlobal;
  //MOVIES
  final ClsMovies? clsMovies;
  //SERIES
  final ClsTvShows? clsTvShows;


  ClsControlsVideoPlayer({
    required this.videoType,
    this.idTMDB,
    this.clsChannel,
    this.updateFutureChannelGlobal,
    this.clsMovies,
    this.clsTvShows,
  });
}

enum VideoType {
  simplifiedTV,
  tvChannel,
  movie,
  series,
}
