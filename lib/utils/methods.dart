import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    scafoldKey.currentState.showSnackBar(SnackBar(content: new Text(message)));
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
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    try {
      print('uploading to: $path');
      final storageReference = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageReference.putFile(
          file, SettableMetadata(contentType: contentType));
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

  static showToast({@required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
}
