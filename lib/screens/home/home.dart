import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
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
      body: Consumer<VideosService>(
        builder: (context, videoservice, child) {
          if (videoservice.videosList == null) {
            videoservice.loadAllVideos(context);
            return Center(child: CircularProgressIndicator());
          } else if (videoservice.videosList.length == 0) {
            return RefreshIndicator(
              onRefresh: () async => videoservice.loadAllVideos(context),
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                width: double.infinity,
              ),
            );
          }
          _videoList = videoservice.videosList;
          return RefreshIndicator(
            onRefresh: () async => videoservice.loadAllVideos(context),
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
                          Methods.navigateToPage(
                            context,
                            VideoPlayerScreen(videoModel: _videoList[index]),
                          );
                        },
                        onChannelAvatarClick: (video) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChannelPage(
                                channelId: video.channelID,
                                channelName: video.channelName,
                                profileUrl: video.channelImage,
                              ),
                            ),
                          );
                        },
                        onDeletePressed: (video) {
                          Methods.showAlertDialog(
                            context: context,
                            dialog: CustomAlertDialog(
                              content:
                                  'Are you sure you want to delete this video',
                              onConfirmClick: () {
                                Navigator.pop(context);
                                //delete
                                videoservice.deleteVideo(context, video: video);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
