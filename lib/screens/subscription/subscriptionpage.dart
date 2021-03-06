import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/subscription/local_widgets/channellistview.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import 'package:jewtubefirestore/widgets/loginalertdialog.dart';

import 'local_widgets/videoListView.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<VideoModel> _videoList = [];
  List<Channel> _channelList = [];
  bool _progress = true;
  bool init = false;
  String text = "No Subscriptions";

  // Future<Null> getAllVideos() async {
  //   await getVideos(
  //           "http://${Resources.BASE_URL}/video/getvideos/ByChannelArray",
  //           needSubsInQuery: true)
  //       .then((value) => {
  //             setState(() {
  //               _videoList.clear();
  //               _videoList = value['videos'];
  //               _channelList = value['channels'];
  //               // print(jsonEncode(_videoList));
  //               _progress = false;
  //             })
  //           });
  // }

  fetchVideos() async {
    _videoList = DumyData.videosList;
    _channelList = DumyData.channelList;
    _progress = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        (MediaQuery.of(context).size.height) - AppBar().preferredSize.height;
    // double width = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!init) {
        init = true;
        if (isSignedIn) {
          fetchVideos();
          setState(() {
            init = true;
            // _progress = false;
          });
        } else {
          setState(() {
            init = true;
            _progress = false;
          });
          text = "Please sign in...!";

          showDialog(
            context: context,
            builder: (context) {
              return EnableSubscriptionDialogBox();
            },
          );
        }
      }
    });

    return Scaffold(
      body: _progress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //channels list
                  ChannelListView(
                    channelList: _channelList,
                    onChannelClick: (channelid) {
                      print('Open channel: ' + channelid);
                    },
                  ),
                  //videos list
                  VideoList(
                    videos: _videoList,
                    isSubscriptionBtnVisible: false,
                    onSubscription: () {},
                  ),
                ],
              ),
            ),
    );
  }
}
