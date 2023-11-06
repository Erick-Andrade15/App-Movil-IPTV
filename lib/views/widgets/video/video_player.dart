import 'package:app_movil_iptv/data/models/controls_videoplayer.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/views/widgets/video/controls_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:lottie/lottie.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.url, required this.controls});
  final String url;
  final ClsControlsVideoPlayer controls;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    super.initState();

    if (widget.controls.videoType != VideoType.simplifiedTV) {
    //  SystemChrome.setPreferredOrientations(
    //      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    _vlcPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _vlcPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9,
              placeholder: Center(
                child: Lottie.asset(Const.aniLoading,
                    repeat: true, reverse: true, height: 100),
              ),
            ),
          ),
          //BOTONES
          ControlsVideoPlayer(
            controllervlc: _vlcPlayerController,
            controlsVideoPlayer: widget.controls,
          ),
        ],
      ),
    );
  }
}
