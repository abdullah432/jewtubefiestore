import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class VideoModel {
  String channelID;
  String channelName;
  String channelImage;
  String videoTitle;
  String videoURL;
  String mp4URL;
  String thumbNail;
  String customThumb;
  String category;
  String language;
  double videoduration;
  DateTime uploadTime;
  bool isVideoProcessingComplete;
  DocumentReference reference;

  VideoModel({
    @required this.channelID,
    @required this.channelName,
    @required this.channelImage,
    @required this.videoTitle,
    @required this.videoURL,
    @required this.mp4URL,
    @required this.category,
    @required this.language,
    @required this.videoduration,
    this.uploadTime,
    this.thumbNail,
    this.isVideoProcessingComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'channelID': channelID,
      'channelName': channelName,
      'channelImage': channelImage,
      'videoTitle': videoTitle,
      'videoURL': videoURL,
      'mp4URL': mp4URL,
      'category': category,
      'language': language,
      'videoduration': videoduration,
      'thumbNail': thumbNail,
      'customThumb': customThumb,
      'uploadTime': DateTime.now(),
      'isVideoProcessingComplete': isVideoProcessingComplete,
    };
  }

  VideoModel.fromMap(Map<String, dynamic> map, {this.reference})
      : channelID = map['channelID'],
        channelName = map['channelName'],
        channelImage = map['channelImage'],
        videoTitle = map['videoTitle'],
        videoURL = map['videoURL'],
        mp4URL = map['mp4URL'],
        category = map['category'],
        isVideoProcessingComplete = map['isVideoProcessingComplete'],
        language = map['language'] != null ? map['language'] : 'English',
        videoduration =
            map['videoduration'] != null ? map['videoduration'] : null,
        thumbNail =
            map['customThumb'] != null ? map['customThumb'] : map['thumbNail'];

  VideoModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
