import 'package:jewtubefirestore/model/downloaded_files.dart';
import 'package:jewtubefirestore/model/sqflite_helper.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class Methods {
  static Future<void> loadDownloadedFilesList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<DownloadedFile>> filesListFuture =
          databaseHelper.getDownloadedFilesList();
      filesListFuture.then((downloadedFileList) {
        listOfDownloadedFiles = downloadedFileList;
        //debug
        print('ListOfDownloadFile: ' + listOfDownloadedFiles.toString());
      });
      return;
    });
  }
}
