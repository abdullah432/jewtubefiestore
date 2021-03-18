import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
import 'package:jewtubefirestore/widgets/loginalertdialog.dart';
import 'package:provider/provider.dart';

class SubscribeWidget extends StatefulWidget {
  final String channelID;
  SubscribeWidget({
    this.channelID,
  });

  @override
  _SubscribeWidgetState createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  Color clr = Colors.blueGrey;
  bool status = false;
  CurrentUser currentuser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentuser = Provider.of<CurrentUser>(context, listen: false);
    if (Constant.isSignedIn)
      status = currentuser.subscribedTo.contains(widget.channelID);
    if (status) {
      clr = Colors.grey;
    } else {
      clr = Colors.red;
    }
    return TextButton(
        onPressed: () {
          if (Constant.isSignedIn) {
            final database =
                Provider.of<FirestoreService>(context, listen: false);
            database.subscribeToChannel(
              channeluid: widget.channelID,
              useruid: currentuser.reference.id,
            );

            currentuser.subscribedTo.add(widget.channelID);

            setState(() {});
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return EnableSubscriptionDialogBox(
                  onLoginClick: () {
                    print('login');
                    Navigator.pop(context);
                    locator<NavigationService>().navigateTo(LoginRoute);
                  },
                );
              },
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status ? "SUBSCRIBED" : "SUBSCRIBE",
              style: TextStyle(color: clr, fontSize: 12),
            ),
          ],
        )
        // color: Colors.transparent,
        // shape: RoundedRectangleBorder(side: BorderSide(color: clr, width: 1)),
        );
  }
}
