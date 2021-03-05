import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchViewClicked = false;
  int _navIndex = 0;
  Color clr = Colors.grey;
  // List<Channel> _channelList = List();
  File file;
  String chnlName = "";
  bool _progressAddChannel = false;
  bool _isAppBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.white),
        //   backgroundColor: Colors.red,
        //   title: isSearchViewClicked
        //       ? TextField(
        //           style: TextStyle(color: Colors.white),
        //           onSubmitted: (value) {
        //             isSearchViewClicked = false;
        //             print(value);
        //             Resources.navigationKey.currentState.pushReplacementNamed(
        //                 '/',
        //                 arguments: {'issearch': true, 'txt': value});
        //             // setState(() {
        //             //   queryText = value;
        //             // });
        //           },
        //           textInputAction: TextInputAction.search,
        //           decoration: InputDecoration(
        //             border: InputBorder.none,
        //             hintText: 'Search',
        //             hintStyle: TextStyle(color: Colors.white70),
        //             icon: IconButton(
        //               icon: Icon(
        //                 Icons.arrow_back,
        //                 color: Colors.white,
        //               ),
        //               onPressed: () {
        //                 setState(() {
        //                   isSearchViewClicked = false;
        //                 });
        //                 Resources.navigationKey.currentState
        //                     .pushReplacementNamed('/');
        //               },
        //             ),
        //           ),
        //           autofocus: true,
        //           cursorColor: Colors.black,
        //         )
        //       : Row(
        //           children: <Widget>[
        //             InkWell(
        //               onTap: () {},
        //               child: Image.asset(
        //                 "assets/logo_new.png",
        //                 width: 35,
        //               ),
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Text(
        //               "JewTube",
        //               style: TextStyle(color: Colors.white),
        //             ),
        //           ],
        //         ),
        //   leading: isAdmin
        //       ? IconButton(
        //           icon: Icon(FlutterIcons.bars_ant),
        //           onPressed: () {
        //             Resources.scaffoldKey.currentState.openDrawer();
        //           },
        //         )
        //       : null,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: isSearchViewClicked
        //           ? Icon(
        //               FlutterIcons.times_faw,
        //               color: Colors.white,
        //             )
        //           : Icon(
        //               FlutterIcons.search_faw,
        //               color: Colors.white,
        //             ),
        //       onPressed: () {
        //         //show search bar
        //         setState(() {
        //           if (isSearchViewClicked) {
        //             isSearchViewClicked = false;
        //           } else {
        //             isSearchViewClicked = true;
        //           }
        //         });
        //       },
        //     ),
        //     // IconButton(icon: Icon(FontAwesomeIcons.userCircle), onPressed: () {}),
        //     Resources.userID == ""
        //         ? IconButton(
        //             icon: Icon(FlutterIcons.user_alt_faw5s),
        //             onPressed: () async {
        //               Navigator.of(context).pushReplacementNamed(SIGN_IN);
        //             })
        //         : IconButton(
        //             icon: Icon(FlutterIcons.sign_out_faw),
        //             onPressed: () async {
        //               // SharedPreferences prefs =
        //               //     await SharedPreferences.getInstance();
        //               // prefs?.clear();
        //               // Navigator.of(context).pushReplacementNamed(SIGN_IN);
        //             })
        //   ],
        // ),
        body: Column(
          children: [
            Text('Empty'),
          ],
        ));
  }
}
