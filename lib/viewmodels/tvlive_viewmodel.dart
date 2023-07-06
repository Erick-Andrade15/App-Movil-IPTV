import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TvLiveViewModel {
  final Globals globals = Globals();
  final Repository repository = Repository();

  Future<List<ClsCategory>> allCategoryTV() async {
    List<ClsCategory> category = Globals.globalCategories;
    return category.where((x) => x.type == 'TVLive').toList();
  }

  Future<List<ClsChannel>> allChannels(String category) async {
    List<ClsChannel> channels = Globals.globalChannels;
    if (category.isNotEmpty) {
      return channels.where((x) => x.categoryId == category).toList();
    }
    return channels;
  }

  Future<List<ClsChannel>> searchChannels(
      String category, String search) async {
    List<ClsChannel> channels = Globals.globalChannels;
    if (category.isEmpty) {
      return channels
          .where((x) =>
              x.nameChannel!.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      return channels
          .where((x) =>
              x.nameChannel!.toLowerCase().contains(search.toLowerCase()) &&
              x.categoryId == category)
          .toList();
    }
  }

  Future<List<ClsChannel>> allChannelsFavorites() async {
    List<ClsChannel> channels = Globals.globalFavoriteChannel;
    return channels;
  }

  void updateChannels(Function updateChannel) {
    var update = repository.loadChannels(false);
    updateChannel(update);
  }

  void addToFavorites(ClsChannel channel) {
    List<ClsChannel> favoriteChannels = [];

    if (channel.isFavorite) {
      if (favoriteChannels.contains(channel)) {
        favoriteChannels.remove(channel);
      }
      favoriteChannels.insert(0, channel);
      channel.isFavorite = true; // Actualiza el valor a true

      EasyLoading.showToast(
        'Channel added to favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    } else {
      if (!favoriteChannels.contains(channel)) {
        favoriteChannels.insert(0, channel);
        EasyLoading.showToast(
          'Channel removed from favorites',
          duration: const Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.bottom,
          maskType: EasyLoadingMaskType.none,
        );
      }
    }
  }
}
