import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:aws_s3_upload/aws_s3_upload.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen(
    this.channel,
  );

  final Channel channel;

  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  double _progressValue = 0;
  FocusNode _focusNode = new FocusNode();
  bool isFileUploading = false;
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
    String result;

    if (videofile == null) {
      Methods.showToast(message: "No Video Selected");
    } else if (_txtTitle.text == null || _txtTitle.text == "") {
      Methods.showToast(message: "Please enter a title");
    } else if (selectedCategory == null) {
      Methods.showToast(message: "Please select category");
    } else {
      setState(() => isFileUploading = true);

      Channel channel = widget.channel;
      VideoModel video = VideoModel(
        channelID: channel.reference.id,
        channelName: channel.channelName,
        channelImage: channel.profileurl,
        videoTitle: _txtTitle.text.trim(),
        videoURL: null,
        mp4URL: null,
        thumbNail: null,
        isVideoProcessingComplete: false,
        category: selectedCategory,
      );

      final videoservice = Provider.of<VideosService>(context, listen: false);
      await videoservice.uploadVideo(context, video, thumbFile, videofile);
      // setState(() => isFileUploading = false);

      try {
        String result = await AwsS3.uploadFile(
          accessKey: "AKIAWCKQN7QY2ST4V4U3",
          secretKey: "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",
          file: File(videofile.path),
          filename: Path.basename(videofile.path).toString(),
          bucket: "jewtube-source-14c5ef0ws4cpc",
          region: "us-west-2",
          destDir: videofile.path,
        );
        print('result: ' + result);
        print('success');
      } catch (e) {
        print('uploading fialed');
        print(e.toString());
      }
      setState(() => isFileUploading = false);
      Navigator.pop(context);
      // print(Path.basename(videofile.path).toString());
      // AwsS3 awsS3 = AwsS3(
      //   awsFolderPath: "TestingFromFirestore",
      //   file: videofile,
      //   fileNameWithExt: Path.basename(videofile.path),
      //   region: Regions.US_WEST_2,
      //   bucketName: 'jewtube-source-14c5ef0ws4cpc',
      //   poolId: '',
      // );

      // setState(() => isFileUploading = true);

      // try {
      //   try {
      //     result = await awsS3.uploadFile;
      //     debugPrint("Result :'$result'.");
      //   } on PlatformException {
      //     debugPrint("Result :'$result'.");
      //   }
      // } on PlatformException catch (e) {
      //   debugPrint("Failed :'${e.message}'.");
      // }
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
        body: isFileUploading
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      "Uploading...\nPlease wait it can take some time",
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
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
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
                                      onTap: () async {
                                        bool result = await filepickerservice
                                            .pickFile(fileType: FileType.image);
                                        if (result)
                                          thumbFile = filepickerservice
                                              .customthumbnailFile;
                                      },
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
