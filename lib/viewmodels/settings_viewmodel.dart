import 'package:app_movil_iptv/data/repositories/repository.dart';

class SettingsViewModel {
  final Repository repository = Repository();

  void logOut(Function onSuccess) {
    repository.logout(onSuccess);
  }

  void updateAllM3U() {
    //repository.loadAllM3u();
  }
}
