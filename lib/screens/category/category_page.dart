import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/widgets/videoItemWidget.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/dumydata.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  int selectedCategoryIndex = 0;

  //category parameters
  List<String> listOfcategories = [
    'Daily Dose',
    'Torah Classes',
    'Movies',
    'Music',
  ];

  //future list of videos
  Future<List<VideoModel>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<VideoModel>>(
        future: futureVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                // SizedBox(
                //   height: 15.0,
                // ),
                categoryWidget(),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        //I convert Car to Container to remove elevation and match to design
                        child: Container(
                          child: VideoItemWidget(
                            video: snapshot.data[index],
                            onPlay: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (builder) => VideoPlayerScreen(
                              //             videoModel: snapshot.data[index])));
                            },
                            onSubscribe: () {
                              //subscribe
                            },
                            onDeletePressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          // By default, show a loading spinner.
          return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  //category Widget
  categoryWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          //first row
          Row(children: [
            //Daily Dose
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //passing zero index: mean 0 index is clicked
                  changeCategorySelection(0);
                },
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
                            color: selectedCategoryIndex == 0
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
                                color: selectedCategoryIndex == 0
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
                onTap: () {
                  //passing 1 index: mean index 1 is clicked
                  changeCategorySelection(1);
                },
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
                            color: selectedCategoryIndex == 1
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
                                color: selectedCategoryIndex == 1
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
                onTap: () {
                  //passing 2 index: mean 2 index is clicked
                  changeCategorySelection(2);
                },
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
                          color: selectedCategoryIndex == 2
                              ? Constant.selectedColor
                              : Constant.unselectedColor,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Movies",
                            style: TextStyle(
                              color: selectedCategoryIndex == 2
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
                onTap: () {
                  //passing index 3: mean 3rd index is clicked
                  changeCategorySelection(3);
                },
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
                          color: selectedCategoryIndex == 3
                              ? Constant.selectedColor
                              : Constant.unselectedColor,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text("Music",
                            style: TextStyle(
                              color: selectedCategoryIndex == 3
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

  //select category
  changeCategorySelection(index) {
    futureVideos = null;
    setState(() {
      selectedCategoryIndex = index;
      // futureVideos = fetchVideos();
    });
  }

  // Future<void> deleteVideo(String videoId) async {
  //   Response response =
  //       await Dio().get("http://${Resources.BASE_URL}/post/delete/$videoId");
  //   if (response.data != null) {
  //     showToast(message: response.data.toString());
  //   } else {
  //     showToast(message: "Error: video deletion failed.");
  //   }
  // }

  // void onDeleteButtonPressed(String videoId) {
  //   deleteVideo(videoId).whenComplete(() {
  //     setState(() {
  //       futureVideos = fetchVideos();
  //     });
  //   });
  // }

  //fetch videos logic
  Future<List<VideoModel>> fetchVideos() async {
    return DumyData.videosList;
    //   //subarray will be used to determined as the video channel is subscribed or not
    //   var subArray = List();
    //   //retrieve subscribed channel list
    //   if (Resources.userID != "") {
    //     //retrieve all the subscriber
    //     Response responseSubscriber = await Dio()
    //         .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");

    //     if (responseSubscriber.data != null) {
    //       // print("Sub.data: "+sub.data);
    //       subArray = responseSubscriber.data['channel'];
    //     }
    //   }

    //   //After that now retrieve videos
    //   String selectedCategory = listOfcategories[selectedCategoryIndex];
    //   String url =
    //       "http://${Resources.BASE_URL}/video/getvideos/bycategory/${selectedCategory}";
    //   Response response = await Dio().get(url);

    //   if (response.statusCode == 200) {
    //     // If the server did return a 200 OK response,
    //     // then parse the JSON.
    //     // print(response.data);
    //     if (response.statusCode == 200) {
    //       List<VideoModel> list = (response.data as List)
    //           .map((v) => VideoModel.fromJson(json: v, subArray: subArray))
    //           .toList();

    //       final existing = Set<String>();
    //       // List<VideoModel> uniqueCards = list.where((video) => existing.add(video.videoId)).toList();
    //       final unique = list
    //           .where((videoModel) => existing.add(videoModel.videoId))
    //           .toList();
    //       print(unique);
    //       // print(list[0].videoId);
    //       return unique.toList();
    //     } else {
    //       print(response.data["status"]);
    //     }
    //   } else {
    //     // If the server did not return a 200 OK response,
    //     // then throw an exception.
    //     throw Exception('Failed to load album');
    //   }
  }
}
