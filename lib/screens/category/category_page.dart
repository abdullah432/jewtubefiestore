import 'package:flutter/material.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/videoplayer/videoPlay.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VideosService>(
        builder: (context, videoservice, child) {
          // By default, show a loading spinner.
          return Column(
            children: [
              categoryWidget(videoservice),
              SizedBox(
                height: 15.0,
              ),
              categorPageContentScreen(videoservice),
            ],
          );
        },
      ),
    );
  }

  categorPageContentScreen(VideosService videoservice) {
    if (videoservice.categoryVideosList == null) {
      videoservice.filterVideoByCategory();
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (videoservice.categoryVideosList.length == 0) {
      return Center(child: Text("No video found"));
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: videoservice.categoryVideosList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            //I convert Car to Container to remove elevation and match to design
            child: Container(
              child: VideoItemWidget(
                video: videoservice.categoryVideosList[index],
                onPlay: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => VideoPlayerScreen(
                          videoModel: videoservice.categoryVideosList[index]),
                    ),
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
                      content: 'Are you sure you want to delete this video',
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
        },
      ),
    );
  }

  //category Widget
  categoryWidget(VideosService videosService) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          //first row
          Row(children: [
            //Daily Dose
            Expanded(
              child: GestureDetector(
                onTap: () => videosService.updateCategorySelection(0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(blurRadius: 0.1, color: Colors.black26)
                      ]),
                  constraints: BoxConstraints(minHeight: 60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.assignment,
                            color: videosService.selectedCategoryIndex == 0
                                ? Constant.selectedColor
                                : Constant.unselectedColor,
                          ),
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Flexible(
                          child: Text("Daily Dose",
                              style: TextStyle(
                                color: videosService.selectedCategoryIndex == 0
                                    ? Constant.selectedColor
                                    : Constant.unselectedColor,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            //Torah Classes
            Expanded(
              child: GestureDetector(
                onTap: () => videosService.updateCategorySelection(1),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(blurRadius: 0.1, color: Colors.black26)
                      ]),
                  constraints: BoxConstraints(minHeight: 60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Icon(
                            Icons.local_florist,
                            color: videosService.selectedCategoryIndex == 1
                                ? Constant.selectedColor
                                : Constant.unselectedColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                          child: Text("Torah Classes",
                              style: TextStyle(
                                color: videosService.selectedCategoryIndex == 1
                                    ? Constant.selectedColor
                                    : Constant.unselectedColor,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 12,
          ),
          //second row
          Row(children: [
            //Movies
            Expanded(
              child: GestureDetector(
                onTap: () => videosService.updateCategorySelection(2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(blurRadius: 0.1, color: Colors.black26)
                      ]),
                  constraints: BoxConstraints(minHeight: 60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter,
                          color: videosService.selectedCategoryIndex == 2
                              ? Constant.selectedColor
                              : Constant.unselectedColor,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Movies",
                            style: TextStyle(
                              color: videosService.selectedCategoryIndex == 2
                                  ? Constant.selectedColor
                                  : Constant.unselectedColor,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            //Music
            Expanded(
              child: GestureDetector(
                onTap: () => videosService.updateCategorySelection(3),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(blurRadius: 0.1, color: Colors.black26)
                      ]),
                  constraints: BoxConstraints(minHeight: 60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          color: videosService.selectedCategoryIndex == 3
                              ? Constant.selectedColor
                              : Constant.unselectedColor,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Music",
                            style: TextStyle(
                              color: videosService.selectedCategoryIndex == 3
                                  ? Constant.selectedColor
                                  : Constant.unselectedColor,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
