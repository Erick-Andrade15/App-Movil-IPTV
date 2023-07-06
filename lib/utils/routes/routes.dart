import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/views/screens/home_page.dart';
import 'package:app_movil_iptv/views/screens/login_page.dart';
import 'package:app_movil_iptv/views/screens/settings/clear_cache.dart';
import 'package:app_movil_iptv/views/screens/settings/info_page.dart';
import 'package:app_movil_iptv/views/screens/settings/settings_page.dart';
import 'package:app_movil_iptv/views/screens/settings/speed_test_page.dart';
import 'package:app_movil_iptv/views/screens/settings/user_info.dart';
import 'package:app_movil_iptv/views/screens/spash_screen.dart';
import 'package:app_movil_iptv/views/screens/tvlive/tvlive_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.onboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());

      case RoutesName.tvlive:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TvLivePage());

      case RoutesName.movies:
      //  return MaterialPageRoute(
      //     builder: (BuildContext context) => const MoviesPage());

      case RoutesName.series:
      // return MaterialPageRoute(
      //    builder: (BuildContext context) => const SeriesPage());

      case RoutesName.settings:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SettingsPage());

      case RoutesName.userinfo:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserInfo());

      case RoutesName.clearcache:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ClearCache());

      case RoutesName.logout:
      // return MaterialPageRoute(
      //   builder: (BuildContext context) => const SettingsPage());

      case RoutesName.controlparental:
      // return MaterialPageRoute(
      //  builder: (BuildContext context) => const SettingsPage());

      case RoutesName.catchup:
      // return MaterialPageRoute(
      //builder: (BuildContext context) => const SettingsPage());

      case RoutesName.speedtest:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SpeedTestPage());

      case RoutesName.favorite:
      // return MaterialPageRoute(
      //  builder: (BuildContext context) => const SettingsPage());

      case RoutesName.infoapp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const InfoPage());

      case RoutesName.checkupdate:
      // return MaterialPageRoute(
      //    builder: (BuildContext context) => const SettingsPage());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }
}
