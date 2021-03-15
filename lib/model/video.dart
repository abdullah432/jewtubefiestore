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
      'thumbNail': thumbNail,
      'customThumb': customThumb,
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
        thumbNail =
            map['customThumb'] != null ? map['customThumb'] : map['thumbNail'];

  VideoModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // factory VideoModel.fromJson(
  //     {@required Map<String, dynamic> json, @required subArray}) {
  //   return VideoModel(
  //     channelID: json['channelID'],
  //     channelName: json['channelName'],
  //     channelImage: json['channelImage'],
  //     videoTitle: json['videoTitle'],
  //     videoURL: json['videoURL'],
  //     mp4URL: json['mp4URL'],
  //     videoId: json['videoID'],
  //     thumbNail:
  //         json['customThumb'] != null ? json['customThumb'] : json['thumbNail'],
  //     sub: json['channelID'] == "" || subArray == null || subArray.length == 0
  //         ? false
  //         : subArray.contains(json['channelID']),
  //     videoUuid: json['videoUUID'],
  //   );
  // }
}
