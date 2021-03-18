import 'package:flutter/material.dart';
import 'package:jewtubefirestore/screens/channel/channelscreen.dart';
import 'package:jewtubefirestore/screens/subscription/local_widgets/channellistview.dart';
import 'package:jewtubefirestore/services/channelservice.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
import 'package:jewtubefirestore/widgets/loginalertdialog.dart';
import 'package:provider/provider.dart';

import 'local_widgets/videoListView.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String text = "No Subscriptions";

  isUserSignedIn() {
    if (!Constant.isSignedIn) {
      Future.delayed(Duration.zero, () async {
        Methods.showAlertDialog(
          context: context,
          dialog: EnableSubscriptionDialogBox(
            onLoginClick: () {
              locator<NavigationService>().navigateTo(LoginRoute);
            },
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ChannelService>(context, listen: false).isRefresh = false;
    isUserSignedIn();
    return Scaffold(body: Consumer<ChannelService>(
      builder: (context, channelservice, child) {
        if (channelservice.subscribedChannelList == null) {
          channelservice.loadSubscribedChannelData(context);
          return Center(child: CircularProgressIndicator());
        } else if (channelservice.subscribedChannelList.length == 0 &&
            channelservice.subscribedChannelVideosList.length == 0) {
          refreshData(channelservice);
          return Center(child: Text('No data available'));
        }
        refreshData(channelservice);

        return screenContent(channelservice);
      },
    ));
  }

  screenContent(ChannelService channelService) {
    return Constant.isSignedIn
        ? SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async =>
                  channelService.loadSubscribedChannelData(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //channels list
                  ChannelListView(
                    channelList: channelService.subscribedChannelList,
                    onChannelClick: (channel) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChannelPage(
                            channelId: channel.reference.id,
                            channelName: channel.channelName,
                            profileUrl: channel.profileurl,
                          ),
                        ),
                      );
                    },
                  ),
                  //videos list
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: VideoList(
                      videos: channelService.subscribedChannelVideosList,
                      isSubscriptionBtnVisible: false,
                      videoStyleIndex: 2,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: Text('Please signin ...'));
  }

  refreshData(ChannelService service) async {
    if (!service.isRefresh) {
      service.loadSubscribedChannelData(context);
      service.isRefresh = true;
      print('refreshed');
    }
  }
}
