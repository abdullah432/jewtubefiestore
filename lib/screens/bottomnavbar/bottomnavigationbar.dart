import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/screens/bottomnavbar/local_widgets/drawerwidget.dart';
import 'package:jewtubefirestore/screens/category/category_page.dart';
import 'package:jewtubefirestore/screens/download/download_files_screen.dart';
import 'package:jewtubefirestore/screens/home/home.dart';
import 'package:jewtubefirestore/screens/searchpage/searchpage.dart';
import 'package:jewtubefirestore/screens/subscription/subscriptionpage.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/services/firebase_auth_service.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/newchanneldialog.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/selectchanneldialog.dart';
import 'package:provider/provider.dart';
import 'local_widgets/bottonnavbarwidget.dart';

class MyBottomNavBarPage extends StatefulWidget {
  final selectedIndex;
  MyBottomNavBarPage({this.selectedIndex: 0, Key key}) : super(key: key);

  @override
  _MyBottomNavBarPageState createState() =>
      _MyBottomNavBarPageState(selectedIndex);
}

class _MyBottomNavBarPageState extends State<MyBottomNavBarPage> {
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex;
  _MyBottomNavBarPageState(this._selectedIndex);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // bool _isConfigured = false;

  //appbar
  bool isSearchViewClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      key: scaffoldKey,
      drawer: Constant.isAdmin
          ? MyDrawer(
              onAddChannelClick: () {
                //first clear filepicker data
                Provider.of<FilePickerService>(context, listen: false)
                    .clearFilePickItem();
                showDialog(
                  context: context,
                  builder: (context) {
                    return CreateNewChannelDialogBox();
                  },
                );
              },
            )
          : null,
      appBar: appBar(),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
      body: PageStorage(
        child: getPage(_selectedIndex),
        bucket: bucket,
      ),
      floatingActionButton: Visibility(
        visible: Constant.isAdmin,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Methods.showAlertDialog(
              context: context,
              dialog: SelectChannelDialogBox(
                onChannelSelection: (channel) {
                  final filepickerservice =
                      Provider.of<FilePickerService>(context, listen: false);
                  filepickerservice.clearFilePickItem();
                  Navigator.pop(context);
                  locator<NavigationService>()
                      .navigateTo(AddVideoScreenRoute, arguments: channel);
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  getPage(index) {
    if (index == 0) return HomeScreen();

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
    print('finish');
  }

  appBar() {
    print('From appbar: ' + Constant.isSignedIn.toString());
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.red,
      automaticallyImplyLeading: Constant.isAdmin,
      title: isSearchViewClicked
          ? TextField(
              style: TextStyle(color: Colors.white),
              onSubmitted: (value) async {
                isSearchViewClicked = false;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(queryText: value),
                  ),
                );

                setState(() {});
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
      leading: Constant.isAdmin
          ? IconButton(
              icon: Icon(FlutterIcons.bars_faw),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
            )
          : Container(width: 0),
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
      Constant.isSignedIn
          ? IconButton(
              icon: Icon(FlutterIcons.sign_out_alt_faw5s),
              onPressed: () async {
                final authService = FirebaseAuthService();
                await authService.signOut();
                // print('signout');
                // await locator<NavigationService>().navigateTo(LoginRoute);
                Constant.isSignedIn = false;
                setState(() {});
              },
            )
          : IconButton(
              icon: Icon(FlutterIcons.user_faw),
              onPressed: () async {
                await locator<NavigationService>().navigateTo(LoginRoute);
                setState(() {});
              },
            )
    ];
  }
}
