import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/downloaded_files.dart';

class Constant {
  static bool isAdmin = false;
  static bool isSignedIn = false;

  static List<DownloadedFile> listOfDownloadedFiles = [];
  // static List<VideoModel> downloadingVideosList = [];

  static final Color unselectedColor = Colors.grey[700];
  static final Color selectedColor = Colors.red;

  static List<String> listOfcategories = [
    'Daily Dose',
    'Torah Classes',
    'Movies',
    'Music',
  ];

  static List<String> listOfLanguages = ['English', 'French', 'Spanish'];
}
