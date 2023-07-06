import 'dart:convert';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';

class Globals {
  static List<ClsCategory> globalCategoryList = [];
  static List<ClsChannel> globalChannelList = [];
  static List<ClsMovies> globalMoviesList = [];
  static List<ClsTvShows> globalTvShowsList = [];
  static ClsUsers? globalUserAcount;
  static ClsChannel? channelUrl;

  static final storage = StorageService();

  static Future<void> loadGlobalsFromStorage() async {
    globalCategoryList = await loadCategoryList();
    globalChannelList = await loadChannelList();
    globalMoviesList = await loadMoviesList();
    globalTvShowsList = await loadTvShowsList();
    globalUserAcount = await loadUser();
    channelUrl = globalChannelList.elementAt(100);
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
