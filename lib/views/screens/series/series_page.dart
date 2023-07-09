import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/tvshows.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/series_viewmodel.dart';
import 'package:app_movil_iptv/views/screens/series/series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  SeriesViewModel viewModelSeries = SeriesViewModel();
  Widget appBarTitle = const Text("TODAS LAS SERIES");
  late String titleCategory = "TODAS LAS SERIES";
  late String idCategorySearch = "";

  late Future<List<ClsTvShows>>? futureSeries;
  late Future<List<ClsCategory>>? futureCategory;
  Icon actionIcon = const Icon(Icons.search);

  late bool isUpdateContent = false;

  @override
  void initState() {
    super.initState();
    futureSeries = viewModelSeries.allSeries('');
    futureCategory = viewModelSeries.allCategorySeries();
  }

  void searchSeries(String enteredKeyword) {
    switch (titleCategory) {
      case 'FAVORITE':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureSeries = viewModelSeries.allSeriesFavorites();
          });
        } else {
          setState(() {
            futureSeries = viewModelSeries.searchSeriesFavorite(enteredKeyword);
          });
        }
        break;
      case 'CATCH UP':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureSeries = viewModelSeries.allSeriesCatchUp();
          });
        } else {
          setState(() {
            futureSeries = viewModelSeries.searchSeriesCatchUp(enteredKeyword);
          });
        }
        break;
      case 'TODAS LAS SERIES':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureSeries = viewModelSeries.allSeries('');
          });
        } else {
          setState(() {
            futureSeries = viewModelSeries.searchSeries('', enteredKeyword);
          });
        }
        break;
      default:
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureSeries = viewModelSeries.allSeries(idCategorySearch);
          });
        } else {
          setState(() {
            futureSeries =
                viewModelSeries.searchSeries(idCategorySearch, enteredKeyword);
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isUpdateContent) {
          Navigator.pushReplacementNamed(context, RoutesName.home);
          return false; // Evitar que se realice el retroceso por defecto
        }
        return true; // Permitir el retroceso por defecto
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.black38,
          elevation: 0.0,
          leading: IconButton(
            iconSize: 40,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              isUpdateContent
                  ? Navigator.pushReplacementNamed(context, RoutesName.home)
                  : Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                iconSize: 40,
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    Widget bdtitleAppbar = Text(titleCategory.toString());
                    if (actionIcon.icon == Icons.search) {
                      actionIcon = const Icon(Icons.close);
                      appBarTitle = TextField(
                        onChanged: (value) => searchSeries(value),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.search, size: 30, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      switch (titleCategory) {
                        case 'FAVORITE':
                          futureSeries = viewModelSeries.allSeriesFavorites();
                          break;
                        case 'CATCH UP':
                          futureSeries = viewModelSeries.allSeriesCatchUp();
                          break;
                        case 'TODAS LAS SERIES':
                          futureSeries = viewModelSeries.allSeries('');
                          break;
                        default:
                          futureSeries =
                              viewModelSeries.allSeries(idCategorySearch);
                          break;
                      }
                      actionIcon = const Icon(Icons.search);
                      appBarTitle = bdtitleAppbar;
                    }
                  });
                },
                color: Colors.white),
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(1, 60, 0, 0),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 'updateSeries',
                      child: Row(
                        children: [
                          const Icon(Icons.update),
                          Utils.horizontalSpace(5),
                          const Text('Update Series'),
                        ],
                      ),
                    ),
                  ],
                ).then((selectedValue) {
                  // Aquí puedes manejar la opción seleccionada
                  if (selectedValue != null) {
                    switch (selectedValue) {
                      case 'updateSeries':
                        viewModelSeries
                            .updateSeries((Future<bool> isUpdate) async {
                          if (await isUpdate) {
                            setState(() {
                              switch (titleCategory) {
                                case 'FAVORITE':
                                  futureSeries =
                                      viewModelSeries.allSeriesFavorites();
                                  break;
                                case 'CATCH UP':
                                  futureSeries =
                                      viewModelSeries.allSeriesCatchUp();
                                  break;
                                case 'TODAS LAS SERIES':
                                  futureSeries = viewModelSeries.allSeries('');
                                  break;
                                default:
                                  futureSeries = viewModelSeries
                                      .allSeries(idCategorySearch);
                                  break;
                              }
                              futureCategory =
                                  viewModelSeries.allCategorySeries();
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
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
          child: SafeArea(
            child: Row(
              children: [
                //LISTVIEW CATEGORIAS
                Flexible(
                  flex: 3,
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
                                              minLeadingWidth: 20,
                                              leading: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                child: const Icon(
                                                  Icons.timer,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                              title: const Text(
                                                "CATCH UP",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  actionIcon =
                                                      const Icon(Icons.search);
                                                  appBarTitle =
                                                      const Text("CATCH UP");
                                                  titleCategory = "CATCH UP";
                                                  futureSeries = viewModelSeries
                                                      .allSeriesCatchUp();
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
                                              minLeadingWidth: 20,
                                              leading: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  color: Const.colorPinkAccent,
                                                ),
                                              ),
                                              title: const Text(
                                                "FAVORITE",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  actionIcon =
                                                      const Icon(Icons.search);
                                                  appBarTitle =
                                                      const Text("FAVORITE");
                                                  titleCategory = "FAVORITE";
                                                  futureSeries = viewModelSeries
                                                      .allSeriesFavorites();
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
                                                "TODAS LAS SERIES",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  actionIcon =
                                                      const Icon(Icons.search);
                                                  appBarTitle = const Text(
                                                      "TODAS LAS SERIES");
                                                  titleCategory =
                                                      "TODAS LAS SERIES";
                                                  futureSeries = viewModelSeries
                                                      .allSeries('');
                                                });
                                              },
                                              minLeadingWidth: 20,
                                              leading: Container(
                                                alignment: Alignment.center,
                                                width: 20,
                                                child: const Icon(
                                                  Icons.fiber_manual_record,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
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
                                              style: Const.fontBodyTextStyle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                actionIcon =
                                                    const Icon(Icons.search);
                                                titleCategory =
                                                    item.categoryName;
                                                appBarTitle =
                                                    Text(item.categoryName);
                                                idCategorySearch =
                                                    item.categoryId;
                                                futureSeries = viewModelSeries
                                                    .allSeries(item.categoryId);
                                              });
                                            },
                                            minLeadingWidth: 20,
                                            leading: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              child: const Icon(
                                                Icons.fiber_manual_record,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
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
                //LISTVIEW SERIES
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: double.infinity,
                    height: double.infinity,
                    child: FutureBuilder<List<ClsTvShows>>(
                      future: futureSeries,
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
                          var series = snapshot.data;
                          return series!.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 200,
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4),
                                  itemCount: series.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SerieDetailPage(
                                            clsTvShows: series[index],
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Container(
                                                  height: 150.0,
                                                  width: 100.0,
                                                  color: Colors.grey,
                                                  child: ColorFiltered(
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      Colors.grey,
                                                      BlendMode.saturation,
                                                    ),
                                                    child: Image.asset(
                                                      Const.imgLogo,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: FutureBuilder<String>(
                                                  future: viewModelSeries
                                                      .geSeriesImage(
                                                          series[index]),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting ||
                                                        snapshot
                                                            .data!.isEmpty) {
                                                      return Container(
                                                        height: 150.0,
                                                        width: 100.0,
                                                        color: Colors.grey,
                                                        child: ColorFiltered(
                                                          colorFilter:
                                                              const ColorFilter
                                                                  .mode(
                                                            Colors.grey,
                                                            BlendMode
                                                                .saturation,
                                                          ),
                                                          child: Image.asset(
                                                            Const.imgLogo,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      String imageUrl =
                                                          snapshot.data!;
                                                      return FadeInImage
                                                          .memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image: imageUrl,
                                                        height: 150.0,
                                                        width: 100.0,
                                                        fit: BoxFit.cover,
                                                        fadeInDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        fadeOutDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        imageErrorBuilder:
                                                            (context, url,
                                                                    error) =>
                                                                Container(
                                                          height: 150.0,
                                                          width: 100.0,
                                                          color: Colors.grey,
                                                          child: ColorFiltered(
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                              Colors.grey,
                                                              BlendMode
                                                                  .saturation,
                                                            ),
                                                            child: Image.asset(
                                                              Const.imgLogo,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color:
                                                      Const.colorPurpleMedium,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0)),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 8),
                                                child: Text(
                                                  double.parse(series[index]
                                                          .ratingTvShow!)
                                                      .toString(),
                                                  style: Const
                                                      .fontSubtitleTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            series[index].titleTvShow!,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Const.fontBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
