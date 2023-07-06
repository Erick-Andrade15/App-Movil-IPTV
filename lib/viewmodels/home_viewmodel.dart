import 'package:app_movil_iptv/data/repositories/repository.dart';
import 'package:intl/intl.dart';

class HomeViewModel {
  final Repository repository = Repository();

  void updateAllM3U() {
    //repository.loadAllM3u();
  }

  String expirationDate(String? timestamp) {
  try {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp ?? "") * 1000);

    var format = DateFormat("dd MMM, yyy").format(date);

    return format;
  } catch (e) {
    return "error date";
  }

}
}
