import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/viewmodels/movies_viewmodel.dart';
import 'package:app_movil_iptv/viewmodels/series_viewModel.dart';
import 'package:app_movil_iptv/viewmodels/tvlive_viewmodel.dart';
import 'package:app_movil_iptv/views/screens/movies/movie_detail_page.dart';
import 'package:app_movil_iptv/views/screens/series/series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TvLiveViewModel viewModelTvLive = TvLiveViewModel();
  MoviesViewModel viewModelMovies = MoviesViewModel();
  SeriesViewModel viewModelSeries = SeriesViewModel();

  late Future<List<ClsChannel>>? futureChannels;
  late Future<List<ClsMovies>>? futureMovies;
  late Future<List<ClsTvShows>>? futureSeries;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    futureChannels = viewModelTvLive.allChannelsFavorites();
    futureMovies = viewModelMovies.allMoviesFavorites();
    futureSeries = viewModelSeries.allSeriesFavorites();
  }

  void updateMovies() {
    setState(() {
      futureMovies = viewModelMovies.allMoviesFavorites();
    });
  }

  void updateSeries() {
    setState(() {
      futureSeries = viewModelSeries.allSeriesFavorites();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: const Text('Favorites'),
        backgroundColor: Colors.black38,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Channels'),
            Tab(text: 'Movies'),
            Tab(text: 'Series'),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Const.imgBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  FavoriteChannelsWidget(favoriteChannels: futureChannels!),
                  FavoriteMoviesWidget(
                    favoriteMovies: futureMovies!,
                    moviesViewModel: viewModelMovies,
                    onUpdate: updateMovies,
                  ),
                  FavoriteSeriesWidget(
                    favoriteSeries: futureSeries!,
                    seriesViewModel: viewModelSeries,
                    onUpdate: updateSeries,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class FavoriteChannelsWidget extends StatelessWidget {
  final Future<List<ClsChannel>> favoriteChannels;

  const FavoriteChannelsWidget({Key? key, required this.favoriteChannels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<ClsChannel>>(
        future: favoriteChannels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading favorite channels'),
            );
          } else {
            var channels = snapshot.data;
            return channels!.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 60,
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Const.colorPurpleDarker,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Const.colorPurpleDark.withOpacity(0.8)),
                        child: ListTile(
                          title: Text(
                            channels[index].nameChannel!,
                            style: Const.fontCaptionTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: channels[index].streamImg!,
                            height: 50.0,
                            width: 50.0,
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 300),
                            imageErrorBuilder: (context, url, error) =>
                                Container(
                              height: 50.0,
                              width: 50.0,
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
                      );
                    })
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        'No favorite channels found',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}

class FavoriteMoviesWidget extends StatelessWidget {
  final Future<List<ClsMovies>> favoriteMovies;
  final MoviesViewModel moviesViewModel;
  final VoidCallback onUpdate;

  const FavoriteMoviesWidget({
    Key? key,
    required this.favoriteMovies,
    required this.moviesViewModel,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<ClsMovies>>(
        future: favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading favorite movies'),
            );
          } else {
            var movies = snapshot.data;
            return movies!.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 245,
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              clsMovies: movies[index],
                            ),
                          ),
                        ).then((value) => onUpdate()),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Const.colorPurpleDark.withOpacity(0.8),
                            border: Border.all(
                              color: Const.colorPurpleDarker,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: FutureBuilder<String>(
                                      future: moviesViewModel
                                          .getMovieImage(movies[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            snapshot.data!.isEmpty) {
                                          return Container(
                                            height: 200.0,
                                            width: 150.0,
                                            color: Colors.grey,
                                            child: ColorFiltered(
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.saturation,
                                              ),
                                              child: Image.asset(
                                                Const.imgLogo,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        } else {
                                          String imageUrl = snapshot.data!;
                                          return FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: imageUrl,
                                            height: 200.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                            fadeInDuration: const Duration(
                                                milliseconds: 300),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 300),
                                            imageErrorBuilder:
                                                (context, url, error) =>
                                                    Container(
                                              height: 200.0,
                                              width: 150.0,
                                              color: Colors.grey,
                                              child: ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.grey,
                                                  BlendMode.saturation,
                                                ),
                                                child: Image.asset(
                                                  Const.imgLogo,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Const.colorPurpleMedium,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: Text(
                                      double.parse(movies[index].ratingMovie!)
                                          .toStringAsFixed(1)
                                          .toString(),
                                      style: Const.fontSubtitleTextStyle,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                movies[index].titleMovie!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Const.fontBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        'No favorite movies found',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}

class FavoriteSeriesWidget extends StatelessWidget {
  final Future<List<ClsTvShows>> favoriteSeries;
  final SeriesViewModel seriesViewModel;
  final VoidCallback onUpdate;

  const FavoriteSeriesWidget({
    Key? key,
    required this.favoriteSeries,
    required this.seriesViewModel,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<ClsTvShows>>(
        future: favoriteSeries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading favorite series'),
            );
          } else {
            var series = snapshot.data;
            return series!.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 245,
                      crossAxisCount: 5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: series.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SerieDetailPage(
                              clsTvShows: series[index],
                            ),
                          ),
                        ).then((value) => onUpdate()),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Const.colorPurpleDark.withOpacity(0.8),
                            border: Border.all(
                              color: Const.colorPurpleDarker,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: FutureBuilder<String>(
                                      future: seriesViewModel
                                          .geSeriesImage(series[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            snapshot.data!.isEmpty) {
                                          return Container(
                                            height: 200.0,
                                            width: 150.0,
                                            color: Colors.grey,
                                            child: ColorFiltered(
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.saturation,
                                              ),
                                              child: Image.asset(
                                                Const.imgLogo,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        } else {
                                          String imageUrl = snapshot.data!;
                                          return FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: imageUrl,
                                            height: 200.0,
                                            width: 150.0,
                                            fit: BoxFit.cover,
                                            fadeInDuration: const Duration(
                                                milliseconds: 300),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 300),
                                            imageErrorBuilder:
                                                (context, url, error) =>
                                                    Container(
                                              height: 200.0,
                                              width: 150.0,
                                              color: Colors.grey,
                                              child: ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.grey,
                                                  BlendMode.saturation,
                                                ),
                                                child: Image.asset(
                                                  Const.imgLogo,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Const.colorPurpleMedium,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: Text(
                                      double.parse(series[index].ratingTvShow!)
                                          .toString(),
                                      style: Const.fontSubtitleTextStyle,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                series[index].titleTvShow!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Const.fontBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        'No favorite series found',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}
