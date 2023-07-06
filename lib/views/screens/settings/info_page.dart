import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: const Text('Information'),
        backgroundColor: Colors.black38,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Const.imgBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              color: Const.colorPurpleDark.withOpacity(0.8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome to our application',
                            style: Const.fontHeaderTextStyle,
                          ),
                          Utils.verticalSpace(10),
                          const Text(
                            'Here you will find a wide selection of channels, movies, and series to enjoy on your device.',
                            style: Const.fontBodyTextStyle,
                          ),
                          Utils.verticalSpace(10),
                          const Text(
                            'Explore and enjoy all the available content in our application. Don\'t miss out!',
                            style: Const.fontBodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Utils.horizontalSpace(20),
                  const Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.live_tv,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: Text(
                            'Live Channels',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          subtitle: Text(
                            'Access a variety of live channels to watch your favorite shows.',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: Text(
                            'Movies',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          subtitle: Text(
                            'Explore our collection of movies and enjoy great entertainment.',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.tv,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: Text(
                            'Series',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          subtitle: Text(
                            'Discover exciting series of different genres and stay up to date with your episodes.',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
