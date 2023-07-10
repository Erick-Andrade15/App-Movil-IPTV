import 'package:app_movil_iptv/data/models/category.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/movies_viewmodel.dart';
import 'package:app_movil_iptv/views/screens/movies/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  MoviesViewModel viewModelMovies = MoviesViewModel();
  Widget appBarTitle = const Text("TODAS LAS PELICULAS");
  late String titleCategory = "TODAS LAS PELICULAS";
  late String idCategorySearch = "";

  late Future<List<ClsMovies>>? futureMovies;
  late Future<List<ClsCategory>>? futureCategory;
  Icon actionIcon = const Icon(Icons.search);

  late bool isUpdateContent = false;

  @override
  void initState() {
    super.initState();
    futureMovies = viewModelMovies.allMovies('');
    futureCategory = viewModelMovies.allCategoryMovies();
  }

  void searchMovies(String enteredKeyword) {
    switch (titleCategory) {
      case 'FAVORITE':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureMovies = viewModelMovies.allMoviesFavorites();
          });
        } else {
          setState(() {
            futureMovies = viewModelMovies.searchMoviesFavorite(enteredKeyword);
          });
        }
        break;
      case 'CATCH UP':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureMovies = viewModelMovies.allMoviesCatchUp();
          });
        } else {
          setState(() {
            futureMovies = viewModelMovies.searchMoviesCatchUp(enteredKeyword);
          });
        }
        break;
      case 'TODAS LAS PELICULAS':
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureMovies = viewModelMovies.allMovies('');
          });
        } else {
          setState(() {
            futureMovies = viewModelMovies.searchMovies('', enteredKeyword);
          });
        }
        break;
      default:
        if (enteredKeyword.isEmpty) {
          setState(() {
            futureMovies = viewModelMovies.allMovies(idCategorySearch);
          });
        } else {
          setState(() {
            futureMovies =
                viewModelMovies.searchMovies(idCategorySearch, enteredKeyword);
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
                        onChanged: (value) => searchMovies(value),
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
                          futureMovies = viewModelMovies.allMoviesFavorites();

                          break;
                        case 'CATCH UP':
                          futureMovies = viewModelMovies.allMoviesCatchUp();
                          break;
                        case 'TODAS LAS PELICULAS':
                          futureMovies = viewModelMovies.allMovies('');
                          break;
                        default:
                          futureMovies =
                              viewModelMovies.allMovies(idCategorySearch);
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
                      value: 'updateMovies',
                      child: Row(
                        children: [
                          const Icon(Icons.update),
                          Utils.horizontalSpace(5),
                          const Text('Update Movies'),
                        ],
                      ),
                    ),
                  ],
                ).then((selectedValue) {
                  // Aquí puedes manejar la opción seleccionada
                  if (selectedValue != null) {
                    switch (selectedValue) {
                      case 'updateMovies':
                        viewModelMovies
                            .updateMovies((Future<bool> isUpdate) async {
                          if (await isUpdate) {
                            setState(() {
                              switch (titleCategory) {
                                case 'FAVORITE':
                                  futureMovies =
                                      viewModelMovies.allMoviesFavorites();
                                  break;
                                case 'CATCH UP':
                                  futureMovies =
                                      viewModelMovies.allMoviesCatchUp();
                                  break;
                                case 'TODAS LAS PELICULAS':
                                  futureMovies = viewModelMovies.allMovies('');
                                  break;
                                default:
                                  futureMovies = viewModelMovies
                                      .allMovies(idCategorySearch);
                                  break;
                              }
                              futureCategory =
                                  viewModelMovies.allCategoryMovies();
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
                                                  futureMovies = viewModelMovies
                                                      .allMoviesCatchUp();
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
                                                  futureMovies = viewModelMovies
                                                      .allMoviesFavorites();
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
                                                "TODAS LAS PELICULAS",
                                                style:
                                                    Const.fontCaptionTextStyle,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  actionIcon =
                                                      const Icon(Icons.search);
                                                  appBarTitle = const Text(
                                                      "TODAS LAS PELICULAS");
                                                  titleCategory =
                                                      "TODAS LAS PELICULAS";
                                                  futureMovies = viewModelMovies
                                                      .allMovies('');
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
                                                futureMovies = viewModelMovies
                                                    .allMovies(item.categoryId);
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
                //LISTVIEW PELICULAS
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: double.infinity,
                    height: double.infinity,
                    child: FutureBuilder<List<ClsMovies>>(
                      future: futureMovies,
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
                          var movies = snapshot.data;
                          return movies!.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 190,
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4),
                                  itemCount: movies.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailPage(
                                              clsMovies: movies[index],
                                            ),
                                          )),
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
                                                  future: viewModelMovies
                                                      .getMovieImage(
                                                          movies[index]),
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
                                                  double.parse(movies[index]
                                                          .ratingMovie!)
                                                      .toStringAsFixed(1)
                                                      .toString(),
                                                  style: Const
                                                      .fontSubtitleTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            movies[index].titleMovie!,
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
                                      style: Const.fontHeaderTextStyle,
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
