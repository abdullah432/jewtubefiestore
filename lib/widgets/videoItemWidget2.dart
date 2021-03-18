import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoItemWidget2 extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onPlay;
  // final VoidCallback onSubscribe; //subscribe is managed inside this widget
  final Function(VideoModel) onDeletePressed;
  final bool isSubscriptionBtnVisible;
  const VideoItemWidget2({
    this.video,
    this.onPlay,
    // this.onSubscribe,
    @required this.onDeletePressed,
    this.isSubscriptionBtnVisible: true,
  });

  @override
  _VideoItemWidget2State createState() => _VideoItemWidget2State();
}

class _VideoItemWidget2State extends State<VideoItemWidget2> {
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: <Widget>[
          //thumbnail
          GestureDetector(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: 160,
              height: 90,
              imageUrl: widget.video.thumbNail,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            onTap: widget.onPlay,
          ),
          //video title
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.video.videoTitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.0),
          Constant.isAdmin
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => widget.onDeletePressed(widget.video),
                )
              : Container()
        ],
      ),
    );
  }

  // Widget videoBottomView() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       width: width,
  //       child: Row(
  //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           GestureDetector(
  //             onTap: () => widget.onChannelAvatarClick(widget.video),
  //             child: CircleAvatar(
  //               radius: 27,
  //               backgroundImage: widget.video.channelImage == "" ||
  //                       widget.video.channelImage == null
  //                   ? AssetImage("assets/no_img.png")
  //                   : CachedNetworkImageProvider(widget.video.channelImage),
  //             ),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.only(top: 8.0, left: 14, bottom: 8),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Text(
  //                     widget.video.videoTitle,
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   SizedBox(
  //                     height: 4,
  //                   ),
  //                   Text(widget.video.channelName)
  //                 ],
  //               ),
  //             ),
  //           ),
  //           widget.isSubscriptionBtnVisible
  //               ? Constant.isAdmin
  //                   ? IconButton(
  //                       icon: Icon(
  //                         Icons.delete,
  //                         color: Colors.red,
  //                       ),
  //                       onPressed: () => widget.onDeletePressed(widget.video),
  //                     )
  //                   // : Container()
  //                   : SubscribeWidget(
  //                       channelID: widget.video.channelID,
  //                     )
  //               : Container(width: 0, height: 0)
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
