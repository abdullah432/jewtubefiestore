import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/video.dart';

class DumyData {
  static String exampleProfileUrl =
      "https://miro.medium.com/max/600/1*PiHoomzwh9Plr9_GA26JcA.png";
  static String pewdieurl =
      'https://i.pinimg.com/originals/4f/5a/4b/4f5a4bee6a664f02f19566538e8289fd.png';
  static String videourl =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  static String videoThumbnail =
      'https://upload.wikimedia.org/wikipedia/commons/3/31/Big.Buck.Bunny.-.Frank.Bunny.png';
  static List<Channel> channelList = [
    Channel(channelName: 'channelName', profileurl: pewdieurl),
    Channel(channelName: 'channelName', profileurl: null),
  ];
  static List<VideoModel> videosList = [
    VideoModel(
      channelID: 'channelID',
      channelName: 'channelName',
      channelImage: pewdieurl,
      videoTitle: 'videoTitle',
      videoURL: videourl,
      mp4URL: videourl,
      videoId: 'videoId',
      thumbNail: videoThumbnail,
      sub: false,
      videoUuid: 'videoUuid',
    ),
  ];
}
