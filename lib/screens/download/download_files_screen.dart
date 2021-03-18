import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/downloaded_files.dart';
import 'package:jewtubefirestore/model/sqflite_helper.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share/share.dart';
import 'offline_vidoe_play.dart';

class DownloadFilesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DownloadFilesPageState();
  }
}

class DownloadFilesPageState extends State<DownloadFilesPage> {
  File file;

  @override
  void initState() {
    super.initState();
    if (Constant.downloadingVideosList.length > 0) {
      Constant.downloadingVideosList.forEach((videoModel) {
        isDownloaded(videoModel);
      });
    }
  }

  isDownloaded(VideoModel videoModel) async {
//    var contain = Resources.Constant.listOfDownloadedFiles
//        .where((element) => element.mp4Url == videoModel.mp4URL);
//    if (contain.isNotEmpty) downloaded = true;

    final hasPermission = Platform.isAndroid
        ? await Permission.storage.request().isGranted
        : true;

    if (hasPermission) {
      final externalDir = await getDownloadDirectory();
      print("Directory: ${externalDir.path}/videoModel.videoTitle.mp4");
      String loc =
          '${externalDir.path}/${videoModel.videoTitle.replaceAll(RegExp(r"\s+"), "_")}.mp4';
      File videoFile = new File(loc);
      if (videoFile.existsSync()) {
        var contain = Constant.listOfDownloadedFiles
            .where((element) => element.mp4Url == videoModel.mp4URL);
        if (contain.isEmpty) {
          DatabaseHelper databaseHelper = DatabaseHelper();
          //we need fileLocation, fileUrl, time
          DownloadedFile downloadedFile = DownloadedFile(
              mp4Url: videoModel.mp4URL,
              fileLocation: loc,
              downloadTime: DateTime.now().toString());
          int result =
              await databaseHelper.insertFile(downloadedFile: downloadedFile);
          if (result != 0) {
            //update DownloadedFilesList (inside Resourse class)
            setState(() {
              Methods.loadDownloadedFilesList();
            });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Downloads',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: Constant.listOfDownloadedFiles.length,
            itemBuilder: (BuildContext context, int index) {
              String filePath =
                  Constant.listOfDownloadedFiles[index].fileLocation;
              file = File(filePath);
              String filename = basenameWithoutExtension(file.path);
              getThumbnail(index);
              return GestureDetector(
                onTap: () {
                  navigateToOfflineVideoPlayPage(context, filePath);
                },
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      FutureBuilder<Uint8List>(
                        future: getThumbnail(index),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List> snapshot) {
                          // When this builder is called, the Future is already resolved into snapshot.data
                          // So snapshot.data contains the not-yet-correctly formatted Image.
                          if (!snapshot.hasData) {
                            return Container(
                              width: 140,
                              height: 80,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Image.memory(
                            snapshot.data,
                            fit: BoxFit.cover,
                            width: 160,
                            height: 90,
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          filename,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          shareFile(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.share, color: Colors.grey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(
                            context,
                            "Delete",
                            "Are you sure you want to delete this video",
                            index,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<Uint8List> getThumbnail(int index) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: Constant.listOfDownloadedFiles[index].fileLocation,
      imageFormat: ImageFormat.PNG,
      maxWidth: 140,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );

    return uint8list;
  }

  showAlertDialog(context, title, message, fileIndex) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              final hasPermission = Platform.isAndroid
                  ? await Permission.storage.request().isGranted
                  : true;

              if (hasPermission) {
                print("delete start");
                print("path: " +
                    Constant.listOfDownloadedFiles[fileIndex].fileLocation);

                // DatabaseHelper databaseHelper = DatabaseHelper();
                //   int result = await databaseHelper.deleteFile(
                //       id: Resources.Constant.listOfDownloadedFiles[fileIndex].id);

                //   if (result != 0) {
                //     setState(() {
                //       print("delete complete");
                //     });
                //   }

                file = File(
                    Constant.listOfDownloadedFiles[fileIndex].fileLocation);
                file.delete().whenComplete(() async {
                  DatabaseHelper databaseHelper = DatabaseHelper();
                  int result = await databaseHelper.deleteFile(
                      id: Constant.listOfDownloadedFiles[fileIndex].id);
                  print('result: ' + result.toString());
                  if (result != 0) {
                    updateDownloadedFilesList();
                  }
                });
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateDownloadedFilesList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<DownloadedFile>> filesListFuture =
          databaseHelper.getDownloadedFilesList();
      filesListFuture.then((downloadedFileList) {
        Constant.listOfDownloadedFiles = downloadedFileList;
        setState(() {});
      });
    });

    return;
  }

  Future<void> shareFile(index) async {
    await Share.shareFiles(
      [Constant.listOfDownloadedFiles[index].fileLocation],
      subject: 'Share Video',
      text: 'Share with friends',
    );
  }

  navigateToOfflineVideoPlayPage(context, String videoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => OfflineVideoPlayer(
          oflineVideoPath: videoPath,
        ),
      ),
    );
  }
}
