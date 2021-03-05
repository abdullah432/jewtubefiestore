import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/screens/home/home.dart';
import 'local_widgets/bottonnavbarwidget.dart';

class MyBottomNavBarPage extends StatefulWidget {
  final selectedIndex;
  MyBottomNavBarPage({this.selectedIndex: 1, Key key}) : super(key: key);

  @override
  _MyBottomNavBarPageState createState() =>
      _MyBottomNavBarPageState(selectedIndex);
}

class _MyBottomNavBarPageState extends State<MyBottomNavBarPage> {
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex;
  _MyBottomNavBarPageState(this._selectedIndex);

  bool _isConfigured = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
      body: PageStorage(
        child: getPage(_selectedIndex),
        bucket: bucket,
      ),
    );
  }

  getPage(index) {
    if (index == 0) {
      return HomeScreen();
    }
    if (index == 1) {
      return Container();
    } else {
      return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
