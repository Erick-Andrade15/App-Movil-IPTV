import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:app_movil_iptv/utils/globals.dart';

class TvLiveViewModel {
  final Globals globals = Globals();
  final Repository repository = Repository();

  Future<List<ClsCategory>> allCategoryTV() async {
    List<ClsCategory> category = Globals.globalCategoryList;
    return category.where((x) => x.type == 'TVLive').toList();
  }

  Future<List<ClsCategory>> searchCategoryTV(String search) async {
    List<ClsCategory> category = Globals.globalCategoryList;
    return category
        .where((x) =>
            x.type == 'TVLive' &&
            x.categoryName.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<List<ClsChannel>> allChannels(String category) async {
    List<ClsChannel> channels = Globals.globalChannelList;
    if (category.isNotEmpty) {
      return channels.where((x) => x.categoryId == category).toList();
    }
    return channels;
  }

  Future<List<ClsChannel>> searchChannels(
      String category, String search) async {
    List<ClsChannel> channels = Globals.globalChannelList;
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

  void updateChannels(Function updateChannel) {
    // var update = repository.loadChannels(false);
    // updateChannel(update);
  }
}
