
import 'package:app_movil_iptv/data/repositories/repository.dart';

class SplashViewModel {
  final Repository repository = Repository();

  void decideNavigation(Function onStart) {
    var isLoggedIn = repository.isLoggedIn();
    onStart(isLoggedIn);
  }
}
