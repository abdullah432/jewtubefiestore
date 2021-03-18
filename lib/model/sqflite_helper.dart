import 'dart:io';

import 'package:jewtubefirestore/utils/methods.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'downloaded_files.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper;
  Database _database;

  DatabaseHelper.createInstance();

  String downloadTable = 'download_table';
  String colId = 'id';
  String colTime = 'time';
  String colLocation = 'location';
  String colUrl = 'url';

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.createInstance();
    }
    return databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    //get directory path to both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();

    //below line produce error in iOS
    // String path = directory.path + 'notes.db';
    String path = join(directory.path, 'download.db');

    //open/create db at give path
    var noteDatabase = await openDatabase(path, version: 1, onCreate: createDb);
    return noteDatabase;
  }

  void createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $downloadTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colLocation Text, $colTime Text, $colUrl Text)');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  //Fetch operation. Get all note object from database
  Future<List<Map<String, dynamic>>> getDownloadsMapList() async {
    //get refrence to database
    Database db = await this.database;

    // var result = db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //alternative of above query is
    var result = await db.query(downloadTable);
    return result;
  }

  //Insert Operation
  Future<int> insertFile({@required DownloadedFile downloadedFile}) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.insert(downloadTable, downloadedFile.toMap());
    return result;
  }

  //Update Operation
  // Future<int> updateTask(DownloadedFile downloadedFile) async {
  //   //get refrence to database
  //   Database db = await this.database;

  //   //first convert note object into map
  //   var result = await db.update(downloadTable, downloadedFile.toMap(), where: '$colId = ?', whereArgs: [downloadedFile.id]);
  //   return result;
  // }

  //Delete Operation
  Future<int> deleteFile({@required int id}) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.delete(downloadTable, where: '$colId = $id');
    //when file is deleted from both memory and database then reload data
    await Methods.loadDownloadedFilesList();
    return result;
  }

  //Delete Operation
  Future<int> getCount() async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $downloadTable');
    var result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<DownloadedFile>> getDownloadedFilesList() async {
    var downloadMapList = await getDownloadsMapList();
    int count = downloadMapList.length;

    List<DownloadedFile> downloadList = [];
    for (int i = 0; i < count; i++) {
      downloadList.add(DownloadedFile.fromMapObject(downloadMapList[i]));
    }

    return downloadList;
  }
}
