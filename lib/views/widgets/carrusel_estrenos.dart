import 'package:app_movil_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_iptv/data/models/movies.dart';
import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/home_viewmodel.dart';
import 'package:app_movil_iptv/viewmodels/movies_viewmodel.dart';
import 'package:app_movil_iptv/views/widgets/video/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CarruselEstrenos extends StatefulWidget {
  const CarruselEstrenos({super.key, required this.togglePlayingChannel});
  final Function(bool) togglePlayingChannel;

  @override
  State<CarruselEstrenos> createState() => _CarruselEstrenosState();
}

class _CarruselEstrenosState extends State<CarruselEstrenos> {
  MoviesViewModel viewModelMovies = MoviesViewModel();
  HomeViewModel viewModelHome = HomeViewModel();

  late String? fechaCaducidad;
  late String? nombreCuenta;
  late Future<List<ClsMovies>>? futureMovies;

  @override
  void initState() {
    ClsUsers? userAcount = Globals.globalUserAcount;
    nombreCuenta = userAcount?.userInfo?.username ?? '';
    String? expDate = userAcount?.userInfo?.expDate;
    fechaCaducidad = viewModelHome.expirationDate(expDate);
    futureMovies = viewModelMovies.allPremierMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FutureBuilder<List<ClsMovies>>(
              future: futureMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  final movies = snapshot.data;
                  return CarouselSlider.builder(
                    itemCount: movies!.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return GestureDetector(
                        onTap: () {
                          widget.togglePlayingChannel(false);
                          viewModelMovies.addToCatchUp(movies[index]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                  url: movies[index].urlMovie!,
                                  controls: ClsControlsVideoPlayer(
                                      videoType: VideoType.movie,
                                      clsMovies: movies[index]),
                                ),
                              )).then((value) {
                            widget.togglePlayingChannel(true);
                          });
                        }, //VER PELICULA REPRODUCTOR
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 150.0,
                                width: 100.0,
                                color: Colors.grey,
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
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
                              borderRadius: BorderRadius.circular(8.0),
                              child: FutureBuilder<String>(
                                future: viewModelMovies
                                    .getMovieImage(movies[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.data!.isEmpty) {
                                    return Container(
                                      height: 150.0,
                                      width: 100.0,
                                      color: Colors.grey,
                                      child: ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        ),
                                        child: Image.asset(
                                          Const.imgLogo,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  } else {
                                    String imageUrl = snapshot.data!;
                                    return FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: imageUrl,
                                      height: 150.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 300),
                                      imageErrorBuilder:
                                          (context, url, error) => Container(
                                        height: 150.0,
                                        width: 100.0,
                                        color: Colors.grey,
                                        child: ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Image.asset(
                                            Const.imgLogo,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      initialPage: 3,
                      viewportFraction: 0.3,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        //ESPACIO
        Utils.verticalSpace(5),
        //DATOS INFORMACION DE CUENTA
        RichText(
          text: TextSpan(
            text: 'User: ',
            style: Const.fontSubtitleTextStyle,
            children: [
              TextSpan(
                text: nombreCuenta,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Expiration: ',
            style: Const.fontSubtitleTextStyle,
            children: [
              TextSpan(
                text: fechaCaducidad,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
