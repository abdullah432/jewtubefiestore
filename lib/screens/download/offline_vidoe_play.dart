import 'dart:ui';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class OfflineVideoPlayer extends StatefulWidget {
  final String oflineVideoPath;

  OfflineVideoPlayer({@required this.oflineVideoPath});

  @override
  _OfflineVideoPlayerState createState() =>
      _OfflineVideoPlayerState(oflineVideoPath);
}

class _OfflineVideoPlayerState extends State<OfflineVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool isOfline;
  String offlineVideoPath;

  _OfflineVideoPlayerState(this.offlineVideoPath);

  BetterPlayerController betterPlayerController;
  BetterPlayerDataSource betterPlayerDataSource;
  BetterPlayerControlsConfiguration controlsConfiguration;
  BetterPlayerConfiguration betterPlayerConfiguration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              BetterPlayer.file(offlineVideoPath),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            basenameWithoutExtension(offlineVideoPath),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
