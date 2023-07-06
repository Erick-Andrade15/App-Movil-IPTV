import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_movies.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/data/services/tmdb_service.dart';
import 'package:app_movil_iptv/data/services/validate_image.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:http/http.dart' as http;

class MoviesViewModel {
  final Repository repository = Repository();

  Future<List<ClsCategory>> allCategoryMovies() async {
    List<ClsCategory> category = Globals.globalCategoryList;
    Map<String, dynamic> jsonCategory = {'name': 'TODO', 'type': 'Movies'};
    ClsCategory categoryObj = ClsCategory.fromJson(jsonCategory);
    if (!category.any((x) => x.categoryName == 'TODO' && x.type == 'Movies')) {
      category.insert(0, categoryObj);
    }
    return category.where((x) => x.type == 'Movies').toList();
  }

  Future<List<ClsCategory>> searchCategoryMovies(String search) async {
    List<ClsCategory> category = Globals.globalCategoryList;
    Map<String, dynamic> jsonCategry = {'name': 'TODO', 'type': 'Movies'};
    ClsCategory categoryObj = ClsCategory.fromJson(jsonCategry);
    if (!category.any((x) => x.categoryName == 'TODO' && x.type == 'Movies')) {
      category.insert(0, categoryObj);
    }
    return category
        .where((x) =>
            x.type == 'Movies' &&
            x.categoryName.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<List<ClsMovies>> allMovies(String category) async {
    List<ClsMovies> movies = Globals.globalMoviesList;
    if (category.isNotEmpty) {
      var x = movies.where((x) => x.categoryId == category).toList();
      return x;
    }
    return movies;
  }

  Future<List<ClsMovies>> searchMovies(String category, String search) async {
    List<ClsMovies> movies = Globals.globalMoviesList;
    if (category.isEmpty) {
      return movies
          .where(
              (x) => x.nameMovie!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      return movies
          .where((x) =>
              x.nameMovie!.toLowerCase().contains(search.toLowerCase()) &&
              x.categoryId == category)
          .toList();
    }
  }

  Future<List<ClsMovies>> allPremierMovies() async {
    // Obtener la primera categoría que cumple las condiciones
    List<ClsCategory> categoryMovie = Globals.globalCategoryList;
    ClsCategory categoryObj = categoryMovie.firstWhere(
      (category) =>
          category.type == 'Movies' &&
          category.categoryName ==
              "P- Estrenos 2023", //.contains("P- Estrenos 2023"),
      orElse: () => ClsCategory(categoryId: '', categoryName: ''),
      // Valor por defecto si no se encuentra ninguna categoría que cumpla las condiciones
    );

    List<ClsMovies> movies = Globals.globalMoviesList;
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

  Future<TMDBMovies> getCarruselMovies(String name, String urlImage) async {
    String posterPath = "";
    if (urlImage.isNotEmpty) {
      var response = await validateImage(urlImage);
      if (response) {
        posterPath = urlImage;
      } else {
        var movieTMDB = await TMDBService.tmdbApi.v3.search.queryMovies(name);
        if (movieTMDB['results']?.isNotEmpty ?? false) {
          final result = movieTMDB['results'][0];
          posterPath = result['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
              : '';
        }
      }
    }

    return TMDBMovies('', '', posterPath, '', 0, '');
  }

  Future<TMDBMovies> getDataMovies(String name, String urlImage) async {
    var movieTMDB = await TMDBService.tmdbApi.v3.search
        .queryMovies(name, language: "es-EC");
    String posterPath = "";
    double voteAverage = 7.23;
    if (movieTMDB['results']?.isNotEmpty ?? false) {
      final result = movieTMDB['results'][0];
      posterPath = 'https://image.tmdb.org/t/p/w500${result['poster_path']}';
      voteAverage = result['vote_average'];
    }

    if (urlImage.isNotEmpty) {
      var response = await http.get(Uri.parse(urlImage));
      if (response.statusCode == 200) {
        posterPath = urlImage;
      }
    }

    return TMDBMovies('', '', posterPath, '', voteAverage, '');
  }

  Future<TMDBMovies> getAllDataMovies(String name, String urlImage) async {
    var movieTMDB = await TMDBService.tmdbApi.v3.search
        .queryMovies(name, language: "es-EC");

    final result = movieTMDB['results']?.isNotEmpty ?? false
        ? movieTMDB['results'][0]
        : null;
    int idTMDBMovie = result?["id"] ?? 0;
    String overview = result?['overview'] ?? "";
    String releaseDate = result?['release_date'] ?? "";
    double voteAverage = result?['vote_average'] ?? 7.23;
    String posterPath =
        'https://image.tmdb.org/t/p/w500${result?['poster_path'] ?? ""}';
    String urlTrailer = "";
    List<dynamic> genres = [];

    if (urlImage.isNotEmpty) {
      if (Uri.parse(urlImage).isAbsolute) {
        var response = await http.get(Uri.parse(urlImage));
        if (response.statusCode == 200) {
          posterPath = urlImage;
        }
      }
    }

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

  void updateMovies(Function updateMovie) {
    var update = repository.loadMovies(false);
    updateMovie(update);
  }
}
