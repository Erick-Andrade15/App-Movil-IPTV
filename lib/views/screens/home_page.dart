import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/views/widgets/carrusel_estrenos.dart';
import 'package:app_movil_iptv/views/widgets/main_appbar.dart';
import 'package:app_movil_iptv/views/widgets/material_buttom.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ClsChannel>? futureChannelGlobal;
  late BuildContext pageContext;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    futureChannelGlobal = Future.value(Globals.channelUrl);
  }

  void togglePlaying(bool value) {
    setState(() {
      isPlaying = value;
    });
  }

  @override
  void dispose() {
    isPlaying = false; // Detiene la reproducción del video

    super.dispose();
  }

  void updateFutureChannel(ClsChannel newValue) {
    setState(() {
      futureChannelGlobal = Future.value(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        pageRoute: 'home_page',
        togglePlayingChannel: togglePlaying,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                //Item 1/2
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //CARRUSELL DE ESTRENOS
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: CarruselEstrenos(
                            togglePlayingChannel: togglePlaying,
                          ),
                        ),
                      ),
                      //REPRODUCTOR DE VIDEO
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              Globals.channelUrl!.nameChannel!,
                              style: Const.fontBodyTextStyle,
                            )),
                      ),
                    ],
                  ),
                ),

                //Item 2/2
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //BOTON VOD
                      ButtomMaterial(
                        texto: "Tv Live",
                        icono: Icons.live_tv_outlined,
                        colorBg: Const.colorPurpleDark,
                        onPresed: () {
                          setState(() {
                            isPlaying = false;
                          });
                          Navigator.of(context)
                              .pushNamed(RoutesName.tvlive)
                              .then((value) {
                            setState(() {
                              isPlaying = true;
                              futureChannelGlobal =
                                  Future.value(Globals.channelUrl);
                            });
                          });
                        },
                      ),
                      //BOTON PELICULAS
                      ButtomMaterial(
                        texto: "Movies",
                        icono: Icons.movie_outlined,
                        colorBg: Const.colorPurpleMediumDark,
                        onPresed: () {
                          setState(() {
                            isPlaying = false;
                          });
                          Navigator.of(context)
                              .pushNamed(RoutesName.movies)
                              .then((value) {
                            setState(() {
                              isPlaying = true;
                            });
                          });
                        },
                      ),

                      //BOTON SERIES
                      ButtomMaterial(
                        texto: "Series",
                        icono: Icons.tv_rounded,
                        colorBg: Const.colorPurpleDark,
                        onPresed: () {
                          setState(() {
                            isPlaying = false;
                          });
                          Navigator.of(context)
                              .pushNamed(RoutesName.series)
                              .then((value) {
                            setState(() {
                              isPlaying = true;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
