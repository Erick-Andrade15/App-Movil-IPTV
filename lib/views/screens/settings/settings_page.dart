import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/viewmodels/settings_viewmodel.dart';
import 'package:app_movil_iptv/views/widgets/main_appbar.dart';
import 'package:app_movil_iptv/views/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FocusNode remoteFocusNode = FocusNode();
  //GRID VIEW
  final FocusNode focusNodeInfoUser = FocusNode();
  final FocusNode focusNodeClearCache = FocusNode();
  final FocusNode focusNodeLogOut = FocusNode();
  final FocusNode focusNodeControlParental = FocusNode();
  final FocusNode focusNodeCatchUp = FocusNode();
  final FocusNode focusNodeFavorites = FocusNode();
  final FocusNode focusNodeSpeedtest = FocusNode();
  final FocusNode focusNodeInfoApp = FocusNode();
  final FocusNode focusNodeUpdate = FocusNode();
  final FocusNode focusNodeTelegram = FocusNode();
  //MAIN APPBAR
  late FocusNode focusNodeButtomHome = FocusNode();
  late FocusNode focusNodeButtomUpdate = FocusNode();

  TabIndex indexTab = TabIndex.cardInfoUser;

  onKey(RawKeyEvent event) {
    debugPrint("EVENT");
    if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      debugPrint('Down');
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      debugPrint('Up');
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      debugPrint('Left');
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      debugPrint('Right');
    } else if (event.isKeyPressed(LogicalKeyboardKey.select)) {
      debugPrint("enter");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: remoteFocusNode,
      onKey: onKey,
      child: Scaffold(
        appBar: MainAppbar(
          pageRoute: 'settings_page',
          focusNodes: {
            'buttomSetting': focusNodeButtomHome,
            'buttomUpdate': focusNodeButtomUpdate,
          },
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: StaggeredGrid.count(
                crossAxisCount: 10,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: [
                  //CINES DE CNFIGURACION
                  //USER INFO
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context).pushNamed(RoutesName.userinfo);
                        },
                        colorBg: Const.colorPurpleMediumDark,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "User Info",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            )
                          ],
                        ),
                      )),
                  //CLEAR CACHE
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context)
                              .pushNamed(RoutesName.clearcache);
                        },
                        colorBg: Const.colorPurpleMedium,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cleaning_services_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Clear Cache",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            )
                          ],
                        ),
                      )),
                  //LOG OUT
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: SettingCard(
                        colorBg: Const.colorPurpleMediumDark,
                        onTapFuncion: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Log Out'),
                            content:
                                const Text('Are you sure you want to log out?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  SettingsViewModel().logOut(() {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            RoutesName.login,
                                            (Route<dynamic> route) => false);
                                  });
                                },
                                child: const Text('Log Out'),
                              ),
                            ],
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            )
                          ],
                        ),
                      )),
                  //CONTROL PARENTAL
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 3,
                      child: SettingCard(
                        onTapFuncion: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  'This feature will be available soon.',
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        colorBg: Const.colorPurpleMedium,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            RichText(
                              text: const TextSpan(
                                  text: "Parental\n",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Control",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold))
                                  ]),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )),

                  //SPEED TEST
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context).pushNamed(RoutesName.speedtest);
                        },
                        colorBg: Const.colorPurpleMediumDark,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Speed Test",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                  //CATCH UP
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context).pushNamed(RoutesName.catchup);
                        },
                        colorBg: Const.colorPurpleMedium,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Catch Up",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                  //TELEGRAM
                  StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {},
                        colorBg: Const.colorPurpleMedium,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.telegram_outlined,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      )),
                  //CHECK FOR UPDATE
                  StaggeredGridTile.count(
                      crossAxisCellCount: 4,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  'This feature will be available soon.',
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        colorBg: Const.colorPurpleMediumDark,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Check for update",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                            Icon(
                              Icons.update_outlined,
                              size: 50,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      )),
                  //INFO
                  StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context).pushNamed(RoutesName.infoapp);
                        },
                        colorBg: Const.colorPurpleMedium,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )),
                  //FAVORITE
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: SettingCard(
                        onTapFuncion: () {
                          Navigator.of(context).pushNamed(RoutesName.favorite);
                        },
                        colorBg: Const.colorPurpleMediumDark,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Favorites",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum TabIndex {
  //GRID VIEW
  cardInfoUser,
  cardClearCache,
  cardLogOut,
  cardControlParental,
  cardCatchUp,
  cardFavorites,
  cardSpeedtest,
  cardInfoApp,
  cardUpdate,
  cardTelegram,
  //MAIN APPBAR
  buttomUpdate,
  buttomSetting
}
