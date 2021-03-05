import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import 'package:jewtubefirestore/widgets/loginalertdialog.dart';

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
          : _videoList.length > 0
              ? Container(
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          height: height * 0.1,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _channelList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    // final dio=await Dio().get("http://${Resources.BASE_URL}/video/getvideos/ByChannel/${_channelList[index].channelID}");
                                    // print(dio.data);

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (builder) =>
                                    //             SpcChannelPage(
                                    //               thubImg: _channelList[index]
                                    //                   .imgUrl,
                                    //               channelName:
                                    //                   _channelList[index]
                                    //                       .channelName,
                                    //               channelId: _channelList[index]
                                    //                   .channelID,
                                    //               profileUrl:
                                    //                   _channelList[index]
                                    //                       .imgUrl,
                                    //             )));

                                    // // Resources.navigationKey.currentState
                                    // //     .pushNamed('/channel_page',
                                    // //     arguments:
                                    // //     _channelList[index].channelID);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      radius: height * 0.032,
                                      backgroundImage:
                                          _channelList[index].imgUrl == "" ||
                                                  _channelList[index].imgUrl ==
                                                      null
                                              ? AssetImage("assets/no_img.png")
                                              : CachedNetworkImageProvider(
                                                  _channelList[index].imgUrl),
                                    ),
                                  ),
                                );
                              })),
                      SizedBox(height: height * 0.05),
                      //#TODO:
                      // VideoListViewWidget(
                      //   _videoList,
                      //   getAllVideos,
                      //   () => getAllVideos(),
                      //   height: height * 0.65,
                      // ),
                    ],
                  ),
                )
              : Center(
                  child: Text(text),
                ),
    );
  }
}
