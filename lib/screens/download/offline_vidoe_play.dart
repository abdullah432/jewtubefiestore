import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:path/path.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class OfflineVideoPlayer extends StatefulWidget {
  final String oflineVideoPath;

  OfflineVideoPlayer({@required this.oflineVideoPath});

  @override
  _OfflineVideoPlayerState createState() =>
      _OfflineVideoPlayerState(oflineVideoPath);
}

class _OfflineVideoPlayerState extends State<OfflineVideoPlayer>
    with SingleTickerProviderStateMixin {
  VideoModel videoModel;
  bool isOfline;
  String oflineVideoPath;

  _OfflineVideoPlayerState(this.oflineVideoPath);

  //offline file
  File file;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    file = File(oflineVideoPath);
    _videoPlayerController = VideoPlayerController.file(file);

    super.initState();
    initVideoPlayer();
    // //
    // _chewieController = ChewieController(
    //   // videoPlayerController: VideoPlayerController.network(videoModel.videoURL)..initialize(),
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   looping: true,
    //   // autoInitialize: true,
    // );
  }

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();

    print(_videoPlayerController.value.aspectRatio);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

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
              _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    )
                  : Container(
                      height: 320,
                      child: Center(child: CircularProgressIndicator()),
                    ),
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
                            basenameWithoutExtension(file.path),
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
