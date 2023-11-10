import 'dart:async';
import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/detailtvshows.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/data/services/network_api_service.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';

class Repository {
  final NetworkApiService apiServices = NetworkApiService();
  final StorageService storageService = StorageService();

  //var
  dynamic response;
  late ClsUsers userData;

  Future<void> logout(Function onsuccess) async {
    EasyLoading.show(status: 'Log Out...');
    if (await checkSession()) {
      deleteSession();
      EasyLoading.showSuccess('Log Out Success!');
      onsuccess();
    }
  }

  Future<bool> checkSession() async {
    var sessionUserData =
        await storageService.containsKeyInSecureData('SessionJsonUser');
    return sessionUserData;
  }

  //VALIDAMOS SI EXISTE LA SESSION USER AND SESSION PASS
  Future<bool> isLoggedIn() async {
    if (await checkSession()) {
      await Globals.loadGlobalsFromStorage();
      return true;
    }
    return false;
  }

  //VERIFICAMOS SI EL USUARIO EXISTE
  Future<bool> validateCredentials(String user, String pass) async {
    const url = 'player_api.php'; //'get.php';
    final parametersQuery = {'username': user, 'password': pass};
    try {
      dynamic jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));
      userData = ClsUsers.fromJson(jsonData);
      //EXISTE USUARIO
      if (userData.userInfo != null) {
        String jsonUserData = jsonEncode(userData);
        //CREAMOS EL LOCALSTORAGE DEL USUARIO
        storageService.writeSecureData('SessionJsonUser', jsonUserData);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  //LOGIN
  Future<void> login(
      String username, String password, Function onsuccess) async {
    EasyLoading.show(status: "Loading...\nPlease don't exit the app 😉");
    if (await validateCredentials(username, password)) {
      EasyLoading.dismiss();
      EasyLoading.show(
          status: 'Loading...\nThe channels, Movies\nand Tv shows');
      await loadM3u();
      EasyLoading.showSuccess('Great Success!');
      onsuccess();
    } else {
      EasyLoading.showError('Username or password is invalid.');
    }
  }

  //CARGAR M3U EN APP
  Future<void> loadM3u() async {
    List<ClsCategory> categories = [];
    List<ClsChannel> channels = [];
    List<ClsMovies> movies = [];
    List<ClsTvShows> tvShows = [];
    String jsonMovies, jsonChannels, jsonTvShows, jsonCategory;
    /* CATEGORIAS */
    //Categorias TVLIVE
    List<ClsCategory> categoryTV =
        await getCategories("get_live_categories", "TVLive");
    categories.addAll(categoryTV);
    //Categorias MOVIES
    List<ClsCategory> categoryMovies =
        await getCategories("get_vod_categories", "Movies");
    categories.addAll(categoryMovies);
    //Categorias SERIES
    List<ClsCategory> categorySeries =
        await getCategories("get_series_categories", "Series");
    categories.addAll(categorySeries);
    /* CHANNELS */
    channels = await getLiveChannels();
    /* MOVIES */
    movies = await getAllMovies();
    /* SERIES */
    tvShows = await getAllSeries();

    jsonChannels = jsonEncode(channels);
    jsonMovies = jsonEncode(movies);
    jsonTvShows = jsonEncode(tvShows);
    jsonCategory = jsonEncode(categories);

    await saveM3UToSecureStorage(
        jsonChannels, jsonMovies, jsonTvShows, jsonCategory);

    await Globals.loadGlobalsFromStorage();
  }

  //
  Future<List<ClsCategory>> getCategories(
      String typeCategory, String type) async {
    try {
      ClsUsers sessionUserData;
      if (userData.userInfo == null || userData.serverInfo == null) {
        dynamic localStorageUser =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(localStorageUser);
      }
      sessionUserData = userData;
      const url = 'player_api.php'; //'get.php';
      final parametersQuery = {
        'username': sessionUserData.userInfo?.username,
        'password': sessionUserData.userInfo?.password,
        "action": typeCategory,
      };
      List<dynamic> jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));
      List<ClsCategory> categories =
          jsonData.map((e) => ClsCategory.fromJson(e)).toList();

      if (typeCategory == 'get_live_categories') {
        categories = addFlagsTVLive(categories);
      }

      for (var category in categories) {
        category.type = type;
      }

      return categories;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  /// Channels Live
  Future<List<ClsChannel>> getLiveChannels() async {
    try {
      ClsUsers sessionUserData;
      //OJO
      if (userData.userInfo == null || userData.serverInfo == null) {
        dynamic localStorageUser =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(localStorageUser);
        // El objeto sessionUserData es nulo o está vacío, puedes manejar esta situación aquí
      }

      sessionUserData = userData;
      const url = 'player_api.php'; //'get.php';
      final parametersQuery = {
        'username': sessionUserData.userInfo?.username,
        'password': sessionUserData.userInfo?.password,
        "action": "get_live_streams",
      };
      List<dynamic> jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));

      List<ClsChannel> channels =
          jsonData.map((e) => ClsChannel.fromJson(e)).toList();

      // Modificar el campo urlStreamId
      for (var channel in channels) {
        // Construir la URL completa
        channel.urlChannel =
            '${sessionUserData.serverInfo?.serverProtocol}://${sessionUserData.serverInfo?.url}:${sessionUserData.serverInfo?.port}/${sessionUserData.userInfo?.username}/${sessionUserData.userInfo?.password}/${channel.idChannel}';
        // '${sessionUserData.serverInfo?.url}/${sessionUserData.userInfo?.username}/${sessionUserData.userInfo?.username}/${channel.idChannel}';
      }

      return channels;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  /// All Movies
  Future<List<ClsMovies>> getAllMovies() async {
    try {
      ClsUsers sessionUserData;
      if (userData.userInfo == null || userData.serverInfo == null) {
        dynamic localStorageUser =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(localStorageUser);
        // El objeto sessionUserData es nulo o está vacío, puedes manejar esta situación aquí
      }

      sessionUserData = userData;
      const url = 'player_api.php'; //'get.php';
      Map<String, dynamic> parametersQuery = {
        'username': sessionUserData.userInfo?.username,
        'password': sessionUserData.userInfo?.password,
        "action": "get_vod_streams",
      };
      List<dynamic> jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));
      //var list = jsonData.map((e) => ClsChannel.fromJson(e)).toList();
      List<ClsMovies> movies = jsonData
          .map((e) {
            if (e["name"] == null || e["title"] == null) {
              return null;
            }
            return ClsMovies.fromJson(e);
          })
          .where((movie) => movie != null)
          .cast<ClsMovies>() // Realiza un cast para quitar los nulos
          .toList();

      // Modificar el campo urlStreamId
      for (var movie in movies) {
        //Formato URL
        movie.urlMovie =
            '${sessionUserData.serverInfo?.serverProtocol}://${sessionUserData.serverInfo?.url}:${sessionUserData.serverInfo?.port}/movie/${sessionUserData.userInfo?.username}/${sessionUserData.userInfo?.password}/${movie.idMovie}.${movie.extensionUrl}';
        //ELIMINAR (2010) DE PELICULAS
        if (movie.titleMovie!.contains(RegExp(r'\((\d{4})\)'))) {
          movie.titleMovie =
              movie.titleMovie!.replaceAll(RegExp(r'\((\d{4})\)'), '').trim();
        }
      }

      return movies;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  /// Channels Series
  Future<List<ClsTvShows>> getAllSeries() async {
    try {
      ClsUsers sessionUserData;
      if (userData.userInfo == null || userData.serverInfo == null) {
        dynamic localStorageUser =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(localStorageUser);
        // El objeto sessionUserData es nulo o está vacío, puedes manejar esta situación aquí
      }

      sessionUserData = userData;
      const url = 'player_api.php'; //'get.php';
      final parametersQuery = {
        'username': sessionUserData.userInfo?.username,
        'password': sessionUserData.userInfo?.password,
        "action": "get_series",
      };
      List<dynamic> jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));
      List<ClsTvShows> series =
          jsonData.map((e) => ClsTvShows.fromJson(e)).toList();
      // Modificar el campo urlStreamId
      for (var serie in series) {
        //ELIMINAR (2010) DE SERIES
        if (serie.titleTvShow!.contains(RegExp(r'\((\d{4})\)'))) {
          serie.titleTvShow =
              serie.titleTvShow!.replaceAll(RegExp(r'\((\d{4})\)'), '').trim();
        }
      }
      return series;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  //CARGAR LOS CANALES - ACTUALIZAR
  Future<bool> loadChannels(bool isAllUpdate) async {
    try {
      String jsonChannel, jsonCategory;
      EasyLoading.show(status: 'Loading...\nThe Channels 📺');

      if (!isAllUpdate) {
        var jsonUserData =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(jsonDecode(jsonUserData!));
        if (userData.userInfo == null) {
          EasyLoading.showError('Failed to Update Channels.');
          return false;
        }
      }
      //ELIMINAR CATEGORIA TVLIVE
      Globals.globalCategories
          .removeWhere((category) => category.type == 'TVLive');
      //BUSCAR LAS CATEGORIAS DE TV LIVE
      List<ClsCategory> categoryTV =
          await getCategories("get_live_categories", "TVLive");
      //AGREGAR LAS CATEGORIAS DE TV LIVE
      Globals.globalCategories.addAll(categoryTV);
      jsonCategory = jsonEncode(Globals.globalCategories);

      //AGREGAMOS LOS CANALES
      List<ClsChannel> channels = await getLiveChannels();
      jsonChannel = jsonEncode(channels);

      //ACTUALIZAR FAVORITES
      for (int i = 0; i < Globals.globalFavoriteChannel.length; i++) {
        ClsChannel favoriteChannel = Globals.globalFavoriteChannel[i];
        //SI EL NOMBRE DEL CANAL ESTA EN FAVORITOS
        int index = channels.indexWhere(
          (channel) => channel.nameChannel == favoriteChannel.nameChannel,
        );
        if (index != -1) {
          // Actualiza los datos del canal favorito con los datos de channels
          Globals.globalFavoriteChannel[i] = channels[index];
        }
      }

      //ACTUALIZAR CATCH-UP
      for (int i = 0; i < Globals.globalCatchUpChannel.length; i++) {
        ClsChannel catchUpChannel = Globals.globalCatchUpChannel[i];
        // SI EL NOMBRE DEL CANAL ESTÁ EN CATCH-UP
        int index = channels.indexWhere(
          (channel) => channel.nameChannel == catchUpChannel.nameChannel,
        );
        if (index != -1) {
          // Actualiza los datos del canal de catch-up con los datos de channels
          Globals.globalCatchUpChannel[i] = channels[index];
        }
      }

      await Future.wait([
        storageService.writeSecureData('SessionJsonChannels', jsonChannel),
        storageService.writeSecureData('SessionJsonCategory', jsonCategory),
        storageService.writeSecureData('SessionJsonCatchUpChannels',
            jsonEncode(Globals.globalCatchUpChannel)),
        storageService.writeSecureData('SessionJsonFavoriteChannels',
            jsonEncode(Globals.globalFavoriteChannel)),
      ]);

      await Globals.loadGlobalsFromStorage();
      EasyLoading.showSuccess('Great Success!');
      return true;
    } catch (e) {
      return false;
    }
  }

  //CARGAR LAS PELICULAS - ACTUALIZAR
  Future<bool> loadMovies(bool isAllUpdate) async {
    try {
      String jsonMovies, jsonCategory;
      EasyLoading.show(status: 'Loading...\nThe Movies 🎥');
      if (!isAllUpdate) {
        var jsonUserData =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(jsonDecode(jsonUserData!));
        if (userData.userInfo == null) {
          EasyLoading.showError('Failed to Update Movies.');
          return false;
        }
      }
      //ELIMINAR CATEGORIA MOVIES
      Globals.globalCategories
          .removeWhere((category) => category.type == 'Movies');
      //BUSCAR LAS CATEGORIAS DE MOVIES
      List<ClsCategory> categoryMovies =
          await getCategories("get_vod_categories", "Movies");
      //AGREGAR LAS CATEGORIAS DE MOVIES
      Globals.globalCategories.addAll(categoryMovies);
      jsonCategory = jsonEncode(Globals.globalCategories);

      //AGREGAMOS LAS PELICULAS
      List<ClsMovies> movies = await getAllMovies();
      jsonMovies = jsonEncode(movies);

      await Future.wait([
        storageService.writeSecureData('SessionJsonMovies', jsonMovies),
        storageService.writeSecureData('SessionJsonCategory', jsonCategory),
      ]);

      await Globals.loadGlobalsFromStorage();
      EasyLoading.showSuccess('Great Success!');
      return true;
    } catch (e) {
      return false;
    }
  }

  //CARGAR LAS SERIES - ACTUALIZAR
  Future<bool> loadTvShows(bool isAllUpdate) async {
    try {
      String jsonTvShows, jsonCategory;
      EasyLoading.show(status: 'Loading...\nThe Tv Shows 📺🎬');
      if (!isAllUpdate) {
        var jsonUserData =
            await storageService.readSecureData('SessionJsonUser');
        userData = ClsUsers.fromJson(jsonDecode(jsonUserData!));
        if (userData.userInfo == null) {
          EasyLoading.showError('Failed to Update Tv Shows.');
          return false;
        }
      }

      //ELIMINAR CATEGORIA TVSHOWS
      Globals.globalCategories
          .removeWhere((category) => category.type == 'Series');
      //BUSCAR LAS CATEGORIAS DE SERIES
      List<ClsCategory> categorySeries =
          await getCategories("get_series_categories", "Series");
      //AGREGAR LAS CATEGORIAS DE SERIES
      Globals.globalCategories.addAll(categorySeries);
      jsonCategory = jsonEncode(Globals.globalCategories);

      //AGREGAMOS LAS SERIES
      List<ClsTvShows> tvShows = await getAllSeries();
      jsonTvShows = jsonEncode(tvShows);

      //CATEGORY
      jsonCategory = jsonEncode(Globals.globalCategories);

      await Future.wait([
        storageService.deleteSecureData('SessionJsonTvShows'),
        storageService.deleteSecureData('SessionJsonCategory'),
      ]);

      await Future.wait([
        storageService.writeSecureData('SessionJsonTvShows', jsonTvShows),
        storageService.writeSecureData('SessionJsonCategory', jsonCategory),
      ]);

      await Globals.loadGlobalsFromStorage();
      EasyLoading.showSuccess('Great Success!');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// DETAIL SERIE - SEASON EPISODE
  Future<ClsDetailTvShows?> getSerieDetails(String serieId) async {
    try {
      dynamic jsonUserData =
          await storageService.readSecureData('SessionJsonUser');
      userData = ClsUsers.fromJson(jsonDecode(jsonUserData));

      const url = 'player_api.php'; //'get.php';
      final parametersQuery = {
        'username': userData.userInfo?.username,
        'password': userData.userInfo?.password,
        "action": "get_series_info",
        "series_id": serieId,
      };
      dynamic jsonData =
          json.decode(await apiServices.getResponse(url, parametersQuery));

      if (jsonData != null) {
        ClsDetailTvShows detailTvShows = ClsDetailTvShows.fromJson(jsonData);

        // Modificar el campo urlEpisode de todos los objetos ClsEpisodeTvShow
        detailTvShows.episodesTvShows?.forEach((key, value) {
          value?.forEach((episode) {
            // Reemplaza "nueva_url" con la URL que desees asignar
            episode!.urlEpisode =
                '${userData.serverInfo?.serverProtocol}://${userData.serverInfo?.url}:${userData.serverInfo?.port}/series/${userData.userInfo?.username}/${userData.userInfo?.password}/${episode.idEpisode}.${episode.extensionUrl}';
          });
        });

        return detailTvShows;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

//ACTUALIZAR CONTENIDO
  Future<void> loadAllM3u() async {
    EasyLoading.show(status: 'Loading...\nThe channels, Movies\nand Tv shows');

    try {
      var jsonUserData = await storageService.readSecureData('SessionJsonUser');
      userData = ClsUsers.fromJson(jsonDecode(jsonUserData!));
      if (userData.userInfo == null) {
        EasyLoading.showError('An error occurred');
        return;
      }

      bool channelsLoaded = await loadChannels(true);
      bool moviesLoaded = await loadMovies(true);
      bool tvShowsLoaded = await loadTvShows(true);

      if (!channelsLoaded && !moviesLoaded && !tvShowsLoaded) {
        EasyLoading.showError('Error loading data');
      }
    } catch (error) {
      EasyLoading.showError('An error occurred');
    }
  }

//AGREGAR LAS BANDERAS DE LOS PAISES EN LA CATEGORIA
  List<ClsCategory> addFlagsTVLive(List<ClsCategory> categories) {
    Map<String, String> countryFlags = {
      "ARGENTINA": "🇦🇷",
      "BOLIVIA": "🇧🇴",
      "BRASIL": "🇧🇷",
      "CANADA": "🇨🇦",
      "CHILE": "🇨🇱",
      "COLOMBIA": "🇨🇴",
      "COSTA RICA": "🇨🇷",
      "CUBA": "🇨🇺",
      "ECUADOR": "🇪🇨",
      "EL SALVADOR": "🇸🇻",
      "ESPAÑA": "🇪🇸",
      "GUATEMALA": "🇬🇹",
      "HONDURAS": "🇭🇳",
      "MEXICO": "🇲🇽",
      "NICARAGUA": "🇳🇮",
      "PANAMA": "🇵🇦",
      "PARAGUAY": "🇵🇾",
      "PERU": "🇵🇪",
      "PUERTORICO": "🇵🇷",
      "REPUBLICA DOMINICANA": "🇩🇴",
      "USA": "🇺🇸",
      "URUGUAY": "🇺🇾",
      "ITALIA": "🇮🇹",
      "VENEZUELA": "🇻🇪"
    };

    List<ClsCategory> updatedCategories = [];
    for (var category in categories) {
      String categoryName = category.categoryName;
      if (countryFlags.containsKey(categoryName)) {
        category.categoryName += ' ${countryFlags[categoryName]!}';
      }
      updatedCategories.add(category);
    }

    return updatedCategories;
  }

  //AGREGAMOS LOCAL STORAGE
  Future<void> saveM3UToSecureStorage(String jsonChannels, String jsonMovies,
      String jsonTvShows, String jsonCategory) async {
    var list = jsonEncode([]);
    await Future.wait([
      storageService.writeSecureData('SessionJsonChannels', jsonChannels),
      storageService.writeSecureData('SessionJsonMovies', jsonMovies),
      storageService.writeSecureData('SessionJsonTvShows', jsonTvShows),
      storageService.writeSecureData('SessionJsonCategory', jsonCategory),
      storageService.writeSecureData('SessionJsonCatchUpChannels', list),
      storageService.writeSecureData('SessionJsonCatchUpMovies', list),
      storageService.writeSecureData('SessionJsonCatchUpSeries', list),
      storageService.writeSecureData('SessionJsonFavoriteChannels', list),
      storageService.writeSecureData('SessionJsonFavoriteMovies', list),
      storageService.writeSecureData('SessionJsonFavoriteSeries', list),
    ]);
  }

  //ELIMINAMOS LOCAL STORAGE
  void deleteSession() {
    storageService.deleteSecureData('SessionJsonUser');
    storageService.deleteSecureData('SessionJsonChannels');
    storageService.deleteSecureData('SessionJsonMovies');
    storageService.deleteSecureData('SessionJsonTvShows');
    storageService.deleteSecureData('SessionJsonCategory');
  }
}
