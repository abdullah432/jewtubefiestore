import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:provider/provider.dart';

import 'mychannellisttile.dart';

class MyDrawer extends StatelessWidget {
  final dividerColor = Colors.grey;
  final channelList;
  final VoidCallback onAddChannelClick;
  const MyDrawer({
    @required this.channelList,
    @required this.onAddChannelClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    return Constant.isAdmin
        ? Drawer(
            child: ListView(children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Center(
                child: Icon(
                  FlutterIcons.user_faw,
                  size: 70,
                ),
                // CircleAvatar(
                //   backgroundImage: AssetImage("assets/account.png"),
                //   radius: 70,
                // ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  user?.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 5,
                color: dividerColor,
              ),
              ListTile(
                title: Text("Show All Videos"),
                onTap: () {
                  // scaffoldKey.currentState.openEndDrawer();
                  // Resources.navigationKey.currentState
                  //     .pushNamed('/admin_all_videos');
                },
              ),
              Divider(
                thickness: 5,
                color: dividerColor,
              ),
              channelList.length > 0
                  ? Container()
                  : Container(
                      child: Center(
                        child: Text("No Channel To View"),
                      ),
                    ),
              ChannelListView(
                channellist: channelList,
              ),
              Divider(
                thickness: 2,
                color: dividerColor,
              ),
              ListTile(
                onTap: onAddChannelClick,
                leading: Icon(FlutterIcons.plus_circle_faw),
                title: Text("ADD A NEW CHANNEL"),
              )
            ]),
          )
        : null;
  }
}
