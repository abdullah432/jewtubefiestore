import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import '../../widgets/videoItemWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<VideoModel> _videoList = DumyData.videosList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
              itemCount: _videoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  //I convert Car to Container to remove elevation and match to design
                  child: Container(
                    padding: EdgeInsets.only(top: 16),
                    child: VideoItemWidget(
                        video: _videoList[index],
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
                        }),
                  ),
                );
              }),
        ));
  }
}
