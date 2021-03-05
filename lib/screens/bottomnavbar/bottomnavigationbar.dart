import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/screens/bottomnavbar/local_widgets/drawerwidget.dart';
import 'package:jewtubefirestore/screens/category/category_page.dart';
import 'package:jewtubefirestore/screens/download/download_files_screen.dart';
import 'package:jewtubefirestore/screens/home/home.dart';
import 'package:jewtubefirestore/screens/subscription/subscriptionpage.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
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
  // bool _isConfigured = false;

  //appbar
  bool isSearchViewClicked = false;
  //channel list
  List<Channel> _channelList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      key: scaffoldKey,
      drawer: MyDrawer(
        channelList: _channelList,
      ),
      appBar: appBar(),
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
      return CategoryPage();
    } else if (index == 2) {
      return SubscriptionScreen();
    } else {
      return DownloadFilesPage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.red,
      title: isSearchViewClicked
          ? TextField(
              style: TextStyle(color: Colors.white),
              onSubmitted: (value) {
                isSearchViewClicked = false;
                // print(value);
                // Resources.navigationKey.currentState.pushReplacementNamed('/',
                //     arguments: {'issearch': true, 'txt': value});
                // // setState(() {
                // //   queryText = value;
                // // });
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white70),
                icon: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearchViewClicked = false;
                    });
                    // Resources.navigationKey.currentState
                    //     .pushReplacementNamed('/');
                  },
                ),
              ),
              autofocus: true,
              cursorColor: Colors.black,
            )
          : Row(
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    "assets/logo.png",
                    width: 35,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "JewTube",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
      leading: isAdmin
          ? IconButton(
              icon: Icon(FlutterIcons.bars_faw),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
            )
          : null,
      actions: actionWidgetList(),
    );
  }

  List<Widget> actionWidgetList() {
    return [
      //search icon
      IconButton(
        icon: isSearchViewClicked
            ? Icon(
                FlutterIcons.times_faw,
                color: Colors.white,
              )
            : Icon(
                FlutterIcons.search_faw,
                color: Colors.white,
              ),
        onPressed: () {
          //show search bar
          setState(() {
            if (isSearchViewClicked) {
              isSearchViewClicked = false;
            } else {
              isSearchViewClicked = true;
            }
          });
        },
      ),
      //if user is not sigin then show this icon
      isSignedIn
          ? IconButton(
              icon: Icon(FlutterIcons.user_faw),
              onPressed: () async {
                locator<NavigationService>().navigateAndReplaceTo(LoginRoute);
              })
          : IconButton(
              icon: Icon(FlutterIcons.sign_out_alt_faw5s),
              onPressed: () async {
                // SharedPreferences prefs =
                //     await SharedPreferences.getInstance();
                // prefs?.clear();
                locator<NavigationService>().navigateAndReplaceTo(LoginRoute);
              })
    ];
  }
}
