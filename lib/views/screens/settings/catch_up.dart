import 'package:app_movil_iptv/data/models/channel.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/viewmodels/tvlive_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CatchUpPage extends StatefulWidget {
  const CatchUpPage({super.key});

  @override
  State<CatchUpPage> createState() => _CatchUpPageState();
}

class _CatchUpPageState extends State<CatchUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TvLiveViewModel viewModelTvLive = TvLiveViewModel();
  late Future<List<ClsChannel>>? futureChannels;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    futureChannels = viewModelTvLive.allChannelsCatchUp();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: const Text('Catch Up'),
        backgroundColor: Colors.black38,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Channels'),
            Tab(text: 'Movies'),
            Tab(text: 'Series'),
          ],
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
              padding: const EdgeInsets.all(10.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  CatchUpChannelsWidget(catchUpChannels: futureChannels!),
                  const Center(child: Text('Favorite Movies')),
                  const Center(child: Text('Favorite Series')),
                ],
              ),
            ),
          )),
    );
  }
}

class CatchUpChannelsWidget extends StatelessWidget {
  final Future<List<ClsChannel>> catchUpChannels;

  const CatchUpChannelsWidget({Key? key, required this.catchUpChannels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<ClsChannel>>(
        future: catchUpChannels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading catch up channels'),
            );
          } else {
            var channels = snapshot.data;
            return channels!.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 60,
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Const.colorPurpleDarker,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Const.colorPurpleDark.withOpacity(0.8)),
                        child: ListTile(
                          title: Text(
                            channels[index].nameChannel!,
                            style: Const.fontCaptionTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: channels[index].streamImg!,
                            height: 50.0,
                            width: 50.0,
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 300),
                            imageErrorBuilder: (context, url, error) =>
                                Container(
                              height: 50.0,
                              width: 50.0,
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
                        'No catch up channels found',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}
