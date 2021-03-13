import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/video.dart';

class DumyData {
  static String exampleProfileUrl =
      "https://miro.medium.com/max/600/1*PiHoomzwh9Plr9_GA26JcA.png";
  static String pewdieurl =
      'https://i.pinimg.com/originals/4f/5a/4b/4f5a4bee6a664f02f19566538e8289fd.png';
  static String videourl =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  static String videourl2 =
      'https://jewtube-source-14c5ef0ws4cpc.s3-us-west-2.amazonaws.com/jewtube-_-_-1601921469467-_-_-7502fd86663c4249a6b22130aef702d9.mp4';
  static String videoThumbnail =
      'https://upload.wikimedia.org/wikipedia/commons/3/31/Big.Buck.Bunny.-.Frank.Bunny.png';
  static List<Channel> channelList = [
    Channel(channelName: 'channelName', profileurl: pewdieurl),
    Channel(channelName: 'channelName', profileurl: null),
  ];
  static List<VideoModel> videosList = [
    VideoModel(
      channelID: 'r19wNt07INpHDEfY6vQA',
      channelName: 'Game',
      channelImage:
          'https://firebasestorage.googleapis.com/v0/b/jewtube-77fb7.appspot.com/o/channel%2FGame%2Favatar.png?alt=media&token=d6957f2b-7a9a-4b74-85c3-400e556a83f6',
      videoTitle: 'videoTitle',
      videoURL: videourl,
      mp4URL: videourl,
      videoId: 'videoId',
      thumbNail: videoThumbnail,
      sub: false,
      videoUuid: 'videoUuid',
    ),
    VideoModel(
      channelID: 'mAFpBAww1XeP9gnjK3pA',
      channelName: 'Logan',
      channelImage:
          'https://firebasestorage.googleapis.com/v0/b/jewtube-77fb7.appspot.com/o/channel%2FLoganavatar.png?alt=media&token=f2d34a2e-127c-40dd-9815-dae2b8ba6336',
      videoTitle: 'videoTitle',
      videoURL: videourl2,
      mp4URL: videourl2,
      videoId: 'videoId',
      thumbNail: videoThumbnail,
      sub: false,
      videoUuid: 'videoUuid',
    ),
  ];
}
