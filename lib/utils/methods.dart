import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/enum/content_type.dart';
import 'package:jewtubefirestore/model/downloaded_files.dart';
import 'package:jewtubefirestore/model/sqflite_helper.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Methods {
  static showSnackbar({@required scafoldKey, @required message}) {
    scafoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> chooseFileFromGallery(BuildContext context,
      {FileType fileType: FileType.image}) async {
    try {
      final imagePicker =
          Provider.of<FilePickerService>(context, listen: false);
      imagePicker.pickFile(fileType: fileType);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> uploadAvatarToStorage({
    @required PlatformFile platformfile,
    @required String path,
    @required String contentType,
  }) async {
    try {
      print('uploading to: $path');
      final storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask;
      if (kIsWeb)
        uploadTask = storageReference.putData(
            platformfile.bytes, SettableMetadata(contentType: contentType));
      else
        uploadTask = storageReference.putFile(File(platformfile.path),
            SettableMetadata(contentType: contentType));
      await uploadTask.whenComplete(() => null);

      // Url used to download file/image
      final downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print('downloadUrl: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('error uploading avatar to storage: ' + e.toString());
      return null;
    }
  }

  static Future<void> loadDownloadedFilesList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<DownloadedFile>> filesListFuture =
          databaseHelper.getDownloadedFilesList();
      filesListFuture.then((downloadedFileList) {
        Constant.listOfDownloadedFiles = downloadedFileList;
        //debug
        print(
            'ListOfDownloadFile: ' + Constant.listOfDownloadedFiles.toString());
      });
      return;
    });
  }

  static showAlertDialog({@required context, @required dialog}) {
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static showToast(
      {@required String message, toastLenght: Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
      msg: message != null ? message : 'Unexpected error',
      toastLength: toastLenght,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static shareLink({@required VideoModel video}) {
    Share.share(video.videoTitle);
  }

  static navigateToPage(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (builder) => page));
  }

  static ContentType getContentType(String contenttype) {
    if (contenttype.split("/")[0] == 'video') return ContentType.VIDEO;
    // if (contenttype.split("/")[0] == 'image/png' ||
    //     contenttype.split("/")[0] == 'image/jpeg') return ContentType.IMAGE;
    return ContentType.IMAGE;
  }

  int parseTimeString(String string, {int currentLayer = 0}) {
    if ((string?.length ?? 0) == 0) return 0;
    String splitString = currentLayer == 0 ? "." : ":";
    String substring = string.substring(string.lastIndexOf(splitString) + 1);
    if (currentLayer == 0) {
      while (substring.length < 3) {
        substring += "0";
      }
    }
    int parsed = int.tryParse(substring) ?? 0;
    Duration duration;
    switch (currentLayer) {
      case 0:
        duration = Duration(milliseconds: parsed);
        break;
      case 1:
        duration = Duration(seconds: parsed);
        break;
      case 2:
        duration = Duration(minutes: parsed);
        break;
      case 3:
        duration = Duration(hours: parsed);
        break;
    }
    return duration.inMilliseconds +
        parseTimeString(
            string.substring(
                0,
                string.lastIndexOf(splitString) == -1
                    ? 0
                    : string.lastIndexOf(splitString)),
            currentLayer: currentLayer + 1);
  }

  static String timeToString(int millis) {
    print('miliseconds: ' + millis.toString());
    Duration duration = Duration(milliseconds: millis);
    String result = duration.toString();
    while (result.substring(result.length - 1) == "0") {
      result = result.substring(0, result.length - 1);
    }
    if (result.substring(result.length - 1) == ".") result += "0";
    return result;
  }

  static String millisecondsToHMS(double milliseconds) {
    print(milliseconds.toString());

    // milliseconds = 364192.0;
    Duration duration = Duration(milliseconds: milliseconds.toInt());

    var seconds = duration.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days == 0 && hours == 0 && minutes == 0) {
      if (seconds < 10) {
        tokens.add('0:0$seconds');
      } else {
        tokens.add('0:$seconds');
      }
      return tokens.join(':');
    } else {
      if (days != 0) {
        tokens.add('$days');
      }
      if (tokens.isNotEmpty || hours != 0) {
        tokens.add('$hours');
      }
      if (tokens.isNotEmpty || minutes != 0) {
        tokens.add('$minutes');
      }
      if (seconds < 10) {
        tokens.add('0$seconds');
      } else {
        tokens.add('$seconds');
      }

      // tokens.add('$seconds');

      return tokens.join(':');
    }
  }
}
