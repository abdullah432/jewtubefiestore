import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:provider/provider.dart';
import '../../widgets/videoItemWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<VideoModel> _videoList = [];
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
          child: Consumer<VideosService>(
            builder: (context, videoservice, child) {
              if (videoservice.videosList == null) {
                videoservice.loadAllVideos(context);
                return Center(child: CircularProgressIndicator());
              } else if (videoservice.videosList.length == 0) {
                return Container();
              }
              _videoList = videoservice.videosList;
              return ListView.builder(
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
                            Methods.navigateToPage(
                              context,
                              VideoPlayerScreen(videoModel: _videoList[index]),
                            );
                          },
                          onSubscribe: () {
                            //add subscription to channel
                          },
                          onDeletePressed: () {
                            // onDeleteButtonPressed(_videoList[index].videoId);
                          },
                        ),
                      ),
                    );
                  });
            },
          ),
        ));
  }
}
