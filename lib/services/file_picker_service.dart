import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerService with ChangeNotifier {
  PickedFile _pickedFile =
      PickedFile(file: null, pickedFileStatus: PickedFileStatus.NoStarted);

  //Getter
  PickedFile get pickedFile => _pickedFile;

  //setter
  void clearFilePickItem() {
    _pickedFile =
        PickedFile(file: null, pickedFileStatus: PickedFileStatus.NoStarted);
    notifyListeners();
  }

  void pickFile({@required FileType fileType}) async {
    print('filetype: ' + fileType.toString());
    try {
      _pickedFile =
          PickedFile(file: null, pickedFileStatus: PickedFileStatus.InProgess);
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: fileType);

      if (result != null) {
        print(result.files.toString());
        print(result.count.toString());
        print(result.isSinglePick.toString());
        File file = File(result.files.single.path);
        // String mimeStr = lookupMimeType(file.path);
        // print('mimeStr: ' + mimeStr);
        // var fileType = mimeStr.split('/');
        // print('file type ${fileType[0]}');
        _pickedFile = PickedFile(
            file: file, pickedFileStatus: PickedFileStatus.Completed);
      } else {
        // User canceled the picker
        _pickedFile = PickedFile(
            file: null, pickedFileStatus: PickedFileStatus.NoStarted);
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

enum PickedFileStatus {
  NoStarted,
  InProgess,
  Completed,
}

class PickedFile {
  File file;
  PickedFileStatus pickedFileStatus;

  PickedFile({this.file, this.pickedFileStatus});
}
