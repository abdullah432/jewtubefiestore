import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/services/channelservice.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:provider/provider.dart';
import '../myavatar.dart';

class SelectChannelDialogBox extends StatefulWidget {
  final Function(Channel) onChannelSelection;
  const SelectChannelDialogBox({
    @required this.onChannelSelection,
    Key key,
  }) : super(key: key);

  @override
  _SelectChannelDialogBoxState createState() => _SelectChannelDialogBoxState();
}

class _SelectChannelDialogBoxState extends State<SelectChannelDialogBox> {
  File profileImageFile;
  final channelNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // elevation: 0,
        // backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Text(
            'SELECT CHANNEL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Consumer<ChannelService>(
            builder: (context, channelservice, child) {
              List<Channel> channelsList = channelservice.channelsList;
              if (channelsList == null) {
                channelservice.loadChannelList();
                return Center(child: CircularProgressIndicator());
              }
              if (channelsList.length == 0) {
                return Center(child: Text('No channel added'));
              }
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: channelsList
                      .map((channel) => InkWell(
                            onTap: () => widget.onChannelSelection(channel),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        channel?.profileurl ??
                                            DumyData.exampleProfileUrl),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(channel.channelName),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
