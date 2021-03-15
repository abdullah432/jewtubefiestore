import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/firebasestorageservice.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import 'package:provider/provider.dart';

class VideosService with ChangeNotifier {
  List<VideoModel> recommendedVideosList;
  List<VideoModel> videosList;
  bool isUploading = false;

  loadAllVideos(context) async {
    final database = Provider.of<FirestoreService>(context, listen: false);
    videosList = await database.loadAllVideos();
    notifyListeners();
  }

  loadRecommendedVideosList() {
    recommendedVideosList = DumyData.recommendedVideosList;
    notifyListeners();
  }

  Future<bool> uploadVideo(
      context, VideoModel video, customthumbnail, videofile) async {
    // isUploading = true;
    // notifyListeners();
    if (customthumbnail != null) {
      //upload thumbnail to firestore
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      //if pass video then it will return video url and it's thumbnail url
      List<String> downloadurls = await storage.uploadFileToStorage(
          channeluid: video.channelID, file: customthumbnail);

      String thumbnailurl = downloadurls[0];

      video.thumbNail = thumbnailurl;
    }

    //now upload data to database
    final database = Provider.of<FirestoreService>(context, listen: false);
    bool result = await database.uploadVideo(video);
    // isUploading = false;
    // notifyListeners();
    return true;
  }
}
