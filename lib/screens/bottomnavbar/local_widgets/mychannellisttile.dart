import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';

class ChannelListView extends StatelessWidget {
  final List<Channel> channellist;
  final Function(Channel) onDelete;
  const ChannelListView({
    @required this.channellist,
    @required this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: channellist.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Channel channel = channellist[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                channel?.profileurl ?? DumyData.exampleProfileUrl,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => onDelete(channel),
            ),
            title: Text(channel.channelName),
            onTap: () {
              // print(channel.channelName);
              // scaffoldKey.currentState.openEndDrawer();
              // Resources.navigationKey.currentState.pushNamed(
              //     '/channel_page',
              //     arguments: channel.channelID);
            },
          );
        });
  }
}
