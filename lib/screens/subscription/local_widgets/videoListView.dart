import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';

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
  final VoidCallback onSubscription;
  final List<VideoModel> videos;
  final bool isSubscriptionBtnVisible;
  const VideoList({
    @required this.videos,
    @required this.onSubscription,
    this.isSubscriptionBtnVisible: true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return videos.length > 0
            ? VideoItemWidget(
                video: videos[index],
                isSubscriptionBtnVisible: isSubscriptionBtnVisible,
                onPlay: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (builder) => VideoPlayerScreen(
                  //             videoModel: _videoList[index])));
                },
                onSubscribe: () {
                  //add subscription to channel
                },
                onDeletePressed: () {
                  // onDeleteButtonPressed(_videoList[index].videoId);
                },
              )
            : Text('No video found');
      },
    );
  }
}
