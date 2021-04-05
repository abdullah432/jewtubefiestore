import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/services/channelservice.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/widgets/alertdialogs/CustomAlertDialog.dart';
import 'package:provider/provider.dart';

import 'mychannellisttile.dart';

class MyDrawer extends StatelessWidget {
  final dividerColor = Colors.grey;
  final VoidCallback onAddChannelClick;
  const MyDrawer({
    @required this.onAddChannelClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    return Constant.isAdmin
        ? Drawer(
            child: ListView(
              children: <Widget>[
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
                Consumer<ChannelService>(
                  builder: (context, service, child) {
                    if (service.channelsList == null) {
                      service.loadChannelList();
                      return Center(child: CircularProgressIndicator());
                    } else if (service.channelsList.length == 0) {
                      return Container(
                        child: Center(
                          child: Text("No Channel To View"),
                        ),
                      );
                    } else
                      return ChannelListView(
                        channellist: service.channelsList,
                        onDelete: (channel) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                    onConfirmClick: () async {
                                  final channelService =
                                      Provider.of<ChannelService>(context,
                                          listen: false);
                                  await channelService.deleteChannel(channel);
                                  Navigator.pop(context);
                                });
                              });
                          // final channelservice =
                          //     Provider.of<ChannelService>(context, listen: false);
                          // channelservice.deleteChannel(channel);
                        },
                      );
                  },
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
              ],
            ),
          )
        : null;
  }
}
