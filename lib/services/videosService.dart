import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/firebasestorageservice.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:provider/provider.dart';

class VideosService with ChangeNotifier {
  List<VideoModel> recommendedVideosList;
  List<VideoModel> categoryVideosList;
  List<VideoModel> videosList;
  List<VideoModel> channelVideoList = [];
  List<VideoModel> searchResultVideoList;
  bool channelVideoLoading = true;
  bool isUploading = false;
  int selectedCategoryIndex = 0;

  loadAllVideos(context) async {
    final database = Provider.of<FirestoreService>(context, listen: false);
    videosList = await database.loadAllVideos();
    notifyListeners();
  }

  loadChannelVideosById(context, String channelID) async {
    final database = Provider.of<FirestoreService>(context, listen: false);
    channelVideoList = await database.loadVideosByChannelID(channelID);
    print('channelVideoList: ' + channelVideoList.toString());
    channelVideoLoading = false;
    notifyListeners();
  }

  searchVideos(context, String queryText) async {
    final database = Provider.of<FirestoreService>(context, listen: false);
    searchResultVideoList = await database.searchVideos(queryText);
    notifyListeners();
  }

  filterVideoByCategory() async {
    Future.delayed(Duration.zero, () async {
      categoryVideosList = videosList.where((video) {
        print('category: ' + video.category.toString());
        return video.category ==
            Constant.listOfcategories[selectedCategoryIndex];
      }).toList();
      notifyListeners();
    });
  }

  updateCategorySelection(index) {
    selectedCategoryIndex = index;
    filterVideoByCategory();
  }

  List<VideoModel> loadRecommendedVideosList(VideoModel currentlyplaying) {
    videosList.remove(currentlyplaying);
    recommendedVideosList = videosList;
    return recommendedVideosList;
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

      video.customThumb = thumbnailurl;
    }

    //now upload data to database
    final database = Provider.of<FirestoreService>(context, listen: false);
    bool result = await database.uploadVideo(video);
    // isUploading = false;
    // notifyListeners();
    return true;
  }

  deleteVideo(context, {@required VideoModel video}) {
    final storage = Provider.of<FirestoreService>(context, listen: false);
    storage.deleteVideo(video);
    videosList.remove(video);
    notifyListeners();
  }
}
