import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FilePickerService with ChangeNotifier {
  PickedFile _pickedFile = PickedFile(
      platformFile: null, pickedFileStatus: PickedFileStatus.NoStarted);
  PlatformFile videoFile;
  Uint8List videoThumbnailFile;
  PlatformFile customthumbnailFile;

  //Getter
  PickedFile get pickedFile => _pickedFile;

  //setter
  void clearFilePickItem() {
    _pickedFile = PickedFile(
        platformFile: null, pickedFileStatus: PickedFileStatus.NoStarted);
    videoFile = null;
    videoThumbnailFile = null;
    customthumbnailFile = null;
    notifyListeners();
  }

  Future<bool> pickVideoFileForUpload({@required FileType fileType}) async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: fileType);

      if (result != null) {
        PlatformFile platformfile = result.files.first;
        print(platformfile.extension);
        if (platformfile.extension == 'mp4') {
          videoFile = result.files.single;
          if (!kIsWeb) {
            videoThumbnailFile = await VideoThumbnail.thumbnailData(
              video: videoFile.path,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 250,
              maxHeight: 250,
              quality: 50,
            );
          } else {
            videoThumbnailFile = Uint8List(1);
          }
          notifyListeners();
          return true;
        } else {
          Methods.showToast(
            toastLenght: Toast.LENGTH_LONG,
            message:
                "Please select mp4 file or convert your file to mp4 formate",
          );
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> pickFile({@required FileType fileType}) async {
    // print('filetype: ' + fileType.toString());
    try {
      _pickedFile = PickedFile(
          platformFile: null, pickedFileStatus: PickedFileStatus.InProgess);
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: fileType);

      if (result != null) {
        PlatformFile file = result.files.single;

        customthumbnailFile = file;
        _pickedFile = PickedFile(
            platformFile: file, pickedFileStatus: PickedFileStatus.Completed);
        notifyListeners();

        return true;
      } else {
        // User canceled the picker
        _pickedFile = PickedFile(
            platformFile: null, pickedFileStatus: PickedFileStatus.NoStarted);
        notifyListeners();

        return false;
      }
    } catch (e) {
      print(e.toString());
      notifyListeners();

      return false;
    }
  }
}

enum PickedFileStatus {
  NoStarted,
  InProgess,
  Completed,
}

class PickedFile {
  PlatformFile platformFile;
  PickedFileStatus pickedFileStatus;

  PickedFile({this.platformFile, this.pickedFileStatus});
}
