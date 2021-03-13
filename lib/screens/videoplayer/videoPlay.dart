import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/home/local_widgets/subscribewidget.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel videoModel;
  final VideoModel prevModel;

  VideoPlayerScreen({@required this.videoModel, this.prevModel});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(videoModel);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  // VideoPlayerController _videoPlayerController = VideoPlayerController.network(
  //       "https://d3ofruocozqolb.cloudfront.net/9b928440-9d6c-43a4-9150-1d10705c4d2a/hls/jewtube-_-_-a1fb300d-84b6-4c07-bc8d-9ad7eeced748-_-_-TalkingTom2(9).m3u8");
  VideoModel videoModel;
  List<VideoModel> _videoList = [];
  bool _progress = true;
  bool init = false;

  _VideoPlayerScreenState(this.videoModel);

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  List subList = [];

  // List<VideoModel> _videoList = List();
  // bool init = false;

  //to animate download icon
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Color beginColor = Colors.blueGrey;
  Color endColor = Colors.blue[900];
  bool downloaded = false;

  //Flutter download
  ReceivePort _port = ReceivePort();
  String fileLocation;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(videoModel.videoURL);
    //check if video is downloaded or not
    isDownloaded();
    super.initState();

    //
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      reverseDuration: Duration(seconds: 4),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: beginColor, end: endColor)
        .animate(_animationController);
    //
    initVideoPlayer();
    // _chewieController = ChewieController(
    //   // videoPlayerController: VideoPlayerController.network(videoModel.videoURL)..initialize(),
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   looping: true,
    //   aspectRatio: 16 / 9,
    //   // autoInitialize: true,
    // );

    /* Flutter download */
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      // print(_videoPlayerController.value.aspectRatio);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _animationController.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  isDownloaded() async {
//    var contain = Resources.listOfDownloadedFiles
//        .where((element) => element.mp4Url == videoModel.mp4URL);
//    if (contain.isNotEmpty) downloaded = true;

    // final hasPermission = Platform.isAndroid
    //     ? await Permission.storage.request().isGranted
    //     : true;

    // if (hasPermission) {
    //   final externalDir = await getDownloadDirectory();
    //   print("Directory: ${externalDir.path}/videoModel.videoTitle.mp4");
    //   String loc =
    //       '${externalDir.path}/${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4';
    //   File videoFile = new File(loc);
    //   if (videoFile.existsSync()) {
    //     if (mounted) {
    //       setState(() {
    //         downloaded = true;
    //       });
    //     } else {
    //       downloaded = true;
    //     }

    //     var contain = Resources.listOfDownloadedFiles
    //         .where((element) => element.mp4Url == videoModel.mp4URL);
    //     if (contain.isEmpty) {
    //       DatabaseHelper databaseHelper = DatabaseHelper();
    //       //we need fileLocation, fileUrl, time
    //       DownloadedFile downloadedFile = DownloadedFile(
    //           mp4Url: videoModel.mp4URL,
    //           fileLocation: loc,
    //           downloadTime: DateTime.now().toString());
    //       int result =
    //           await databaseHelper.insertFile(downloadedFile: downloadedFile);
    //       if (result != 0) {
    //         //update DownloadedFilesList (inside Resourse class)
    //         loadDownloadedFilesList();
    //       }
    //     }
    //   }
    // }
  }

  Future<Directory> getDownloadDirectory() async {
    return Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      print('Data: ' + data.toString());
      String id = data[0];
      DownloadTaskStatus status = data[1];

      if (status == DownloadTaskStatus.complete) {
        print("completed");
        _animationController.stop();
        setState(() {
          downloaded = true;
        });
        //save download data
        // DatabaseHelper databaseHelper = DatabaseHelper();
        // //we need fileLocation, fileUrl, time
        // DownloadedFile downloadedFile = DownloadedFile(
        //     mp4Url: videoModel.mp4URL,
        //     fileLocation: fileLocation,
        //     downloadTime: DateTime.now().toString());
        // int result =
        //     await databaseHelper.insertFile(downloadedFile: downloadedFile);
        // if (result != 0) {
        //   //update DownloadedFilesList (inside Resourse class)
        //   loadDownloadedFilesList();
        // }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        height: 400,
                        child: Center(child: CircularProgressIndicator())),
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
                              videoModel.videoTitle,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(videoModel.channelName)
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SubscribeWidget(
                            videoModel.sub,
                            onClick: (status) async {
                              // Response response = await Dio().post(
                              //     "http://${Resources.BASE_URL}/subscribe/add",
                              //     data: {
                              //       "userID": Resources.userID,
                              //       "ChannelID": videoModel.channelID
                              //     });

                              // setState(() {
                              //   videoModel.sub = status;
                              // });

                              // //getAllVideos();
                            },
                          ),
                          Row(
                            children: [
                              downloaded
                                  ? IconButton(
                                      onPressed: downloadFile,
                                      color: Colors.blueGrey,
                                      icon: Icon(Icons.cloud_done))
                                  : IconButton(
                                      onPressed: downloadFile,
                                      color: _colorAnimation.value,
                                      icon: Icon(Icons.file_download),
                                    ),
                              SizedBox(width: 12.0),
                              IconButton(
                                onPressed: shareLink,
                                color: Colors.blueGrey,
                                icon: Icon(Icons.share),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                _progress
                    ? Center(child: CircularProgressIndicator())
                    : _videoList.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              //load all videos
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: _videoList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    //I convert Car to Container to remove elevation and match to design
                                    child: Container(
                                      // elevation: 5,
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text('ChannelVideoWidget'),
                                      // child: ChannelVideoWidget(
                                      //     _videoList[index], () {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (builder) =>
                                      //               VideoPlayerScreen(
                                      //                   videoModel: _videoList[
                                      //                       index])));
                                      // }, () {
                                      //   // getAllVideos();
                                      // }, () {
                                      //   onDeleteButtonPressed(
                                      //       _videoList[index].videoId);
                                      // }),
                                    ),
                                  );
                                }),
                          )
                        : Center(child: Text("No Video Found"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> shareLink() async {
    await Methods.shareLink(video: videoModel);
  }

  Future<void> downloadFile() async {
    // if (!downloaded) {
    //   if (!Resources.downloadingVideosList.contains(videoModel)) {
    //     Resources.downloadingVideosList.add(videoModel);
    //   }
    //   beginColor = Colors.green;
    //   _colorAnimation = ColorTween(begin: beginColor, end: endColor)
    //       .animate(_animationController)
    //         ..addListener(() {
    //           setState(() {});
    //         });
    //   _animationController.repeat(reverse: true);
    //   final hasPermission = Platform.isAndroid
    //       ? await Permission.storage.request().isGranted
    //       : true;

    //   if (hasPermission) {
    //     final externalDir = await getDownloadDirectory();
    //     print("Directory: ${externalDir.path}/videoModel.videoTitle.mp4");
    //     fileLocation =
    //         '${externalDir.path}/${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4';

    //     final id = await FlutterDownloader.enqueue(
    //         url: videoModel.mp4URL,
    //         savedDir: externalDir.path,
    //         fileName:
    //             "${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4",
    //         showNotification: true,
    //         openFileFromNotification: false);
    //     showToast(message: "Downloading started.");
    //   } else {
    //     print("Permission Denied");
    //   }
    // } else {
    //   Methods.showToast(message: "Already Downloaded");
    // }
  }
}
