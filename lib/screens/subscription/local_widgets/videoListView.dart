import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget2.dart';
import 'package:provider/provider.dart';

// class VideoListViewWidget extends StatefulWidget {
//   final VoidCallback onSubscription;
//   final List<VideoModel> videos;

//   VideoListViewWidget(this.videos, this.onSubscription,
//       {this.onRefresh, this.width = 0, this.height = 0});

//   RefreshCallback onRefresh;
//   Function onSub;
//   double width;
//   double height;

//   @override
//   _VideoListViewWidgetState createState() => _VideoListViewWidgetState();
// }

// class _VideoListViewWidgetState extends State<VideoListViewWidget> {
//   @override
//   Widget build(BuildContext context) {
//     double width =
//         widget.width == 0 ? MediaQuery.of(context).size.width : widget.width;
//     double height =
//         widget.height == 0 ? MediaQuery.of(context).size.height : widget.height;
//     return widget.videos.length > 0
//         ? Container(
//             height: height * 0.9,
//             width: width,
//             child: RefreshIndicator(
//               onRefresh: widget.onRefresh,
//               child: ListView.builder(
//                   itemCount: widget.videos.length,
//                   itemBuilder: (context, index) {
//                     return VideoItemWidget(video: ,)
//                   }),
//             ),
//           )
//         : Container(
//             child: Center(child: Text("No Video Found")),
//             height: height,
//             width: width,
//           );
//   }
// }

class VideoList extends StatelessWidget {
  // final VoidCallback onSubscription;
  final List<VideoModel> videos;
  final bool isSubscriptionBtnVisible;
  final int videoStyleIndex;
  const VideoList({
    @required this.videos,
    // @required this.onSubscription,
    this.isSubscriptionBtnVisible: true,
    this.videoStyleIndex: 1,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return videos.length > 0
            ? videoStyleIndex == 1
                ? VideoItemWidget(
                    video: videos[index],
                    isSubscriptionBtnVisible: isSubscriptionBtnVisible,
                    onPlay: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => VideoPlayerScreen(
                                  videoModel: videos[index])));
                    },
                    onChannelAvatarClick: (video) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChannelPage(
                            channelId: video.channelID,
                            channelName: video.channelName,
                            profileUrl: video.channelImage,
                          ),
                        ),
                      );
                    },
                    onDeletePressed: (video) {
                      deleteVideo(context, video);
                    },
                  )
                : VideoItemWidget2(
                    video: videos[index],
                    onPlay: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => VideoPlayerScreen(
                                  videoModel: videos[index])));
                    },
                    onDeletePressed: (video) {
                      deleteVideo(context, video);
                    },
                  )
            : Text('No video found');
      },
    );
  }

  deleteVideo(context, video) {
    Methods.showAlertDialog(
      context: context,
      dialog: CustomAlertDialog(
        content: 'Are you sure you want to delete this video',
        onConfirmClick: () {
          Navigator.pop(context);
          //delete
          final videoservice =
              Provider.of<VideosService>(context, listen: false);
          videoservice.deleteVideo(context, video: video);
        },
      ),
    );
  }
}
