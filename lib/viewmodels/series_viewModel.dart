import 'dart:convert';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_detail_tvshows.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_tvshows.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';
import 'package:app_movil_iptv/data/services/tmdb_service.dart';
import 'package:app_movil_iptv/data/services/validate_image.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SeriesViewModel {
  final Repository repository = Repository();
  final StorageService storageService = StorageService();

  Future<List<ClsCategory>> allCategorySeries() async {
    List<ClsCategory> category = Globals.globalCategories;
    return category.where((x) => x.type == 'Series').toList();
  }

  Future<List<ClsTvShows>> allSeries(String category) async {
    List<ClsTvShows> series = Globals.globalTvShows;
    if (category.isNotEmpty) {
      var x = series.where((x) => x.categoryId == category).toList();
      return x;
    }
    return series;
  }

  Future<List<ClsTvShows>> searchSeries(String category, String search) async {
    List<ClsTvShows> series = Globals.globalTvShows;
    if (category.isEmpty) {
      return series
          .where((x) =>
              x.titleTvShow!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      return series
          .where((x) =>
              x.titleTvShow!.toLowerCase().contains(search.toLowerCase()) &&
              x.categoryId == category)
          .toList();
    }
  }

  // CATCHUP DE SERIES
  Future<List<ClsTvShows>> allSeriesCatchUp() async {
    List<ClsTvShows> series = Globals.globalCatchUpTvShows;
    return series;
  }

  Future<List<ClsTvShows>> searchSeriesCatchUp(String search) async {
    List<ClsTvShows> series = Globals.globalCatchUpTvShows;
    return series
        .where(
            (x) => x.titleTvShow!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToCatchUpSeries(ClsTvShows tvShow) async {
    List<ClsTvShows> catchUpSeries = Globals.globalCatchUpTvShows;
    int existingIndex =
        catchUpSeries.indexWhere((c) => c.idTvShow == tvShow.idTvShow);

    // Eliminar el último registro si se alcanza el límite de 50
    if (catchUpSeries.length >= 50) {
      catchUpSeries.removeLast();
    }

    if (existingIndex != -1) {
      // Mover la serie existente a la posición 0
      ClsTvShows existingTvShow = catchUpSeries[existingIndex];
      catchUpSeries.removeAt(existingIndex);
      catchUpSeries.insert(0, existingTvShow);
    } else {
      // Agregar la nueva serie en la posición 0
      catchUpSeries.insert(0, tvShow);
    }

    String jsonSeries = jsonEncode(catchUpSeries);
    Globals.globalCatchUpTvShows = catchUpSeries;
    await Future.wait([
      storageService.writeSecureData('SessionJsonCatchUpSeries', jsonSeries),
    ]);
  }

// FAVORITOS DE SERIES
  Future<List<ClsTvShows>> allSeriesFavorites() async {
    List<ClsTvShows> series = Globals.globalFavoriteTvShows;
    return series;
  }

  Future<List<ClsTvShows>> searchSeriesFavorite(String search) async {
    List<ClsTvShows> series = Globals.globalFavoriteTvShows;
    return series
        .where(
            (x) => x.titleTvShow!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToFavoriteSeries(ClsTvShows tvShow) async {
    List<ClsTvShows> favoriteSeries = Globals.globalFavoriteTvShows;

    if (favoriteSeries.contains(tvShow)) {
      favoriteSeries.remove(tvShow);
      EasyLoading.showToast(
        'TV show "${tvShow.titleTvShow}" removed from favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    } else {
      favoriteSeries.insert(0, tvShow);
      EasyLoading.showToast(
        'TV show "${tvShow.titleTvShow}" added to favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    }

    String jsonSeries = jsonEncode(favoriteSeries);
    Globals.globalFavoriteTvShows = favoriteSeries;
    await Future.wait([
      storageService.writeSecureData('SessionJsonFavoriteSeries', jsonSeries),
    ]);
  }

  bool isSeriesFavorite(ClsTvShows tvShow) {
    List<ClsTvShows> favoriteSeries = Globals.globalFavoriteTvShows;
    return favoriteSeries.contains(tvShow);
  }

  Future<TMDBTvShows> getAllDataTvShows(ClsTvShows tvShows) async {
    var tvshowsTMDB = await TMDBService.tmdbApi.v3.search
        .queryTvShows(tvShows.titleTvShow!, language: "es-EC");

    int idTMDBTvShows = 0;
    String overview = "";
    String releaseDate = "";
    String posterPath = "";
    String urlTrailer = "";
    double voteAverage = double.parse(tvShows.ratingTvShow!.toString());
    List<String> genres = [];

    if (tvshowsTMDB['results']?.isNotEmpty ?? false) {
      final result = tvshowsTMDB['results'][0];
      idTMDBTvShows = result["id"];
      overview = result['overview'];
      releaseDate = result['first_air_date'];
      voteAverage = result['vote_average'];
      posterPath = 'https://image.tmdb.org/t/p/w500${result['poster_path']}';
    }

    var datosTMDBtvshows = await TMDBService.tmdbApi.v3.tv
        .getDetails(idTMDBTvShows, appendToResponse: 'videos');

    if (datosTMDBtvshows['videos']['results']?.isNotEmpty ?? false) {
      String site = datosTMDBtvshows['videos']['results'][0]['site'];
      String key = datosTMDBtvshows['videos']['results'][0]['key'];
      urlTrailer = site == "YouTube"
          ? 'https://www.youtube.com/embed/$key?autoplay=1&controls=0'
          : 'https://player.vimeo.com/video/$key?autoplay=1&controls=0';
    }
    if (datosTMDBtvshows['genres']?.isNotEmpty ?? false) {
      for (var genre in datosTMDBtvshows["genres"]) {
        genres.add(genre["name"]);
      }
    }

    return TMDBTvShows(idTMDBTvShows, overview, releaseDate, posterPath,
        urlTrailer, voteAverage, genres.join(", "));
  }

  Future<TMDBDetailTvShows> getAllDataEpisode(
      int idtvshow, int season, int episode) async {
    String nametitle = "";
    String overview = "";
    String posterPath = "";
    var tvshowsEpisodeTMDB = await TMDBService.tmdbApi.v3.tvEpisodes
        .getDetails(idtvshow, season, episode, language: "es-EC");
    if (tvshowsEpisodeTMDB['name']?.isNotEmpty ?? false) {
      nametitle = tvshowsEpisodeTMDB['name'];
    }
    if (tvshowsEpisodeTMDB['overview']?.isNotEmpty ?? false) {
      overview = tvshowsEpisodeTMDB['overview'];
    }
    if (tvshowsEpisodeTMDB['still_path']?.isNotEmpty ?? false) {
      posterPath =
          'https://image.tmdb.org/t/p/w500${tvshowsEpisodeTMDB['still_path']}';
    }

    return TMDBDetailTvShows(nametitle, overview, posterPath);
  }

  ///CONTROLS
  ///NEXT EPISODE

  Future<String> geSeriesImage(ClsTvShows movie) async {
    String imageUrl = ''; // Variable para almacenar la URL de la imagen
    var response = await validateImage(movie.streamImg!);
    if (response) {
      imageUrl = movie.streamImg!;
    } else {
      var movieTMDB =
          await TMDBService.tmdbApi.v3.search.queryTvShows(movie.titleTvShow!);
      if (movieTMDB['results']?.isNotEmpty ?? false) {
        final result = movieTMDB['results'][0];
        imageUrl = result['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
            : '';
      }
    }

    return imageUrl;
  }

  void updateSeries(Function updateSerie) {
    var update = repository.loadTvShows(false);
    updateSerie(update);
  }
}
