import 'package:app_movil_iptv/data/models/tmdb/tmdb_tvshows.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/viewmodels/series_viewmodel.dart';
import 'package:app_movil_iptv/views/screens/series/serie_episode_page.dart';
import 'package:app_movil_iptv/views/widgets/trailer_video.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SerieDetailPage extends StatefulWidget {
  const SerieDetailPage({super.key, required this.clsTvShows});
  final ClsTvShows clsTvShows;

  @override
  State<SerieDetailPage> createState() => _SerieDetailPageState();
}

class _SerieDetailPageState extends State<SerieDetailPage> {
  SeriesViewModel viewModelSeries = SeriesViewModel();
  late Future<TMDBTvShows>? futureDataTvShows;
  late bool isfavorite = false;

  @override
  void initState() {
    super.initState();
    futureDataTvShows = viewModelSeries.getAllDataTvShows(widget.clsTvShows);
    isfavorite = viewModelSeries.isSeriesFavorite(widget.clsTvShows);
  }

  void showTrailerModal(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: TrailerVideo(urlTrailer: url),
        );
      },
    );
  }

  Widget buildStarRating(String ratingTmdb) {
    double rating = double.parse(ratingTmdb);
    const starFilledIcon = Icon(Icons.star, color: Colors.amber, size: 24);
    const starHalfIcon = Icon(Icons.star_half, color: Colors.amber, size: 24);
    const starEmptyIcon =
        Icon(Icons.star_border, color: Colors.amber, size: 24);

    final normalizedRating = (rating / 2).clamp(0, 5);
    final filledStarsCount = normalizedRating.floor();
    final hasHalfStar = normalizedRating - filledStarsCount >= 0.5;
    final emptyStarsCount = 5 - filledStarsCount - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        for (var i = 0; i < filledStarsCount; i++) starFilledIcon,
        if (hasHalfStar) starHalfIcon,
        for (var i = 0; i < emptyStarsCount; i++) starEmptyIcon,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(widget.clsTvShows.titleTvShow!),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Add Favorite',
            iconSize: 40,
            icon: isfavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            onPressed: () {
              viewModelSeries
                  .addToFavoriteSeries(widget.clsTvShows)
                  .then((value) => setState(() {
                        isfavorite =
                            viewModelSeries.isSeriesFavorite(widget.clsTvShows);
                      }));
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
        child: SafeArea(
          child: FutureBuilder<TMDBTvShows>(
            future: futureDataTvShows,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                final dataTvShowsTMDB = snapshot.data;
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 290.0,
                                width: 200.0,
                                color: Colors.grey,
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  ),
                                  child: Image.asset(
                                    Const.imgLogo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: dataTvShowsTMDB!.posterPath,
                                height: 290.0,
                                width: 200.0,
                                fit: BoxFit.cover,
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                                fadeOutDuration:
                                    const Duration(milliseconds: 300),
                                imageErrorBuilder: (context, url, error) =>
                                    Container(
                                  height: 290.0,
                                  width: 200.0,
                                  color: Colors.grey,
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.grey, BlendMode.saturation),
                                    child: Image.asset(
                                      Const.imgLogo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //DESCRIPTION
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Descripcion:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    dataTvShowsTMDB.releaseDate,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
                                ],
                              ),
                              //DESCRIPTION
                              RichText(
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${dataTvShowsTMDB.genres}\n',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: dataTvShowsTMDB.overview,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //RATING
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dataTvShowsTMDB.voteAverage
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Rating",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        buildStarRating(dataTvShowsTMDB
                                            .voteAverage
                                            .toStringAsFixed(1)),
                                        const Text(
                                          "Grade now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //TRAILER
                              if (dataTvShowsTMDB.urlTrailer.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      minWidth: 175,
                                      height: 50,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SerieEpisodePage(
                                              idTMDB:
                                                  dataTvShowsTMDB.idTMDBTvshows,
                                              clsTvShows: widget.clsTvShows,
                                            ),
                                          )),
                                      color: Const.colorPurpleMedium,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Ver Ahora',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Const.colorWhite,
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.play_arrow,
                                            size: 25,
                                            color: Const.colorWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      minWidth: 175,
                                      height: 50,
                                      onPressed: () {
                                        showTrailerModal(context,
                                            dataTvShowsTMDB.urlTrailer);
                                      },
                                      color: Const.colorPurpleMedium,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Trailer',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Const.colorWhite,
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.videocam,
                                            size: 25,
                                            color: Const.colorWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else
                                MaterialButton(
                                  minWidth: 175,
                                  height: 50,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SerieEpisodePage(
                                          idTMDB: dataTvShowsTMDB.idTMDBTvshows,
                                          clsTvShows: widget.clsTvShows,
                                        ),
                                      )),
                                  color: Const.colorPurpleMedium,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Ver Ahora',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Const.colorWhite,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.play_arrow,
                                        size: 25,
                                        color: Const.colorWhite,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )),
                    ]);
              }
            },
          ),
        ),
      ),
    );
  }
}
