import 'dart:convert';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/data/services/storage_service.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TvLiveViewModel {
  final Globals globals = Globals();
  final Repository repository = Repository();
  final StorageService storageService = StorageService();

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

  //CATCHUP
  Future<List<ClsChannel>> allChannelsCatchUp() async {
    List<ClsChannel> channels = Globals.globalCatchUpChannel;
    return channels;
  }

  Future<List<ClsChannel>> searchChannelsCatchUp(String search) async {
    List<ClsChannel> channels = Globals.globalCatchUpChannel;
    return channels
        .where(
            (x) => x.nameChannel!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToCatchUp(ClsChannel channel) async {
    List<ClsChannel> catchUpChannels = Globals.globalCatchUpChannel;
    int existingIndex =
        catchUpChannels.indexWhere((c) => c.idChannel == channel.idChannel);

    // Eliminar el último registro si se alcanza el límite de 50
    if (catchUpChannels.length >= 50) {
      catchUpChannels.removeLast();
    }

    if (existingIndex != -1) {
      // Mover el canal existente a la posición 0
      ClsChannel existingChannel = catchUpChannels[existingIndex];
      catchUpChannels.removeAt(existingIndex);
      catchUpChannels.insert(0, existingChannel);
    } else {
      // Agregar el nuevo canal en la posición 0
      catchUpChannels.insert(0, channel);
    }

    String jsonChannels = jsonEncode(catchUpChannels);
    Globals.globalCatchUpChannel = catchUpChannels;
    await Future.wait([
      storageService.writeSecureData(
          'SessionJsonCatchUpChannels', jsonChannels),
    ]);
  }

  //FAVORITES
  Future<List<ClsChannel>> allChannelsFavorites() async {
    List<ClsChannel> channels = Globals.globalFavoriteChannel;
    return channels;
  }

  Future<List<ClsChannel>> searchChannelsFavorite(String search) async {
    List<ClsChannel> channels = Globals.globalFavoriteChannel;
    return channels
        .where(
            (x) => x.nameChannel!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> addToFavorites(ClsChannel channel) async {
    List<ClsChannel> favoriteChannels = Globals.globalFavoriteChannel;

    if (favoriteChannels.contains(channel)) {
      favoriteChannels.remove(channel);
      // updateChannelFavorite(channel, false);
      EasyLoading.showToast(
        'Channel  ${channel.nameChannel} removed from favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    } else {
      channel.isFavorite = true;
      favoriteChannels.insert(0, channel);
      // updateChannelFavorite(channel, true);
      EasyLoading.showToast(
        'Channel ${channel.nameChannel} added to favorites',
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.none,
      );
    }

    String jsonChannels = jsonEncode(favoriteChannels);
    Globals.globalFavoriteChannel = favoriteChannels;
    await Future.wait([
      storageService.writeSecureData(
          'SessionJsonFavoriteChannels', jsonChannels),
    ]);
  }

  void updateChannels(Function updateChannel) {
    var update = repository.loadChannels(false);
    updateChannel(update);
  }
}
