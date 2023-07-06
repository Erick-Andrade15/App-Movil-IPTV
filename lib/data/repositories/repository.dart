import 'dart:async';
import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
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
            '${sessionUserData.serverInfo?.serverProtocol}://${sessionUserData.serverInfo?.url}:${sessionUserData.serverInfo?.port}/${sessionUserData.userInfo?.username}/${sessionUserData.userInfo?.username}/${channel.idChannel}';
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

      List<ClsMovies> movies =
          jsonData.map((e) => ClsMovies.fromJson(e)).toList();

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
      Globals.globalCategoryList
          .removeWhere((category) => category.type == 'TVLive');
      //BUSCAR LAS CATEGORIAS DE TV LIVE
      List<ClsCategory> categoryTV =
          await getCategories("get_live_categories", "TVLive");
      //AGREGAR LAS CATEGORIAS DE TV LIVE
      Globals.globalCategoryList.addAll(categoryTV);
      jsonCategory = jsonEncode(Globals.globalCategoryList);

      //AGREGAMOS LOS CANALES
      List<ClsChannel> channels = await getLiveChannels();
      jsonChannel = jsonEncode(channels);

      await Future.wait([
        storageService.writeSecureData('SessionJsonChannels', jsonChannel),
        storageService.writeSecureData('SessionJsonCategory', jsonCategory),
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
      Globals.globalCategoryList
          .removeWhere((category) => category.type == 'Movies');
      //BUSCAR LAS CATEGORIAS DE MOVIES
      List<ClsCategory> categoryMovies =
          await getCategories("get_vod_categories", "Movies");
      //AGREGAR LAS CATEGORIAS DE MOVIES
      Globals.globalCategoryList.addAll(categoryMovies);
      jsonCategory = jsonEncode(Globals.globalCategoryList);

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
      Globals.globalCategoryList
          .removeWhere((category) => category.type == 'Series');
      //BUSCAR LAS CATEGORIAS DE SERIES
      List<ClsCategory> categorySeries =
          await getCategories("get_series_categories", "Series");
      //AGREGAR LAS CATEGORIAS DE SERIES
      Globals.globalCategoryList.addAll(categorySeries);
      jsonCategory = jsonEncode(Globals.globalCategoryList);

      //AGREGAMOS LAS SERIES
      List<ClsTvShows> tvShows = await getAllSeries();
      jsonTvShows = jsonEncode(tvShows);

      //CATEGORY
      jsonCategory = jsonEncode(Globals.globalCategoryList);

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

//ACTUALIZAR CONTENIDO
  Future<void> loadAllM3u() async {
    EasyLoading.show(status: 'Loading...\nThe channels, Movies\nand Tv shows');

    try {
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
    await Future.wait([
      storageService.writeSecureData('SessionJsonChannels', jsonChannels),
      storageService.writeSecureData('SessionJsonMovies', jsonMovies),
      storageService.writeSecureData('SessionJsonTvShows', jsonTvShows),
      storageService.writeSecureData('SessionJsonCategory', jsonCategory),
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
