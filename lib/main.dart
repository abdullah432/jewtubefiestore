import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jewtubefirestore/screens/auth/signin.dart';
import 'package:jewtubefirestore/screens/bottomnavbar/bottomnavigationbar.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  //     );
  //start loading list of downloaded files
  //function is written in 'package:jewtube/util/utils.dart'
  // loadDownloadedFilesList();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MaterialApp(
      title: 'JewTube',
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
