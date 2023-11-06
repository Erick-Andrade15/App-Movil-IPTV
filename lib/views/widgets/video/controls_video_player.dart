import 'dart:async';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_iptv/data/models/detailtvshows.dart';
import 'package:app_movil_iptv/data/models/tmdb/tmdb_detail_tvshows.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/series_viewmodel.dart';
import 'package:app_movil_iptv/viewmodels/tvlive_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ControlsVideoPlayer extends StatefulWidget {
  const ControlsVideoPlayer(
      {super.key,
      required this.controllervlc,
      required this.controlsVideoPlayer});
  final VlcPlayerController controllervlc;
  final ClsControlsVideoPlayer controlsVideoPlayer;

  @override
  State<ControlsVideoPlayer> createState() => _ControlsVideoPlayerState();
}

class _ControlsVideoPlayerState extends State<ControlsVideoPlayer> {
  late ClsControlsVideoPlayer _controlsVideoPlayer;
  late VlcPlayerController _controller;
  Widget appBarTitle = const Text("");

  //--------------------TV--------------------//
  TvLiveViewModel viewModelTvLive = TvLiveViewModel();
  late Future<List<ClsChannel>>? futureChannels;
  late Future<List<ClsCategory>>? futureCategory;
  late String titleCategory = "TODOS LOS CANALES";
  late String idCategorySearch = "";
  late ClsChannel? clsChannel;
  //TV LIVE

  late bool isTvLive = false;
  late bool simplifiedTV = false;
  //TVLIVE DRAWER
  String appBarTitleTvLive = "TODOS LOS CANALES";

  // Variable para almacenar la función de actualización de futureChannelGlobal
  late Function(ClsChannel) updateFutureGlobalChannel;

  //--------------------MOVIES--------------------//

  //--------------------SERIES--------------------//

  //SERIES ENDRAWER
  SeriesViewModel viewModelSeries = SeriesViewModel();
  late Future<List<int>>? futureSeasonsList;

  //SERIES
  late int tvShowIdTmdb;
  late String tvShowName;
  late int tvShowSeason;
  late int tvShowEpisode;
  bool isTvShow = false;

  //CONTROLS
  bool showsControls = false;
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;
  double sliderValue = 0.0;
  String position = '';
  String duration = '';
  bool validPosition = false;
  //ADELANTAR Y RETROCEDER DOBLE TAP
  bool showVideoNavigationIcon = false;
  bool isForwardTap = false;
  bool isBackwardTap = false;
  //TIEMPO DE ADELANTAR O RETROCEDER
  static const Duration _seekStepForward = Duration(seconds: 10);
  static const Duration _seekStepBackward = Duration(seconds: -10);
  //ASPECT RADIO
  int aspectRatioIndex = 0;
  List<String> aspectRatios = [
    '16:9',
    '4:3',
    '3:2',
    '1:1',
  ];
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controllervlc;
    _controlsVideoPlayer = widget.controlsVideoPlayer;

    switch (_controlsVideoPlayer.videoType) {
      case VideoType.movie:
        // Código para películas
        _controller.addListener(listener);
        appBarTitle = Text(_controlsVideoPlayer.clsMovies!.nameMovie!);
        break;
      case VideoType.series:
        // Código para series
        _controller.addListener(listener);
        tvShowIdTmdb = _controlsVideoPlayer.idTMDB!;
        isTvShow = true;

        appBarTitle = Text(_controlsVideoPlayer.clsMovies!.nameMovie!);
        break;
      case VideoType.tvChannel:
        // Código para canales de TV
        futureChannels = viewModelTvLive.allChannels('');
        futureCategory = viewModelTvLive.allCategoryTV();

        isTvLive = true;

        clsChannel = _controlsVideoPlayer.clsChannel!;
        updateFutureGlobalChannel =
            _controlsVideoPlayer.updateFutureChannelGlobal!;
        break;
      case VideoType.simplifiedTV:
        // Código para canales de TV SIMPLE

        simplifiedTV = true;
        break;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      numberOfCaptions = _controller.value.spuTracksCount;
      numberOfAudioTracks = _controller.value.audioTracksCount;
      setState(() {});
    }
  }

  void changeAspectRatio(BuildContext context) {
    aspectRatioIndex = (aspectRatioIndex + 1) % aspectRatios.length;
    String nextAspectRatio = aspectRatios[aspectRatioIndex];
    _controller.setVideoAspectRatio(nextAspectRatio);
    // Variable para controlar si el diálogo ya ha sido cerrado
    bool dialogClosed = false;

    //MOSTRAR SHOWDIALOG DE ASPCT RADIO
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Color de barrera transparente
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent, // Fondo transparente
            content: Center(
              child: Text(
                aspectRatios[aspectRatioIndex],
                style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Const.colorWhite),
              ),
            ));
      },
    ).then((value) {
      // Este código se ejecutará cuando el diálogo se haya cerrado
      if (!dialogClosed) {
        dialogClosed = true; // Marcar el diálogo como cerrado
        // Realizar acciones adicionales después de cerrar el diálogo aquí
      }
    });

    // Configurar la duración del diálogo
    const duration = Duration(seconds: 1);
    Timer(duration, () {
      if (!dialogClosed) {
        dialogClosed = true; // Marcar el diálogo como cerrado
        Navigator.of(context, rootNavigator: true).pop(); // Cerrar el diálogo
      }
    });
  }

  void _handleDrawer(bool isOpened) {
    if (!isOpened) {
      _play();
      setState(() {
        showsControls = false;
      });
    }
  }

  void updateChannel(ClsChannel channel) {
    //  tvLiveName = channel.name;
    //  tvLiveimg = channel.logo;
    //_controller.setMediaFromNetwork(channel.urlChannel!);
    setState(() {});
    Globals.channelUrl = channel;
    updateFutureGlobalChannel(channel);
  }

  void updateVideo(String url) {
    _controller.setMediaFromNetwork(url);
    setState(() {
      showsControls = false;
    });
  }

  List<ClsDetailTvShows> findEpisode(
      List<ClsDetailTvShows> allEpisodes, bool isNextEpisode) {
    return [];
  }

  Future<void> nextEpisode() async {}

  Future<void> previousEpisode() async {}

  Widget buildDrawer(double screenWidth) {
    return Drawer(
      width: screenWidth / 1.5,
      backgroundColor: Colors.black38,
      child: Row(
        children: [
          //LISTVIEW CATEGORIAS
          Expanded(
            child: Column(
              children: [
                //LOGO
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration:
                      const BoxDecoration(color: Const.colorPurpleMedium),
                  child: const Image(
                    image: AssetImage(Const.imgLogo),
                  ),
                ),
                Flexible(
                  child: Container(
                    color: Colors.black38,
                    child: FutureBuilder<List<ClsCategory>>(
                      future: futureCategory,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ));
                        } else {
                          var category = snapshot.data;
                          return category!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: category.length + 3,
                                  itemBuilder: (context, index) {
                                    if (index < 3) {
                                      // Filas fijas
                                      if (index == 0) {
                                        return Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(Icons.timer,
                                                  color: Colors.indigo),
                                              title: const Text(
                                                "CATCH UP",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  appBarTitle =
                                                      const Text("CATCH UP");
                                                  titleCategory = "CATCH UP";
                                                  futureChannels =
                                                      viewModelTvLive
                                                          .allChannelsCatchUp();
                                                });
                                              },
                                            ),
                                            const Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        );
                                      } else if (index == 1) {
                                        return Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                Icons.favorite_border,
                                                color: Const.colorPinkAccent,
                                              ),
                                              title: const Text(
                                                "FAVORITE",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  appBarTitle =
                                                      const Text("FAVORITE");
                                                  titleCategory = "FAVORITE";
                                                  futureChannels = viewModelTvLive
                                                      .allChannelsFavorites();
                                                });
                                              },
                                            ),
                                            const Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: <Widget>[
                                            ListTile(
                                              title: const Text(
                                                "TODOS LOS CANALES",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  appBarTitle = const Text(
                                                      "TODOS LOS CANALES");
                                                  titleCategory =
                                                      "TODOS LOS CANALES";
                                                  futureChannels =
                                                      viewModelTvLive
                                                          .allChannels('');
                                                });
                                              },
                                            ),
                                            const Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        );
                                      }
                                    } else {
                                      final dataIndex = index - 3;
                                      // Restamos 3 para obtener el índice correcto en la lista de datos
                                      final item = category[dataIndex];
                                      // Obtenemos el dato correspondiente

                                      // Construir el widget correspondiente para los datos
                                      return Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              item.categoryName,
                                              style: Const.fontCaptionTextStyle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                titleCategory =
                                                    item.categoryName;
                                                appBarTitle =
                                                    Text(item.categoryName);
                                                idCategorySearch =
                                                    item.categoryId;
                                                futureChannels =
                                                    viewModelTvLive.allChannels(
                                                        item.categoryId);
                                              });
                                            },
                                          ),
                                          const Divider(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                )
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    Text(
                                      'No results found',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ],
                                );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          //LISTVIEW CANALES
          Expanded(
            child: Column(
              children: [
                //LOGO
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      titleCategory,
                      style: Const.fontSubtitleTextStyle,
                    ),
                  ),
                ),
                Flexible(
                  child: FutureBuilder<List<ClsChannel>>(
                    future: futureChannels,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ));
                      } else {
                        var channels = snapshot.data;
                        return channels!.isNotEmpty
                            ? ListView.builder(
                                itemCount: channels.length,
                                itemBuilder: (context, index) => Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        channels[index].nameChannel!,
                                        style: Const.fontCaptionTextStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        //AGREGAR AL CATCHUP
                                        viewModelTvLive
                                            .addToCatchUp(channels[index]);
                                        setState(() {
                                          //ACTUALIZAR CHANNEL

                                          Globals.channelUrl = channels[index];
                                        });
                                      },
                                      onLongPress: () {
                                        //AGREGAR A FAVORITOS
                                        viewModelTvLive
                                            .addToFavorites(channels[index])
                                            .then((value) {
                                          //ACTUALIZAR  FAVORITOS
                                          if (titleCategory == "FAVORITE") {
                                            setState(() {
                                              futureChannels = viewModelTvLive
                                                  .allChannelsFavorites();
                                            });
                                          }
                                        });
                                      },
                                      leading: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: channels[index].streamImg!,
                                        height: 50.0,
                                        width: 50.0,
                                        fadeInDuration:
                                            const Duration(milliseconds: 300),
                                        fadeOutDuration:
                                            const Duration(milliseconds: 300),
                                        imageErrorBuilder:
                                            (context, url, error) => Container(
                                          height: 50.0,
                                          width: 50.0,
                                          color: Colors.grey,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                                Colors.grey,
                                                BlendMode.saturation),
                                            child: Image.asset(
                                              Const.imgLogo,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  Text(
                                    'No results found',
                                    style: Const.fontBodyTextStyle,
                                  ),
                                ],
                              );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEndDrawer() {
    return Drawer(
      backgroundColor: Colors.black38,
      child: Column(
        children: [
          // Primera columna con la flecha de regreso y el título de la temporada
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.white),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        tvShowName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScaffoldTvLive(double widthScreen) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: showsControls
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                  iconSize: simplifiedTV ? 25 : 40,
                  onPressed: getCastDevices,
                  icon: const Icon(
                    Icons.cast,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  iconSize: simplifiedTV ? 25 : 40,
                  onPressed: () {
                    changeAspectRatio(context);
                  },
                  icon: const Icon(
                    Icons.aspect_ratio,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(),
            ),
      extendBodyBehindAppBar: true,
      drawer: isTvLive ? buildDrawer(widthScreen) : null,
      body: Visibility(
        visible: showsControls,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //END BAR
            Container(
              color: Colors.black38,
              child: Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: clsChannel!.streamImg!,
                        height: simplifiedTV ? 75 : 150.0,
                        width: simplifiedTV ? 75 : 150.0,
                        fadeInDuration: const Duration(milliseconds: 300),
                        fadeOutDuration: const Duration(milliseconds: 300),
                        imageErrorBuilder: (context, url, error) => Container(
                          height: simplifiedTV ? 75 : 150.0,
                          width: simplifiedTV ? 75 : 150.0,
                          color: Colors.grey,
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: Image.asset(
                              Const.imgLogo,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Utils.horizontalSpace(10),
                      Center(
                          child: Text(
                        clsChannel!.nameChannel!,
                        style: simplifiedTV
                            ? Const.fontTitleTextStyle
                            : Const.fontHeaderTextStyle,
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildScaffoldMoviesSeries() {
    return Stack(
      children: [
        //BOTONES DE DOBLE TAP ADELANTAR
        AnimatedOpacity(
          opacity: showVideoNavigationIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 750),
          curve: Curves.decelerate,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: isBackwardTap
                    ? ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.elliptical(250, 500),
                        ),
                        child: Container(
                          color: Colors.white54,
                          child: const Center(
                            child: Icon(
                              Icons.replay_10,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: isForwardTap
                    ? ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.elliptical(250, 500),
                        ),
                        child: Container(
                          color: Colors.white54,
                          child: const Center(
                            child: Icon(
                              Icons.forward_10,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: showsControls
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: appBarTitle,
                  actions: [
                    Visibility(
                      visible: isTvShow,
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          _pause();
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: const Icon(
                          Icons.format_list_bulleted,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          tooltip: 'Get Subtitle Tracks',
                          iconSize: 40,
                          onPressed: getSubtitleTracks,
                          icon: const Icon(
                            Icons.closed_caption,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Const.colorPurpleMedium,
                                borderRadius: BorderRadius.circular(1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 2,
                              ),
                              child: Text(
                                '$numberOfCaptions',
                                style: const TextStyle(
                                  color: Const.colorWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          tooltip: 'Get Audio Tracks',
                          iconSize: 40,
                          onPressed: getAudioTracks,
                          icon: const Icon(
                            Icons.audiotrack,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Const.colorPurpleMedium,
                                borderRadius: BorderRadius.circular(1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 2,
                              ),
                              child: Text(
                                '$numberOfAudioTracks',
                                style: const TextStyle(
                                  color: Const.colorWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      iconSize: 40,
                      onPressed: getCastDevices,
                      icon: const Icon(
                        Icons.cast,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        changeAspectRatio(context);
                      },
                      icon: const Icon(
                        Icons.aspect_ratio,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(),
                ),
          extendBodyBehindAppBar: true,
          endDrawer: isTvShow ? buildEndDrawer() : null,
          onEndDrawerChanged: (isOpened) => _handleDrawer(isOpened),
          drawerScrimColor: Colors.transparent,
          endDrawerEnableOpenDragGesture: false,
          body: Visibility(
            visible: showsControls,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //TOP BAR
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Transform.translate(
                            offset: const Offset(0, 15),
                            child: FittedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Visibility(
                                    visible: isTvShow,
                                    child: IconButton(
                                      iconSize: 50,
                                      onPressed: previousEpisode,
                                      icon: const Icon(
                                        Icons.skip_previous,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 50,
                                    onPressed: () =>
                                        _seekRelative(_seekStepBackward),
                                    icon: const Icon(
                                      Icons.replay_10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 70,
                                    onPressed: _pause,
                                    icon: const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 50,
                                    onPressed: () =>
                                        _seekRelative(_seekStepForward),
                                    icon: const Icon(
                                      Icons.forward_10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Visibility(
                                    visible: isTvShow,
                                    child: IconButton(
                                      iconSize: 50,
                                      onPressed: nextEpisode,
                                      icon: const Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                              child: Slider(
                                activeColor:
                                    const Color.fromARGB(255, 89, 40, 202),
                                inactiveColor: Colors.white70,
                                value: sliderValue,
                                min: 0.0,
                                max: (!validPosition)
                                    ? 1.0
                                    : _controller.value.duration.inSeconds
                                        .toDouble(),
                                onChanged: validPosition
                                    ? _onSliderPositionChanged
                                    : null,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  position,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  duration,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: Builder(
        builder: (ctx) {
          // Variables para determinar las mitades de la pantalla
          final screenWidth = MediaQuery.of(context).size.width;
          final halfScreenWidth = screenWidth / 2;
          switch (_controller.value.playingState) {
            case PlayingState.initializing:
              Timer.periodic(const Duration(seconds: 2), (timer) {
                if (_controller.value.playingState !=
                    PlayingState.initializing) {
                  if (mounted) {
                    setState(() {});
                  }
                  timer.cancel(); // Detener el temporizador
                }
              });
              return Center(
                child: Lottie.asset(Const.aniLoading, height: 100),
              );
            case PlayingState.stopped:
              final double widthScreen = MediaQuery.of(context).size.width;
              return GestureDetector(
                onDoubleTap: () {
                  isTvLive ? _scaffoldKey.currentState?.openDrawer() : null;
                },
                child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  drawer: isTvLive ? buildDrawer(widthScreen) : null,
                  body: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_outlined,
                          size: 100,
                          color: Colors.white,
                        ),
                        Utils.horizontalSpace(10),
                        const Text(
                          'Video isuue\nTry another channel',
                          textAlign: TextAlign.center,
                          style: Const.fontTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              );

            case PlayingState.buffering:
              Timer.periodic(const Duration(seconds: 2), (timer) {
                if (_controller.value.playingState != PlayingState.buffering) {
                  setState(() {});
                  timer.cancel(); // Detener el temporizador
                }
              });
              return Center(
                child: Lottie.asset(Const.aniLoading, height: 100),
              );
            case PlayingState.paused:
              if (showsControls) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      showsControls = !showsControls;
                    });
                  },
                  onDoubleTap: () {},
                  onDoubleTapDown: (details) {
                    final touchPositionX = details.localPosition.dx;
                    setState(() {
                      // Determinar si el toque está en la mitad izquierda o derecha de la pantalla
                      if (touchPositionX < halfScreenWidth) {
                        // Lógica para retroceder en el video
                        isBackwardTap = true;
                        isForwardTap = false;
                        _seekRelative(_seekStepBackward);
                      } else {
                        // Lógica para avanzar en el video
                        isBackwardTap = false;
                        isForwardTap = true;
                        _seekRelative(_seekStepForward);
                      }
                      showVideoNavigationIcon = true;
                    });
                    Future.delayed(const Duration(milliseconds: 750), () {
                      setState(() {
                        showVideoNavigationIcon = false;
                        isBackwardTap = false;
                        isForwardTap = false;
                      });
                    });
                  },
                  child: Stack(
                    children: [
                      //BOTONES DE DOBLE TAP ADELANTAR
                      AnimatedOpacity(
                        opacity: showVideoNavigationIcon ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.decelerate,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: isBackwardTap
                                  ? ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        right: Radius.elliptical(250, 500),
                                      ),
                                      child: Container(
                                        color: Colors.white54,
                                        child: const Center(
                                          child: Icon(
                                            Icons.replay_10,
                                            color: Colors.white,
                                            size: 80,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: isForwardTap
                                  ? ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.elliptical(250, 500),
                                      ),
                                      child: Container(
                                        color: Colors.white54,
                                        child: const Center(
                                          child: Icon(
                                            Icons.forward_10,
                                            color: Colors.white,
                                            size: 80,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      Scaffold(
                        key: _scaffoldKey,
                        backgroundColor: Colors.transparent,
                        appBar: showsControls
                            ? AppBar(
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                title: appBarTitle,
                                actions: [
                                  Visibility(
                                    visible: isTvShow,
                                    child: IconButton(
                                      iconSize: 40,
                                      onPressed: () {
                                        _pause();
                                        _scaffoldKey.currentState!
                                            .openEndDrawer();
                                      },
                                      icon: const Icon(
                                        Icons.format_list_bulleted,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: getSubtitleTracks,
                                    icon: const Icon(
                                      Icons.closed_caption,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: getAudioTracks,
                                    icon: const Icon(
                                      Icons.audiotrack,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: getCastDevices,
                                    icon: const Icon(
                                      Icons.cast,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      changeAspectRatio(context);
                                    },
                                    icon: const Icon(
                                      Icons.aspect_ratio,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : PreferredSize(
                                preferredSize: const Size.fromHeight(0),
                                child: Container(),
                              ),
                        extendBodyBehindAppBar: true,
                        endDrawer: isTvShow ? buildEndDrawer() : null,
                        onEndDrawerChanged: (isOpened) =>
                            _handleDrawer(isOpened),
                        drawerScrimColor: Colors.transparent,
                        endDrawerEnableOpenDragGesture: false,
                        body: Visibility(
                          visible: showsControls,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //TOP BAR
                              Flexible(
                                flex: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 25, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Transform.translate(
                                          offset: const Offset(0, 15),
                                          child: FittedBox(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Visibility(
                                                  visible: isTvShow,
                                                  child: IconButton(
                                                    iconSize: 50,
                                                    onPressed: previousEpisode,
                                                    icon: const Icon(
                                                      Icons.skip_previous,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 50,
                                                  onPressed: () =>
                                                      _seekRelative(
                                                          _seekStepBackward),
                                                  icon: const Icon(
                                                    Icons.replay_10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 70,
                                                  onPressed: _play,
                                                  icon: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 50,
                                                  onPressed: () =>
                                                      _seekRelative(
                                                          _seekStepForward),
                                                  icon: const Icon(
                                                    Icons.forward_10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: isTvShow,
                                                  child: IconButton(
                                                    iconSize: 50,
                                                    onPressed: nextEpisode,
                                                    icon: const Icon(
                                                      Icons.skip_next,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            child: Slider(
                                              activeColor: const Color.fromARGB(
                                                  255, 89, 40, 202),
                                              inactiveColor: Colors.white70,
                                              value: sliderValue,
                                              min: 0.0,
                                              max: (!validPosition)
                                                  ? 1.0
                                                  : _controller
                                                      .value.duration.inSeconds
                                                      .toDouble(),
                                              onChanged: validPosition
                                                  ? _onSliderPositionChanged
                                                  : null,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                position,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                duration,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            case PlayingState.playing:
              final double widthScreen = MediaQuery.of(context).size.width;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    showsControls = !showsControls;
                  });
                },
                onDoubleTap: () {
                  !simplifiedTV
                      ? _scaffoldKey.currentState?.openDrawer()
                      : null;
                },
                onDoubleTapDown: !isTvLive
                    ? (details) {
                        final touchPositionX = details.localPosition.dx;
                        setState(() {
                          // Determinar si el toque está en la mitad izquierda o derecha de la pantalla
                          if (touchPositionX < halfScreenWidth) {
                            // Lógica para retroceder en el video
                            isBackwardTap = true;
                            isForwardTap = false;
                            _seekRelative(_seekStepBackward);
                          } else {
                            // Lógica para avanzar en el video
                            isBackwardTap = false;
                            isForwardTap = true;
                            _seekRelative(_seekStepForward);
                          }
                          showVideoNavigationIcon = true;
                        });
                        Future.delayed(const Duration(milliseconds: 750), () {
                          setState(() {
                            showVideoNavigationIcon = false;
                            isBackwardTap = false;
                            isForwardTap = false;
                          });
                        });
                      }
                    : (details) {},
                child: isTvLive
                    ? buildScaffoldTvLive(widthScreen)
                    : buildScaffoldMoviesSeries(),
              );

            case PlayingState.ended:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
              return Container();
            case PlayingState.error:
              return Container(
                height: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      size: 100,
                      color: Colors.white,
                    ),
                    Utils.horizontalSpace(10),
                    const Text(
                      'Oops! An error occurred\nwhile playing the media\nTry another channel',
                      textAlign: TextAlign.center,
                      style: Const.fontTitleTextStyle,
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> replay() async {
    await _controller.stop();
    await _controller.play();
  }

  Future<void> _play() async {
    if (!_controller.value.isPlaying) {
      await _controller.play();
    }
  }

  Future<void> _pause() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    }
  }

  /// Returns a callback which seeks the video relative to current playing time.
  Future<void> _seekRelative(Duration seekStep) async {
    await _controller.seekTo(_controller.value.position + seekStep);
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _controller.setTime(sliderValue.toInt() * 1000);
  }

  Future<void> getCastDevices() async {
    try {
      // Inicia el escaneo de lanzamiento
      await _controller.startRendererScanning();
      final castDevices = await _controller.getRendererDevices();
      //print('Available Cast Devices: $castDevices');
      if (castDevices.isNotEmpty) {
        if (!mounted) return;
        final String selectedCastDeviceName = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Display Devices'),
              content: SizedBox(
                width: double.minPositive,
                height: 150,
                child: ListView.builder(
                  itemCount: castDevices.keys.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < castDevices.keys.length
                            ? castDevices.values.elementAt(index).toString()
                            : 'Disconnect',
                      ),
                      leading: index < castDevices.keys.length
                          ? const Icon(Icons.tv)
                          : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          index < castDevices.keys.length
                              ? castDevices.keys.elementAt(index)
                              : "",
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
        if (selectedCastDeviceName.isNotEmpty) {
          await _controller.castToRenderer(selectedCastDeviceName);
        }
      } else {
        if (!mounted) return;
        EasyLoading.showError('Oops! No display\ndevices found! 📺😕');
      }
    } finally {
      // Detiene el escaneo de lanzamiento
      await _controller.stopRendererScanning();
      await Future.delayed(const Duration(milliseconds: 1500)); // Espera breve
    }
  }

  Future<void> getAudioTracks() async {
    if (!_controller.value.isPlaying) return;

    final audioTracks = await _controller.getAudioTracks();
    //
    if (audioTracks.isNotEmpty) {
      if (!mounted) return;
      final int selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Audio'),
            content: SizedBox(
              width: double.minPositive,
              height: 150,
              child: ListView.builder(
                itemCount: audioTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < audioTracks.keys.length
                          ? audioTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < audioTracks.keys.length
                            ? audioTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller.setAudioTrack(selectedAudioTrackId);
    }
  }

  Future<void> getSubtitleTracks() async {
    if (!_controller.value.isPlaying) return;

    final subtitleTracks = await _controller.getSpuTracks();
    //
    if (subtitleTracks.isNotEmpty) {
      if (!mounted) return;
      final int selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Subtitle'),
            content: SizedBox(
              width: double.minPositive,
              height: 150,
              child: ListView.builder(
                itemCount: subtitleTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < subtitleTracks.keys.length
                            ? subtitleTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller.setSpuTrack(selectedSubId);
    }
  }
}
