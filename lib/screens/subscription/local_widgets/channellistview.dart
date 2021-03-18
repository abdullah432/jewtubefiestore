import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';

class ChannelListView extends StatelessWidget {
  final List<Channel> channelList;
  final Function(Channel) onChannelClick;
  const ChannelListView({
    @required this.channelList,
    @required this.onChannelClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: channelList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onChannelClick(channelList[index]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: channelList[index].profileurl == "" ||
                            channelList[index].profileurl == null
                        ? AssetImage("assets/no_img.png")
                        : CachedNetworkImageProvider(
                            channelList[index].profileurl,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
