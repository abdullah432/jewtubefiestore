import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AddVideoScreen extends StatefulWidget {
  // AddVideoScreen(
  //   this.channelID,
  // );

  // final String channelID;

  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  double _progressValue = 0;
  FocusNode _focusNode = new FocusNode();
  bool _isUploading = false;
  bool _titleEditEnable = true;
  TextEditingController _txtTitle = TextEditingController();
  bool init = false;
  File videofile, thumbFile;

  //category parameters
  List<String> listOfcategories = [
    'Daily Dose',
    'Torah Classes',
    'Music',
    'Movies'
  ];
  String selectedCategory;

  void uploadVideo(BuildContext context) async {
    if (videofile == null) {
      Methods.showToast(message: "No Video Selected");
    } else if (_txtTitle.text == null || _txtTitle.text == "") {
      Methods.showToast(message: "Please enter a title");
    } else if (selectedCategory == null) {
      Methods.showToast(message: "Please select category");
    } else {
//       var uuid = Uuid().v4();
//       if (file != null) {
//         Dio dio = new Dio();
//         var filename = "jewtube-_-_-$uuid-_-_-" +
//             (basename(file.path).replaceAll("trim.", ""));
//         setState(() {
//           _titleEditEnable = false;
//           _isUploading = true;
//         });
//         var response;
//         if (thumbFile != null) {
//           var thumbName = "thumb_image-" + uuid + (basename(thumbFile.path));
//           response =
//               await dio.post("http://${Resources.BASE_URL}/video/addVideo",
//                   data: FormData.fromMap({
//                     "file": MultipartFile.fromFileSync(file.path),
//                     "thumb_image": thumbFile.readAsBytesSync(),
//                     "thumb_name": thumbName,
//                     "name": filename,
//                     "title": _txtTitle.text,
//                     "videoID": uuid,
//                     "category": selectedCategory,
//                     "channel": widget.channelID
//                   }), onSendProgress: (int sent, int total) {
//             setState(() {
//               _progressValue = (sent * 100) / total;
//             });
//           });
//         } else {
//           response =
//               await dio.post("http://${Resources.BASE_URL}/video/addVideo",
//                   data: FormData.fromMap({
//                     "file": MultipartFile.fromFileSync(file.path),
//                     "name": filename,
//                     "title": _txtTitle.text,
//                     "videoID": uuid,
//                     "category": selectedCategory,
//                     "channel": widget.channelID
//                   }), onSendProgress: (int sent, int total) {
//             setState(() {
//               _progressValue = (sent * 100) / total;
//             });
//           });
//         }
//         print(response.data);
//         setState(() {
//           _isUploading = false;
//         });
//         if (response != null &&
//             response.data != null &&
//             response.data['status'] == 200 &&
//             response.data['vid'] != null) {
//           await Dio().post("http://${Resources.BASE_URL}/adminvideo", data: {
//             "title": _txtTitle.text,
//             "videoID": response.data['vid'],
//           });
//           showToast(message: "Upload Completed");
// //           Navigator.of(context).pushReplacementNamed(HOME);
//         } else {
//           showToast(message: "Upload Error");
//         }
//       } else {
//         showToast(message: "No Video Selected");
//       }
    }
  }

  @override
  Widget build(BuildContext context) {
    var sysWidth = MediaQuery.of(context).size.width;
    var sysHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ADD VIDEO"),
          backgroundColor: Colors.red,
        ),
        resizeToAvoidBottomInset: false,
        body: _isUploading
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      "${_progressValue.toStringAsFixed(1)}% Uploading...\nPlease wait it can take some time",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                          focusNode: _focusNode,
                          enabled: _titleEditEnable,
                          controller: _txtTitle,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                              labelText: "TITLE",
                              labelStyle: TextStyle(
                                  color: _focusNode.hasFocus
                                      ? Colors.red
                                      : Colors.black38),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)))),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('Please choose a category'),
                          value: selectedCategory,
                          items: listOfcategories.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Consumer<FilePickerService>(
                        builder: (context, filepickerservice, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  )),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        bool result = await filepickerservice
                                            .pickVideoFileForUpload(
                                                fileType: FileType.video);
                                        if (result) {
                                          videofile =
                                              filepickerservice.videoFile;
                                        }
                                      },
                                      child: filepickerservice
                                                  .videoThumbnailFile ==
                                              null
                                          ? Container(
                                              height: 200,
                                              child: Icon(
                                                FlutterIcons.video_faw5s,
                                                size: 50,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : Image.memory(
                                              filepickerservice
                                                  .videoThumbnailFile,
                                              height: 200,
                                              fit: BoxFit.fitWidth,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  )),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => filepickerservice.pickFile(
                                          fileType: FileType.image),
                                      child: filepickerservice
                                                  .customthumbnailFile ==
                                              null
                                          ? Container(
                                              height: 200,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add_circle,
                                                    color: Colors.red,
                                                    size: 48,
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    "Add Custom\nThumbnail",
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Image.file(
                                              filepickerservice
                                                  .customthumbnailFile,
                                              height: 200,
                                              fit: BoxFit.fitWidth,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            uploadVideo(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
  _AnimatedLiquidLinearProgressIndicator(this.value);

  double value;

  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidLinearProgressIndicatorState();
}

class _AnimatedLiquidLinearProgressIndicatorState
    extends State<_AnimatedLiquidLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: LiquidLinearProgressIndicator(
          value: widget.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 12.0,
          center: Text(
            "${(widget.value * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
