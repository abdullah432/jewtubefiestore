import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/screens/home/local_widgets/subscribewidget.dart';
import 'package:jewtubefirestore/utils/constants.dart';

class ChannelImageWidget extends StatefulWidget {
  final String profileUrl;
  final String channelName;
  final String channelId;
  final String thubImg;

  ChannelImageWidget(
      {this.channelName, this.profileUrl, this.channelId, this.thubImg});

  @override
  _ChannelImageWidgetState createState() => _ChannelImageWidgetState();
}

class _ChannelImageWidgetState extends State<ChannelImageWidget> {
  bool _progress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return _progress
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Container(
              width: width,
              child: Column(
                children: [
                  //Channel banner image
                  Container(
                    height: 190,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image:
                          widget.profileUrl == "" || widget.profileUrl == null
                              ? AssetImage("assets/no_img.png")
                              : CachedNetworkImageProvider(widget.profileUrl),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //channel profile image
                        Container(
                          height: 70,
                          width: 70,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundImage: widget.profileUrl == "" ||
                                    widget.profileUrl == null
                                ? AssetImage("assets/no_img.png")
                                : CachedNetworkImageProvider(widget.profileUrl),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget.channelName,
                                  style: TextStyle(fontSize: 20),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            SubscribeWidget(channelID: widget.channelId),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
