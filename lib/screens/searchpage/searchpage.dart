import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final String queryText;
  SearchPage({
    @required this.queryText,
    Key key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState(queryText);
}

class _SearchPageState extends State<SearchPage> {
  String queryText;
  _SearchPageState(this.queryText);
  List<VideoModel> _videoList;
  @override
  Widget build(BuildContext context) {
    Provider.of<VideosService>(context, listen: false).searchResultVideoList =
        null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search result'),
      ),
      body: Consumer<VideosService>(
        builder: (context, videoservice, child) {
          if (videoservice.searchResultVideoList == null) {
            videoservice.searchVideos(context, queryText);
            return Center(child: CircularProgressIndicator());
          } else if (videoservice.searchResultVideoList.length == 0) {
            return Text('No video found');
          }
          _videoList = videoservice.searchResultVideoList;
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
              });
        },
      ),
    );
  }
}
