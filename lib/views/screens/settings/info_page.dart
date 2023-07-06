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
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
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
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Key Features:',
                        style: Const.fontTitleTextStyle,
                      ),
                      Utils.verticalSpace(5),
                      _buildFeatureItem(
                        icon: Icons.live_tv,
                        title: 'Live Channels',
                        description:
                            'Access a variety of live channels to watch your favorite shows.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.movie,
                        title: 'Movies',
                        description:
                            'Explore our collection of movies and enjoy great entertainment.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.tv,
                        title: 'Series',
                        description:
                            'Discover exciting series of different genres and stay up to date with your episodes.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 32.0, color: Colors.white),
            Utils.horizontalSpace(5),
            Text(
              title,
              style: Const.fontSubtitleTextStyle,
            ),
          ],
        ),
        Utils.horizontalSpace(5),
        Text(
          description,
          style: Const.fontBodyTextStyle,
        ),
        Utils.verticalSpace(15),
      ],
    );
  }
}
