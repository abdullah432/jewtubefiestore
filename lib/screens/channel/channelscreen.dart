import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';
import 'package:provider/provider.dart';

import 'local_widget/channelimagewidget.dart';

class ChannelPage extends StatefulWidget {
  final String profileUrl;
  final String channelName;
  final String channelId;
  final String thubImg;

  const ChannelPage({
    @required this.channelName,
    @required this.channelId,
    @required this.profileUrl,
    this.thubImg,
    Key key,
  }) : super(key: key);
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<VideosService>(context, listen: false).channelVideoLoading =
        true;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChannelImageWidget(
              channelName: widget.channelName,
              profileUrl: widget.profileUrl,
              channelId: widget.channelId,
              thubImg: widget.thubImg,
            ),
            Consumer<VideosService>(builder: (context, videoservice, child) {
              if (videoservice.channelVideoLoading) {
                videoservice.loadChannelVideosById(context, widget.channelId);
                return Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () async {},
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: videoservice.channelVideoList.length,
                    itemBuilder: (context, index) {
                      if (videoservice.channelVideoList[index].channelName ==
                          widget.channelName)
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          //I convert Car to Container to remove elevation and match to design
                          child: Container(
                            // elevation: 5,
                            padding: EdgeInsets.only(top: 16),
                            child: VideoItemWidget(
                              video: videoservice.channelVideoList[index],
                              onPlay: () {
                                Methods.navigateToPage(
                                  context,
                                  VideoPlayerScreen(
                                      videoModel:
                                          videoservice.channelVideoList[index]),
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
                                // onDeleteButtonPressed(_videoList[index].videoId);
                              },
                            ),
                          ),
                        );
                      else
                        return Container();
                    }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
