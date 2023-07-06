import 'dart:convert';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';

class Globals {
  static List<ClsCategory> globalCategories = [];
  static List<ClsChannel> globalChannels = [];
  static List<ClsMovies> globalMovies = [];
  static List<ClsTvShows> globalTvShows = [];
  static ClsUsers? globalUserAcount;
  static ClsChannel? channelUrl;
  //CATCHUP
  static List<ClsChannel> globalCatchUpChannel = [];
  static List<ClsMovies> globalCatchUpMovies = [];
  static List<ClsTvShows> globalCatchUpTvShows = [];
  //FAVORITES
  static List<ClsChannel> globalFavoriteChannel = [];
  static List<ClsMovies> globalFavoriteMovies = [];
  static List<ClsTvShows> globalFavoriteTvShows = [];

  static final storage = StorageService();

  static Future<void> loadGlobalsFromStorage() async {
    globalCategories = await loadCategoryList();
    globalChannels = await loadChannelList();
    globalMovies = await loadMoviesList();
    globalTvShows = await loadTvShowsList();
    globalUserAcount = await loadUser();
    channelUrl = globalChannels.elementAt(100);
    //CATCHUP
    //FAVORITES
  }

  static Future<ClsUsers> loadUser() async {
    var jsonUserData = await storage.readSecureData('SessionJsonUser');
    return ClsUsers.fromJson(jsonDecode(jsonUserData!));
  }

  static Future<List<ClsCategory>> loadCategoryList() async {
    List<ClsCategory> categoryList = [];
    var m3uCategory = await storage.readSecureData('SessionJsonCategory');
    List<dynamic> categoryData = jsonDecode(m3uCategory!);
    for (var element in categoryData) {
      categoryList.add(ClsCategory.fromJson(element));
    }
    return categoryList;
  }

  static Future<List<ClsChannel>> loadChannelList() async {
    List<ClsChannel> channelList = [];
    var m3uChannels = await storage.readSecureData('SessionJsonChannels');
    List<dynamic> channelData = jsonDecode(m3uChannels!);
    for (var element in channelData) {
      channelList.add(ClsChannel.fromJson(element));
    }
    return channelList;
  }

  static Future<List<ClsMovies>> loadMoviesList() async {
    List<ClsMovies> movieList = [];
    var m3uMovies = await storage.readSecureData('SessionJsonMovies');
    List<dynamic> movieData = jsonDecode(m3uMovies!);
    for (var element in movieData) {
      movieList.add(ClsMovies.fromJson(element));
    }
    return movieList;
  }

  static Future<List<ClsTvShows>> loadTvShowsList() async {
    List<ClsTvShows> tvShowList = [];
    var m3uTvShows = await storage.readSecureData('SessionJsonTvShows');
    List<dynamic> tvShowData = jsonDecode(m3uTvShows!);
    for (var element in tvShowData) {
      tvShowList.add(ClsTvShows.fromJson(element));
    }
    return tvShowList;
  }
}
