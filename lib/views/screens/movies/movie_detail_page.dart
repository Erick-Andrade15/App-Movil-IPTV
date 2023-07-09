import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_movies.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/viewmodels/movies_viewmodel.dart';
import 'package:app_movil_iptv/views/widgets/trailer_video.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.clsMovies,
  });
  final ClsMovies clsMovies;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MoviesViewModel viewModelMovies = MoviesViewModel();
  late Future<TMDBMovies>? futureDataMovies;
  late bool isfavorite = false;

  @override
  void initState() {
    super.initState();
    futureDataMovies = viewModelMovies.getAllDataMovies(widget.clsMovies);
    isfavorite = viewModelMovies.isMovieFavorite(widget.clsMovies);
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
        title: Text(widget.clsMovies.titleMovie!),
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
              viewModelMovies
                  .addToFavorites(widget.clsMovies)
                  .then((value) => setState(() {
                        isfavorite =
                            viewModelMovies.isMovieFavorite(widget.clsMovies);
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
          child: FutureBuilder<TMDBMovies>(
            future: futureDataMovies,
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
                final dataMovieTMDB = snapshot.data;
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: dataMovieTMDB!.posterPath,
                            height: 290.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 300),
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
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //DESCRIPTION
                              Flexible(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Descripcion:",
                                      style: Const.fontSubtitleTextStyle),
                                  Text(dataMovieTMDB.releaseDate,
                                      style: Const.fontSubtitleTextStyle)
                                ],
                              )),

                              RichText(
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${dataMovieTMDB.genres}\n',
                                      style: Const.fontCaptionTextStyle,
                                    ),
                                    TextSpan(
                                      text: dataMovieTMDB.overview,
                                      style: Const.fontBodyTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              //RATINKG
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dataMovieTMDB.voteAverage
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        "Rating",
                                        style: Const.fontSubtitleTextStyle,
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildStarRating(dataMovieTMDB.voteAverage
                                          .toStringAsFixed(1)),
                                      const Text(
                                        "Grade now",
                                        style: Const.fontSubtitleTextStyle,
                                      )
                                    ],
                                  ),
                                ],
                              )),
                              if (dataMovieTMDB.urlTrailer.isNotEmpty)
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      minWidth: 175,
                                      height: 50,
                                      onPressed: () {
                                        showTrailerModal(
                                            context, dataMovieTMDB.urlTrailer);
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
                                    MaterialButton(
                                      minWidth: 175,
                                      height: 50,
                                      onPressed: () {
                                        viewModelMovies
                                            .addToCatchUp(widget.clsMovies);
                                      }, //VER PELICULA REPRODUCTOR
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
                                  ],
                                ))
                              else
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    MaterialButton(
                                      minWidth: 175,
                                      height: 50,
                                      onPressed: () {
                                        viewModelMovies
                                            .addToCatchUp(widget.clsMovies);
                                      }, //VER PELICULA REPRODUCTOR
                                      color: Const.colorPurpleMedium,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Ver',
                                              style: Const.fontTitleTextStyle),
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
