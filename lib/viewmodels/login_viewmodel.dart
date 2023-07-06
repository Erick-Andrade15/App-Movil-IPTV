import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginViewModel {
  final Repository repository = Repository();

  void login(String email, String pass, Function onSuccess) {
    if (email.isNotEmpty && pass.isNotEmpty) {
      repository.login(email, pass, onSuccess);
    } else {
      EasyLoading.showError('Username or password is invalid.');
    }
  }
}
