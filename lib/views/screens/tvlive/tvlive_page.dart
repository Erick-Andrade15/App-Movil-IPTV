import 'dart:async';

import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/tvlive_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';

class TvLivePage extends StatefulWidget {
  const TvLivePage({super.key});

  @override
  State<TvLivePage> createState() => _TvLivePageState();
}

class _TvLivePageState extends State<TvLivePage> {
  TvLiveViewModel viewModelTvLive = TvLiveViewModel();
  Widget appBarTitle = const Text("TODOS LOS CANALES");
  late String titleCategory = "";
  late String idCategorySearch = "";

  late Future<List<ClsChannel>>? futureChannels;
  late Future<List<ClsCategory>>? futureCategory;
  late Future<ClsChannel>? futureChannelGlobal;
  Icon actionIcon = const Icon(Icons.search);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    futureChannelGlobal = Future.value(Globals.channelUrl);
    futureChannels = viewModelTvLive.allChannels('');
    futureCategory = viewModelTvLive.allCategoryTV();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  void searchChannels(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        futureChannels = viewModelTvLive.allChannels('');
      });
    } else {
      setState(() {
        futureChannels =
            viewModelTvLive.searchChannels(idCategorySearch, enteredKeyword);
      });
    }
  }

  void updateFutureChannel(ClsChannel newValue) {
    setState(() {
      futureChannelGlobal = Future.value(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isHorizontal = orientation == Orientation.landscape;
        if (isHorizontal) {
          return FutureBuilder<ClsChannel>(
            future: futureChannelGlobal,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ));
              } else {
                var channel = snapshot.data;
                return Container(
                  color: Colors.black,
                  child: Text(
                    channel!.urlChannel!,
                    style: Const.fontBodyTextStyle,
                  ),
                );
              }
            },
          );
        }
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
            child: SafeArea(
              child: Column(
                children: [
                  //TV LIVE
                  Flexible(
                    child: Container(
                      color: Colors.black,
                      height: 250,
                      child: FutureBuilder<ClsChannel>(
                        future: futureChannelGlobal,
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
                            var channel = snapshot.data;
                            return Text(
                              channel!.urlChannel!,
                              style: Const.fontBodyTextStyle,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  //APPBAR
                  PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: AppBar(
                      centerTitle: true,
                      title: appBarTitle,
                      backgroundColor: Colors.black38,
                      elevation: 0.0,
                      leading: IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        IconButton(
                          iconSize: 40,
                          icon: actionIcon,
                          onPressed: () {
                            setState(() {
                              Widget bdtitleAppbar = titleCategory.isEmpty
                                  ? const Text("TODOS LOS CANALES")
                                  : Text(titleCategory.toString());
                              if (actionIcon.icon == Icons.search) {
                                actionIcon = const Icon(Icons.close);
                                appBarTitle = TextField(
                                  onChanged: (value) => searchChannels(value),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search,
                                        size: 30, color: Colors.white),
                                    hintText: "Search...",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                );
                              } else {
                                futureChannels = viewModelTvLive
                                    .allChannels(idCategorySearch);
                                actionIcon = const Icon(Icons.search);
                                appBarTitle = bdtitleAppbar;
                              }
                            });
                          },
                          color: Colors.white,
                        ),
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(1, 300, 0, 0),
                              items: <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'updateChannels',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.update),
                                      Utils.horizontalSpace(5),
                                      const Text('Update Channels'),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((selectedValue) {
                              // Aquí puedes manejar la opción seleccionada
                              if (selectedValue != null) {
                                switch (selectedValue) {
                                  case 'updateChannels':
                                    viewModelTvLive.updateChannels(
                                        (Future<bool> isUpdate) async {
                                      if (await isUpdate) {
                                        setState(() {
                                          futureChannelGlobal =
                                              Future.value(Globals.channelUrl);
                                          futureChannels =
                                              viewModelTvLive.allChannels(
                                                  idCategorySearch.isNotEmpty
                                                      ? idCategorySearch
                                                      : '');
                                          futureCategory =
                                              viewModelTvLive.allCategoryTV();
                                        });
                                      }
                                    });
                                }
                              }
                            });
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  //LISTVIEW
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        //LISTVIEW CATEGORIAS
                        Expanded(
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
                                                      leading: const Icon(
                                                          Icons.timer,
                                                          color: Colors.indigo),
                                                      title: const Text(
                                                        "CATCH UP",
                                                        style: Const
                                                            .fontCaptionTextStyle,
                                                      ),
                                                      onTap: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                "Catch Up"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const Divider(
                                                      height: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                );
                                              } else if (index == 1) {
                                                return const Column(
                                                  children: <Widget>[
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.favorite_border,
                                                        color: Const
                                                            .colorPinkAccent,
                                                      ),
                                                      title: Text(
                                                        "FAVORITE",
                                                        style: Const
                                                            .fontCaptionTextStyle,
                                                      ),
                                                    ),
                                                    Divider(
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
                                                        style: Const
                                                            .fontCaptionTextStyle,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          appBarTitle = const Text(
                                                              "TODOS LOS CANALES");
                                                          titleCategory = "";
                                                          futureChannels =
                                                              viewModelTvLive
                                                                  .allChannels(
                                                                      '');
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
                                                      style: Const
                                                          .fontCaptionTextStyle,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        actionIcon = const Icon(
                                                            Icons.search);
                                                        titleCategory =
                                                            item.categoryName;
                                                        appBarTitle = Text(
                                                            item.categoryName);
                                                        idCategorySearch =
                                                            item.categoryId;
                                                        futureChannels =
                                                            viewModelTvLive
                                                                .allChannels(item
                                                                    .categoryId);
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
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        );
                                }
                              },
                            ),
                          ),
                        ),
                        //LISTVIEW CANALES
                        Expanded(
                          flex: 1,
                          child: FutureBuilder<List<ClsChannel>>(
                            future: futureChannels,
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
                                var channels = snapshot.data;
                                return channels!.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: channels.length,
                                        itemBuilder: (context, index) => Column(
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                channels[index].nameChannel!,
                                                style:
                                                    Const.fontCaptionTextStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  futureChannelGlobal =
                                                      Future.value(
                                                          channels[index]);
                                                  Globals.channelUrl =
                                                      channels[index];
                                                });
                                              },
                                              onLongPress: () {
                                                
                                              },
                                              leading:
                                                  FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image:
                                                    channels[index].streamImg!,
                                                height: 50.0,
                                                width: 50.0,
                                                fadeInDuration: const Duration(
                                                    milliseconds: 300),
                                                fadeOutDuration: const Duration(
                                                    milliseconds: 300),
                                                imageErrorBuilder:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 50.0,
                                                  width: 50.0,
                                                  color: Colors.grey,
                                                  child: ColorFiltered(
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.grey,
                                                            BlendMode
                                                                .saturation),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
