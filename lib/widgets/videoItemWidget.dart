import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/home/local_widgets/subscribewidget.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoItemWidget extends StatefulWidget {
  final VideoModel video;
  final VoidCallback onPlay;
  final VoidCallback onSubscribe;
  final VoidCallback onDeletePressed;
  final bool isSubscriptionBtnVisible;
  const VideoItemWidget({
    this.video,
    this.onPlay,
    this.onSubscribe,
    this.onDeletePressed,
    this.isSubscriptionBtnVisible: true,
  });

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  double width;

  @override
  void initState() {
    super.initState();

    print(widget.video.channelImage);

    print(widget.video.thumbNail);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            //thumbnail
            GestureDetector(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 200,
                width: width,
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
            //Row below thumbnail: include circular icon, videotitle and description
            videoBottomView()
          ],
        ));
  }

  Widget videoBottomView() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (builder) => ChannelPage(
        //               videoModel: widget.videoModel,
        //               channelName: widget.videoModel.channelName,
        //             )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                radius: 27,
                backgroundImage: widget.video.channelImage == "" ||
                        widget.video.channelImage == null
                    ? AssetImage("assets/no_img.png")
                    : CachedNetworkImageProvider(widget.video.channelImage),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.video.videoTitle,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.video.channelName)
                    ],
                  ),
                ),
              ),
              widget.isSubscriptionBtnVisible
                  ? isAdmin
                      ? IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: widget.onDeletePressed)
                      : SubscribeWidget(
                          widget.video.sub,
                          onClick: (status) async {
                            // Response response = await Dio().post(
                            //     "http://${Resources.BASE_URL}/subscribe/add",
                            //     data: {
                            //       "userID": Resources.userID,
                            //       "ChannelID": widget.videoModel.channelID
                            //     });

                            // setState(() {
                            //   widget.videoModel.sub = status;
                            //   widget.onSub();
                            // });
                          },
                        )
                  : Container(width: 0, height: 0)
            ],
          ),
        ),
      ),
    );
  }
}
