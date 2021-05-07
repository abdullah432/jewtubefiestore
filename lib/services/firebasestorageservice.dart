import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/enum/content_type.dart';
import 'package:jewtubefirestore/enum/upload_status.dart';
import 'package:jewtubefirestore/utils/firebasepath.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FirebaseStorageService with ChangeNotifier {
  UPLOADSTATUS uploadstatus = UPLOADSTATUS.INITIAL;
  double progress = 0.0;
  //upload avatar from file
  Future<String> uploadAvatar({
    @required String channelname,
    @required PlatformFile file,
  }) async =>
      await Methods.uploadAvatarToStorage(
        platformfile: file,
        path: FirestorePath.channelavatar(channelname),
        contentType: 'image/png',
      );

  //upload file (either image or video to firestore)
  Future<List<String>> uploadFileToStorage({
    @required String channeluid,
    String contentType: 'image/png',
    @required PlatformFile file,
  }) async {
    uploadstatus = UPLOADSTATUS.INPROGRESS;
    notifyListeners();
    String path =
        FirestorePath.filePath(channeluid, contentType, basename(file.path));
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask;
    if (kIsWeb)
      uploadTask = storageReference.putData(
          file.bytes, SettableMetadata(contentType: contentType));
    else
      uploadTask = storageReference.putFile(
          File(file.path), SettableMetadata(contentType: contentType));

    // await uploadTask.whenComplete(() => null);
    double bytetransfer;
    uploadTask.snapshotEvents.listen((event) {
      bytetransfer =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      progress = bytetransfer * 100;
      notifyListeners();
    });

    // Url used to download file/image
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    String thumbnailDownloadUrl;
    if (!kIsWeb) {
      if (Methods.getContentType(contentType) == ContentType.VIDEO) {
        final uint8list = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.PNG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 40,
        );
        // File thumbnailFile = File.fromRawPath(uint8list);
        //upload thumbnail
        path = FirestorePath.fileThumbnailPath(channeluid, basename(file.path));
        storageReference = FirebaseStorage.instance.ref().child(path);
        uploadTask = storageReference.putData(
            uint8list, SettableMetadata(contentType: 'image/png'));
        await uploadTask.whenComplete(() => null);
        thumbnailDownloadUrl = await (await uploadTask).ref.getDownloadURL();
      }
    }

    //complete (clear cache data)
    uploadstatus = UPLOADSTATUS.COMPLETE;
    progress = 0.0;
    // notifyListeners(); //because clearFilePickItem is calling notifyListner
    return [downloadUrl, thumbnailDownloadUrl];
  }
}
