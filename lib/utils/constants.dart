import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/downloaded_files.dart';
import 'package:jewtubefirestore/model/video.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

bool isAdmin = true;
bool isSignedIn = true;

List<DownloadedFile> listOfDownloadedFiles = [];
List<VideoModel> downloadingVideosList = [];

final Color unselectedColor = Colors.grey[700];
final Color selectedColor = Colors.red;
