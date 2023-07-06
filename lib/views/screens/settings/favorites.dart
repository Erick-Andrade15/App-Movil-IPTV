import 'package:app_movil_iptv/utils/consts.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Favorites'),
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
                children: const [
                  Center(child: Text('Favorite Channels')),
                  Center(child: Text('Favorite Movies')),
                  Center(child: Text('Favorite Series')),
                ],
              ),
            ),
          )),
    );
  }
}
