import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/screens/subscription/local_widgets/videoItemWidgetHorizontal.dart';

class VideoListViewWidget extends StatefulWidget {
  final VoidCallback onSubscription;
  final List<VideoModel> videos;

  VideoListViewWidget(this.videos, this.onRefresh, this.onSubscription,
      {this.width = 0, this.height = 0});

  RefreshCallback onRefresh;
  Function onSub;
  double width;
  double height;

  @override
  _VideoListViewWidgetState createState() => _VideoListViewWidgetState();
}

class _VideoListViewWidgetState extends State<VideoListViewWidget> {
  @override
  Widget build(BuildContext context) {
    double width =
        widget.width == 0 ? MediaQuery.of(context).size.width : widget.width;
    double height =
        widget.height == 0 ? MediaQuery.of(context).size.height : widget.height;
    return SingleChildScrollView(
      child: widget.videos.length > 0
          ? Container(
              height: height * 0.9,
              width: width,
              child: RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: ListView.builder(
                    itemCount: widget.videos.length,
                    itemBuilder: (context, index) {
                      //default Card = AnimatedCard
                      return Card(
                          // direction: AnimatedCardDirection.left,
                          // initDelay: Duration(milliseconds: 0),
                          // duration: Duration(seconds: 1),
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => VideoPlayerScreen(
                            //             videoModel: widget.videos[index])));

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => VideoPlayerScreen(
                            //             videoModel: widget.videos[index])));
                          },
                          child: Card(
                            elevation: 5,
                            child: VideoItemWidgetHorizontal(
                                widget.videos[index], () {
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (builder) =>
//                                              VideoPlayerScreen(
//                                                  videoModel:
//                                                      widget.videos[index])));
//                                  Resources.navigationKey.currentState.pushNamed(
//                                      '/player',
//                                      arguments: widget.videos[index]);
                            }, widget.onSub),
                          ),
                        ),
                      ));
                    }),
              ),
            )
          : Container(
              child: Center(child: Text("No Video Found")),
              height: height,
              width: width,
            ),
    );
  }
}
