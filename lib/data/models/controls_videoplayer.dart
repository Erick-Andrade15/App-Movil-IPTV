import 'package:app_movil_iptv/data/models/channel.dart';

class ClsControlsVideoPlayer {
  final VideoType videoType;
  final String titleVideo; //Peliculs 2022 - Serie S01E02
  final int? idTMDB;
  final String? nameVideo; //Pelicula - Serie
  final String? imgChannel;
  final int? seasonTvShow;
  final int? episodeTvShow;
  final bool? isSimplifiedTV;
  final void Function(ClsChannel)? updateFutureChannelGlobal;

  ClsControlsVideoPlayer({
    required this.videoType,
    required this.titleVideo,
    this.idTMDB,
    this.nameVideo,
    this.imgChannel,
    this.seasonTvShow,
    this.episodeTvShow,
    this.isSimplifiedTV,
    this.updateFutureChannelGlobal,
  });
}

enum VideoType {
  //simplifiedTV,
  tvChannel,
  movie,
  series,
}
