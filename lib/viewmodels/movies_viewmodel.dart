import 'dart:convert';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_movies.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';
import 'package:app_movil_iptv/data/services/tmdb_service.dart';
import 'package:app_movil_iptv/data/services/validate_image.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MoviesViewModel {
  final Repository repository = Repository();
  final StorageService storageService = StorageService();

  Future<List<ClsCategory>> allCategoryMovies() async {
    List<ClsCategory> category = Globals.globalCategories;
    return category.where((x) => x.type == 'Movies').toList();
  }

  Future<List<ClsMovies>> allMovies(String category) async {
    List<ClsMovies> movies = Globals.globalMovies;
    if (category.isNotEmpty) {
      var x = movies.where((x) => x.categoryId == category).toList();
      return x;
    }
    return movies;
  }

  Future<List<ClsMovies>> allWMovies(String category) async {
    List<ClsMovies> movies = Globals.globalMovies;

// Filtrar las películas por categoría si se proporciona una
    if (category.isNotEmpty) {
      movies.where((movie) => movie.categoryId == category).map((movie) async {
        movie.streamImg = await getMovieImage(movie);
        return movie;
      }).toList();
    }

    // Obtener todas las imágenes de las películas de forma asíncrona
    await Future.forEach(movies, (ClsMovies movie) async {
      movie.streamImg = await getMovieImage(movie);
    });

    return movies;
  }

  Future<List<ClsMovies>> searchMovies(String category, String search) async {
    List<ClsMovies> movies = Globals.globalMovies;
    if (category.isEmpty) {
      return movies
          .where(
              (x) => x.titleMovie!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      return movies
          .where((x) =>
              x.titleMovie!.toLowerCase().contains(search.toLowerCase()) &&
              x.categoryId == category)
          .toList();
    }
  }

  //CATCHUP
  Future<List<ClsMovies>> allMoviesCatchUp() async {
    List<ClsMovies> movies = Globals.globalCatchUpMovies;
    return movies;
  }

  Future<List<ClsMovies>> searchMoviesCatchUp(String search) async {
    List<ClsMovies> movies = Globals.globalCatchUpMovies;
    return movies
        .where(
            (x) => x.titleMovie!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToCatchUp(ClsMovies movie) async {
    List<ClsMovies> catchUpMovies = Globals.globalCatchUpMovies;
    int existingIndex =
        catchUpMovies.indexWhere((c) => c.idMovie == movie.idMovie);

    // Eliminar el último registro si se alcanza el límite de 50
    if (catchUpMovies.length >= 50) {
      catchUpMovies.removeLast();
    }

    if (existingIndex != -1) {
      // Mover el canal existente a la posición 0
      ClsMovies existingChannel = catchUpMovies[existingIndex];
      catchUpMovies.removeAt(existingIndex);
      catchUpMovies.insert(0, existingChannel);
    } else {
      // Agregar el nuevo canal en la posición 0
      catchUpMovies.insert(0, movie);
    }

    String jsonMovies = jsonEncode(catchUpMovies);
    Globals.globalCatchUpMovies = catchUpMovies;
    await Future.wait([
      storageService.writeSecureData('SessionJsonCatchUpMovies', jsonMovies),
    ]);
  }

  //FAVORITES
  Future<List<ClsMovies>> allMoviesFavorites() async {
    List<ClsMovies> movies = Globals.globalFavoriteMovies;
    return movies;
  }

  Future<List<ClsMovies>> searchMoviesFavorite(String search) async {
    List<ClsMovies> movies = Globals.globalFavoriteMovies;
    return movies
        .where(
            (x) => x.titleMovie!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToFavorites(ClsMovies movie) async {
    List<ClsMovies> favoriteMovies = Globals.globalFavoriteMovies;

    if (favoriteMovies.contains(movie)) {
      favoriteMovies.remove(movie);
      // updateMovieFavorite(movie, false);
      EasyLoading.showToast(
        'Movie "${movie.nameMovie}" removed from favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    } else {
      // movie.isFavorite = true;
      favoriteMovies.insert(0, movie);
      // updateMovieFavorite(movie, true);
      EasyLoading.showToast(
        'Movie "${movie.nameMovie}" added to favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    }

    String jsonMovies = jsonEncode(favoriteMovies);
    Globals.globalFavoriteMovies = favoriteMovies;
    await Future.wait([
      storageService.writeSecureData('SessionJsonFavoriteMovies', jsonMovies),
    ]);
  }

  bool isMovieFavorite(ClsMovies movie) {
    List<ClsMovies> favoriteMovies = Globals.globalFavoriteMovies;
    return favoriteMovies.contains(movie);
  }

//CARRUSELL
  Future<List<ClsMovies>> allPremierMovies() async {
    // Obtener la primera categoría que cumple las condiciones
    List<ClsCategory> categoryMovie = Globals.globalCategories;
    ClsCategory categoryObj = categoryMovie.firstWhere(
      (category) =>
          category.type == 'Movies' &&
          category.categoryName ==
              "P- Estrenos 2023", //.contains("P- Estrenos 2023"),
      orElse: () => ClsCategory(categoryId: '', categoryName: ''),
      // Valor por defecto si no se encuentra ninguna categoría que cumpla las condiciones
    );

    List<ClsMovies> movies = Globals.globalMovies;
    var uniqueMovies = <String>{};
    var filteredMovies = movies
        .where((x) => x.categoryId == categoryObj.categoryId)
        //UNIR CATEGORIA ESTRENOS
        //.where((x) => x.categories
        // .any((element) => element.name.toLowerCase().contains('estreno')))
        .where((movie) {
          // Verifica si el título de la película ya existe en uniqueMovies
          //o si hay algún título en uniqueMovies que es contenido por el título de la película actual
          var isDuplicate = uniqueMovies.any((title) =>
              title.contains(movie.titleMovie!.toLowerCase()) ||
              movie.titleMovie!.toLowerCase().contains(title));
          if (!isDuplicate) {
            // Agrega el título de la película actual a uniqueMovies
            uniqueMovies.add(movie.titleMovie!.toLowerCase());
            return true;
          }
          return false;
        })
        .toList()
        .reversed
        .toList();
    return filteredMovies;
  }

  Future<TMDBMovies> getAllDataMovies(ClsMovies movie) async {
    var movieTMDB = await TMDBService.tmdbApi.v3.search
        .queryMovies(movie.nameMovie!, language: "es-EC");

    final result = movieTMDB['results']?.isNotEmpty ?? false
        ? movieTMDB['results'][0]
        : null;
    int idTMDBMovie = result?["id"] ?? 0;
    String overview = result?['overview'] ?? "";
    String releaseDate = result?['release_date'] ?? "";
    double voteAverage = result?['vote_average'] ?? 7.23;
    String posterPath = await getMovieImage(movie);
    String urlTrailer = "";
    List<dynamic> genres = [];

    if (idTMDBMovie != 0) {
      var datosTMDBMovie = await TMDBService.tmdbApi.v3.movies
          .getDetails(idTMDBMovie, appendToResponse: 'videos');

      if (datosTMDBMovie['videos']['results']?.isNotEmpty ?? false) {
        String site = datosTMDBMovie['videos']['results'][0]['site'];
        String key = datosTMDBMovie['videos']['results'][0]['key'];
        urlTrailer = site == "YouTube"
            ? 'https://www.youtube.com/embed/$key?autoplay=1&controls=0'
            : 'https://player.vimeo.com/video/$key?autoplay=1&controls=0';
      }

      if (datosTMDBMovie['genres']?.isNotEmpty ?? false) {
        genres = datosTMDBMovie["genres"]
            .map((genre) => genre["name"].toString())
            .toList();
      }
    }

    return TMDBMovies(overview, releaseDate, posterPath, urlTrailer,
        voteAverage, genres.join(", "));
  }

  Future<String> getMovieImage(ClsMovies movie) async {
    String imageUrl = ''; // Variable para almacenar la URL de la imagen
    var response = await validateImage(movie.streamImg!);
    if (response) {
      imageUrl = movie.streamImg!;
    } else {
      var movieTMDB =
          await TMDBService.tmdbApi.v3.search.queryMovies(movie.titleMovie!);
      if (movieTMDB['results']?.isNotEmpty ?? false) {
        final result = movieTMDB['results'][0];
        imageUrl = result['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
            : '';
      }
    }

    return imageUrl;
  }

  void updateMovies(Function updateMovie) {
    var update = repository.loadMovies(false);
    updateMovie(update);
  }
}


class MoviesViewsModel {
  // Caché de imágenes de películas
  final Map<String, String> movieImageCache = {};

  // ...

  Future<String> getMovieImage(ClsMovies movie) async {
    String imageUrl = ''; // Variable para almacenar la URL de la imagen

    // Verificar si la imagen está en la caché
    if (movieImageCache.containsKey(movie.titleMovie)) {
      imageUrl = movieImageCache[movie.titleMovie]!;
    } else {
      var response = await validateImage(movie.streamImg!);
      if (response) {
        imageUrl = movie.streamImg!;
      } else {
        var movieTMDB =
            await TMDBService.tmdbApi.v3.search.queryMovies(movie.titleMovie!);
        if (movieTMDB['results']?.isNotEmpty ?? false) {
          final result = movieTMDB['results'][0];
          imageUrl = result['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
              : '';
        }
      }

      // Almacenar la imagen en la caché
      movieImageCache[movie.titleMovie!] = imageUrl;
    }

    return imageUrl;
  }

  // ...
}
