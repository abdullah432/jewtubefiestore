import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/custom_colors.dart';
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
    final videoService = Provider.of<VideosService>(context, listen: false);
    return Scaffold(
        key: scaffoldKey,
        body: RefreshIndicator(
          onRefresh: () async => videoService.loadAllVideos(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //language filter

                SizedBox(height: 20.0),
                Consumer<VideosService>(
                    builder: (context, videoservice, child) {
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: Constant.listOfLanguages.length + 1,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () => videoservice.filterVideosByLanugage(
                                context,
                                languageIndex: index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    index == videoservice.selectedLanguageIndex
                                        ? Colors.black.withOpacity(0.6)
                                        : CustomColor.lightGrayColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Text(
                                    index == 0
                                        ? 'All'
                                        : Constant.listOfLanguages[index - 1],
                                    style: TextStyle(
                                      color: index ==
                                              videoservice.selectedLanguageIndex
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                //videos list
                Consumer<VideosService>(
                  builder: (context, videoservice, child) {
                    if (videoservice.videosList == null) {
                      videoservice.loadAllVideos(context);
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (videoservice.videosList.length == 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 100,
                        width: double.infinity,
                      );
                    }
                    _videoList = videoservice.videosList;
                    return ListView.builder(
                      itemCount: _videoList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          //I convert Car to Container to remove elevation and match to design
                          child: Container(
                            padding: EdgeInsets.only(top: 16),
                            child: VideoItemWidget(
                              video: _videoList[index],
                              onPlay: () {
                                print('videouid: ' +
                                    _videoList[index].reference.id);
                                Methods.navigateToPage(
                                  context,
                                  VideoPlayerScreen(
                                      videoModel: _videoList[index]),
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
                                      videoservice.deleteVideo(context,
                                          video: video);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
