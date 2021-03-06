import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtubefirestore/enum/downloadstatus.dart';
import 'package:jewtubefirestore/model/downloaded_files.dart';
import 'package:jewtubefirestore/model/sqflite_helper.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel videoModel;
  final VideoModel prevModel;

  VideoPlayerScreen({@required this.videoModel, this.prevModel});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(videoModel);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  VideoModel videoModel;
  bool init = false;

  _VideoPlayerScreenState(this.videoModel);

  BetterPlayerController betterPlayerController;
  BetterPlayerDataSource betterPlayerDataSource;
  BetterPlayerControlsConfiguration controlsConfiguration;
  BetterPlayerConfiguration betterPlayerConfiguration;
  List subList = [];

  VideosService videosService;
  List<VideoModel> recommendedVideosList;
  bool recommendedVideosListLoading = true;
  // bool init = false;

  //to animate download icon
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Color beginColor = Colors.blueGrey;
  Color endColor = Colors.blue[900];
  // bool downloaded = false;
  DownloadStatus downloadStatus = DownloadStatus.NOTSTARTED;

  //Flutter download
  ReceivePort _port = ReceivePort();
  String fileLocation;

  //download progress (Show download precentage when click on download button)
  String downloadProgress;

  bool videoStreched = false;

  @override
  void initState() {
    initVideoPlayer();
    //check if video is downloaded or not
    super.initState();
    /* Flutter download */
    if ((defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android)) {
      isDownloaded();
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
    }
    //
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      reverseDuration: Duration(seconds: 4),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: beginColor, end: endColor)
        .animate(_animationController);
    loadRecommendedVideosList();
  }

  void initVideoPlayer() {
    controlsConfiguration =
        BetterPlayerControlsConfiguration(enableSkips: false);
    betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: true,
      fit: BoxFit.contain,
      controlsConfiguration: controlsConfiguration,
    );
    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoModel.videoURL,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: videoModel.videoTitle,
        author: videoModel.channelName,
        imageUrl: videoModel.thumbNail,
        activityName: "MainActivity",
      ),
    );

    betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        betterPlayerController.setOverriddenAspectRatio(
            betterPlayerController.videoPlayerController.value.aspectRatio);
        setState(() {});
      }
    });
  }

  loadRecommendedVideosList() {
    videosService = Provider.of<VideosService>(context, listen: false);
    recommendedVideosList = videosService.loadRecommendedVideosList(videoModel);
    recommendedVideosListLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    disposeProcess();
    super.dispose();
  }

  disposeProcess() {
    _animationController?.dispose();
    betterPlayerController?.dispose();
    _unbindBackgroundIsolate();
  }

  isDownloaded() async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: 'SELECT * FROM task WHERE url = "${videoModel.videoURL}"');

    if (tasks.length != 0 && tasks[0].progress < 100) {
      downloadStatus = DownloadStatus.INPROGRESS;
      downloadProgress = tasks[0].progress.toString();
      //animate download icon
      beginColor = Colors.green;
      _colorAnimation = ColorTween(begin: beginColor, end: endColor)
          .animate(_animationController)
            ..addListener(() {
              setState(() {});
            });
      _animationController.repeat(reverse: true);
    } else {
      //Note: in download class mp4Url = videoURL
      var contain = Constant.listOfDownloadedFiles
          .where((element) => element.videoURL == videoModel.videoURL);
      // if (contain.isNotEmpty) downloaded = true;
      if (contain.isNotEmpty) downloadStatus = DownloadStatus.DOWNLOADED;

      final hasPermission = Platform.isAndroid
          ? await Permission.storage.request().isGranted
          : true;

      if (hasPermission) {
        final externalDir = await getDownloadDirectory();
        // print("Directory: ${externalDir.path}/${videoModel.videoTitle}.mp4");
        String loc =
            '${externalDir.path}/${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4';
        File videoFile = new File(loc);
        if (videoFile.existsSync()) {
          if (mounted) {
            setState(() {
              // downloaded = true;
              downloadStatus = DownloadStatus.DOWNLOADED;
            });
          } else {
            // downloaded = true;
            downloadStatus = DownloadStatus.NOTSTARTED;
          }

          var contain = Constant.listOfDownloadedFiles
              .where((element) => element.videoURL == videoModel.videoURL);
          if (contain.isEmpty) {
            DatabaseHelper databaseHelper = DatabaseHelper();
            //we need fileLocation, fileUrl, time
            DownloadedFile downloadedFile = DownloadedFile(
              videoURL: videoModel.videoURL,
              fileLocation: loc,
              downloadTime: DateTime.now().toString(),
            );
            int result =
                await databaseHelper.insertFile(downloadedFile: downloadedFile);
            if (result != 0) {
              //update DownloadedFilesList (inside Resourse class)
              Methods.loadDownloadedFilesList();
            }
          }
        }
      }
    }
  }

  Future<Directory> getDownloadDirectory() async {
    return Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
  }

  void _bindBackgroundIsolate() {
    try {
      bool isSuccess = IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      if (!isSuccess) {
        _unbindBackgroundIsolate();
        _bindBackgroundIsolate();
        return;
      }
      _port.listen((dynamic data) async {
        DownloadTaskStatus status = data[1];

        // final alltasks = await FlutterDownloader.loadTasks();

        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE url = "${videoModel.videoURL}"');
        print(tasks.toString());
        downloadProgress = tasks[0].progress.toString();
        //

        if (status == DownloadTaskStatus.complete) {
          //when completed done then get file location
          final externalDir = await getDownloadDirectory();
          fileLocation =
              '${externalDir.path}/${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4';
          _animationController.stop();
          setState(() {
            // downloaded = true;
            downloadStatus = DownloadStatus.DOWNLOADED;
          });
          //save download data
          DatabaseHelper databaseHelper = DatabaseHelper();
          //we need fileLocation, fileUrl, time
          DownloadedFile downloadedFile = DownloadedFile(
            videoURL: videoModel.videoURL,
            fileLocation: fileLocation,
            downloadTime: DateTime.now().toString(),
          );
          int result =
              await databaseHelper.insertFile(downloadedFile: downloadedFile);
          if (result != 0) {
            //update DownloadedFilesList (inside Resourse class)
            Methods.loadDownloadedFilesList();
          }
        } else if (status == DownloadTaskStatus.canceled ||
            status == DownloadTaskStatus.failed) {
          _animationController.stop();
          setState(() {});
        } else {
          print('status: ' + status.toString());
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

  void _unbindBackgroundIsolate() {
    if ((defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android)) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
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
              BetterPlayer(controller: betterPlayerController),
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
                        Row(
                          children: [
                            //download status
                            Text(
                              downloadProgress != null
                                  ? '$downloadProgress %'
                                  : '',
                              style: TextStyle(color: Colors.black),
                            ),
                            //download icon
                            downloadStatus == DownloadStatus.DOWNLOADED
                                ? IconButton(
                                    onPressed: () => downloadFile(),
                                    color: Colors.blueGrey,
                                    icon: Icon(Icons.cloud_done))
                                : IconButton(
                                    onPressed: () => downloadFile(),
                                    color: _colorAnimation.value,
                                    icon: Icon(Icons.file_download),
                                  ),
                            // SizedBox(width: 12.0),
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
              recommendedVideoListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  recommendedVideoListWidget() {
    return recommendedVideosListLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: recommendedVideosList.length,
            itemBuilder: (context, index) {
              return Container(
                // elevation: 5,
                padding: EdgeInsets.only(top: 16),
                child: VideoItemWidget2(
                  video: recommendedVideosList[index],
                  onDeletePressed: (video) {
                    Methods.showAlertDialog(
                      context: context,
                      dialog: CustomAlertDialog(
                        content: 'Are you sure you want to delete this video',
                        onConfirmClick: () {
                          Navigator.pop(context);
                          //delete
                          videosService.deleteVideo(context, video: video);
                        },
                      ),
                    );
                  },
                  onPlay: () {
                    betterPlayerController.pause();
                    // // _videoPlayerController.pause();
                    Methods.navigateToPage(
                      context,
                      VideoPlayerScreen(
                        videoModel: recommendedVideosList[index],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Future<void> shareLink() async {
    if ((defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android)) {
      await Methods.shareLink(video: videoModel);
    } else {
      Methods.showToast(
          message: "Share feature is not supported on web",
          toastLenght: Toast.LENGTH_LONG);
    }
  }

  Future<void> downloadFile() async {
    if ((defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android)) {
      if (downloadStatus != DownloadStatus.DOWNLOADED &&
          downloadStatus != DownloadStatus.INPROGRESS &&
          betterPlayerController != null) {
        //update downloadstatus
        downloadStatus = DownloadStatus.INPROGRESS;

        // if (!Constant.downloadingVideosList.contains(videoModel)) {
        //   Constant.downloadingVideosList.add(videoModel);
        // }
        beginColor = Colors.green;
        _colorAnimation = ColorTween(begin: beginColor, end: endColor)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              });
        _animationController.repeat(reverse: true);
        final hasPermission = Platform.isAndroid
            ? await Permission.storage.request().isGranted
            : true;

        if (hasPermission) {
          final externalDir = await getDownloadDirectory();

          // final id = await FlutterDownloader.enqueue(
          //   url: videoModel.videoURL,
          //   // url: DumyData.videourl3,
          //   // url: DumyData.exampleProfileUrl,
          //   savedDir: externalDir.path,
          //   fileName:
          //       "${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4",
          //   showNotification: true,
          //   openFileFromNotification: false,
          // );

          print(externalDir.path);

          FlutterDownloader.enqueue(
            url: videoModel.videoURL,
            savedDir: externalDir.path,
            showNotification: true,
            openFileFromNotification: true,
          );
          Methods.showToast(message: "Downloading started.");
        } else {
          print("Permission Denied");
        }
      } else {
        if (downloadStatus == DownloadStatus.DOWNLOADED)
          Methods.showToast(message: "Already Downloaded");
        else
          Methods.showToast(message: "Download is already in progress");
      }
    } else {
      Methods.showToast(
          message: "Download is not supported on web",
          toastLenght: Toast.LENGTH_LONG);
    }
  }
}
