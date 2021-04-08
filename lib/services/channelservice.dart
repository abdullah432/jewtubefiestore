import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:provider/provider.dart';

import 'firebasestorageservice.dart';

class ChannelService with ChangeNotifier {
  final database = FirestoreService();

  List<Channel> channelsList;
  List<Channel> subscribedChannelList;
  List<VideoModel> subscribedChannelVideosList = [];

  bool isRefresh = false;

  loadChannelList() async {
    channelsList = await database.loadChannelList();
    notifyListeners();
  }

  loadSubscribedChannelData(context) async {
    print('loading started');
    final currentuser = Provider.of<CurrentUser>(context, listen: false);
    subscribedChannelList = await database.loadSubscribedChannelList(
        subscribedTo: currentuser.subscribedTo);
    print('loading end');

    subscribedChannelVideosList.clear();
    //load each channel video one by one
    for (int i = 0; i < subscribedChannelList.length; i++) {
      List<VideoModel> videos = await database
          .loadVideosByChannelID(subscribedChannelList[i].reference.id);
      subscribedChannelVideosList.addAll(videos);
    }

    notifyListeners();
  }

  Future<void> createChannel(
    context, {
    @required Channel channel,
    File imagefile,
  }) async {
    String downloadUrl;
    if (imagefile != null) {
      //Upload to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      downloadUrl = await storage.uploadAvatar(
        channelname: channel.channelName,
        file: imagefile,
      );
    }

    if (downloadUrl != null) channel.profileurl = downloadUrl;
    final database = Provider.of<FirestoreService>(context, listen: false);
    DocumentReference documentReference =
        await database.createChannel(channel: channel);
    channel.reference = documentReference;
    print('docref: ' + documentReference.id.toString());
    channelsList.add(channel);
    notifyListeners();
    return;
  }

  deleteChannel(Channel channel) async {
    await database.deleteChannel(channel.reference.id);
    channelsList.remove(channel);
    notifyListeners();
  }
}
