import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom]);

  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Const.colorWhite
    ..backgroundColor = Const.colorPurpleDarker
    ..indicatorColor = Const.colorWhite
    ..textColor = Const.colorWhite
    ..userInteractions = false
    ..dismissOnTap = false;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        initialRoute: RoutesName.onboard,
        onGenerateRoute: Routes.generateRoute,
        builder: EasyLoading.init(),
      ),
    );
  }
}
