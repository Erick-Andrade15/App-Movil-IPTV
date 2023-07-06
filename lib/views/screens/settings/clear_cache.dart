import 'dart:async';

import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClearCache extends StatefulWidget {
  const ClearCache({super.key});

  @override
  State<ClearCache> createState() => _ClearCacheState();
}

class _ClearCacheState extends State<ClearCache> {
  void changePage() {
    _ClearCacheDir();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        Navigator.of(context).pop(RoutesName.settings);
        timer.cancel();
      },
    );
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Lottie.asset(Const.aniClearCache, width: width / 4)],
          ),
        ));
  }
}

// ignore: non_constant_identifier_names
Future<void> _ClearCacheDir() async {
  /*/var tempDir = await getTemporaryDirectory();
  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
  }*/
}
