import 'package:app_movil_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_iptv/data/models/detailtvshows.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_detail_tvshows.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/series_viewmodel.dart';
import 'package:app_movil_iptv/views/widgets/video/video_player.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SerieEpisodePage extends StatefulWidget {
  const SerieEpisodePage({
    super.key,
    required this.idTMDB,
    required this.clsTvShows,
  });
  final int idTMDB;
  final ClsTvShows clsTvShows;

  @override
  State<SerieEpisodePage> createState() => _SerieEpisodePageState();
}

class _SerieEpisodePageState extends State<SerieEpisodePage> {
  SeriesViewModel viewModelSeries = SeriesViewModel();
  late Future<ClsDetailTvShows>? futureDetailTvShows;

  @override
  void initState() {
    futureDetailTvShows =
        viewModelSeries.getAllDataDetailTvShows(widget.clsTvShows);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(widget.clsTvShows.titleTvShow!),
        backgroundColor: Colors.black38,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
        child: SafeArea(
          child: FutureBuilder<ClsDetailTvShows>(
            future: futureDetailTvShows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasData) {
                ClsDetailTvShows detailTvShows = snapshot.data!;
                return DefaultTabController(
                  length: detailTvShows.seasonsTvShows?.length ?? 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black38,
                        width: double.infinity,
                        child: TabBar(
                          isScrollable: true,
                          tabs: detailTvShows.seasonsTvShows!.map((season) {
                            return Tab(
                              child: Text(
                                season.nameSeason ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        children: detailTvShows.seasonsTvShows?.map((season) {
                              // Verifica si hay episodios para la temporada actual
                              List<ClsEpisodeTvShow?>? episodes = detailTvShows
                                  .episodesTvShows?[season.numberSeason];
                              //SCROLL HACIA ARRIBA / ERROR DA SIN SINGLECHILSCROLVIEW
                              return SingleChildScrollView(
                                child: ListView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Desactiva el scroll del ListView.builder
                                  shrinkWrap:
                                      true, // Ajusta el tamaño del ListView.builder al contenido

                                  itemCount: episodes?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    ClsEpisodeTvShow episode =
                                        episodes![index]!;

                                    return FutureBuilder<TMDBDetailTvShows>(
                                      future: viewModelSeries.getAllDataEpisode(
                                          widget.idTMDB,
                                          int.parse(episode.idSeason!),
                                          int.parse(episode.numEpisode!)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else {
                                          final detailTvShowsTMDB =
                                              snapshot.data;
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: detailTvShowsTMDB!
                                                        .posterPath,
                                                    height: 115.0,
                                                    width: 215.0,
                                                    fit: BoxFit.cover,
                                                    fadeInDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    fadeOutDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    imageErrorBuilder:
                                                        (context, url, error) =>
                                                            Container(
                                                      height: 115.0,
                                                      width: 215.0,
                                                      color: Colors.grey,
                                                      child: ColorFiltered(
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.grey,
                                                                BlendMode
                                                                    .saturation),
                                                        child: Image.asset(
                                                          Const.imgLogo,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: ListTile(
                                                    title: Text(
                                                      detailTvShowsTMDB
                                                              .nametitle
                                                              .isNotEmpty
                                                          ? detailTvShowsTMDB
                                                              .nametitle
                                                          : episode
                                                                  .titleEpisode ??
                                                              '',
                                                      style: Const
                                                          .fontTitleTextStyle,
                                                    ),
                                                    subtitle: Text(
                                                      detailTvShowsTMDB.overview
                                                              .isNotEmpty
                                                          ? detailTvShowsTMDB
                                                              .overview
                                                          : episode.infoEpisode!
                                                                  .plotEpisode ??
                                                              '',
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.white70),
                                                    )),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      MaterialButton(
                                                        minWidth: 150,
                                                        height: 50,
                                                        onPressed: () {
                                                          viewModelSeries
                                                              .addToCatchUpSeries(
                                                                  widget
                                                                      .clsTvShows);

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        VideoPlayer(
                                                                  url: episode
                                                                      .urlEpisode!,
                                                                  controls:
                                                                      ClsControlsVideoPlayer(
                                                                    videoType:
                                                                        VideoType
                                                                            .series,
                                                                    clsEpisodeTvShow:
                                                                        episode,
                                                                    clsTvShows:
                                                                        widget
                                                                            .clsTvShows,
                                                                    idTMDB: widget
                                                                        .idTMDB,
                                                                  ),
                                                                ),
                                                              ));
                                                        },
                                                        color: Const
                                                            .colorPurpleMedium,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: const Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Ver',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Const
                                                                    .colorWhite,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Icon(
                                                              Icons.play_arrow,
                                                              size: 25,
                                                              color: Const
                                                                  .colorWhite,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Utils.verticalSpace(2),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.schedule,
                                                            size: 18,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                          Utils.horizontalSpace(
                                                              2),
                                                          Text(
                                                            episode.infoEpisode!
                                                                    .durationEpisode ??
                                                                '',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Utils.verticalSpace(125)
                                            ],
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            }).toList() ??
                            [],
                      )),
                    ],
                  ),
                );
              } else {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      'No data available',
                      style: Const.fontHeaderTextStyle,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
