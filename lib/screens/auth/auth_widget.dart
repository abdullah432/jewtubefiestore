import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('AuthWidget');
    final service = Provider.of<FirestoreService>(context, listen: false);
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    return FutureBuilder(
      future: service.loadUserData(),
      builder: (_, AsyncSnapshot<CurrentUser> snap) {
        if (snap.hasData) {
          print('hasData: true');

          currentUser.updateCurrentUserData(snap.data);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            locator<NavigationService>()
                .navigateAndReplaceTo(MyBottomNavBarRoute);
          });
          return WaitingScreen();
        }
        return WaitingScreen();

        // else {
        //   print('hasData: false');
        //   SchedulerBinding.instance.addPostFrameCallback((_) {
        //     locator<NavigationService>()
        //         .navigateAndReplaceTo(MyBottomNavBarRoute);
        //   });
        //   return WaitingScreen();
        // }
      },
    );
  }
}

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
