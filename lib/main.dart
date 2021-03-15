import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jewtubefirestore/screens/auth/auth_widget.dart';
import 'package:jewtubefirestore/screens/bottomnavbar/bottomnavigationbar.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/services/firebase_auth_service.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/services/videosService.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/router/router.dart';
import 'package:provider/provider.dart';
import 'model/user.dart';
import 'services/channelservice.dart';
import 'services/firebasestorageservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  //start loading list of downloaded files
  //function is written in 'package:jewtube/util/utils.dart'
  // loadDownloadedFilesList();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirestoreService>(
            create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseStorageService()),
        ChangeNotifierProvider<CurrentUser>(
          create: (_) => CurrentUser(),
        ),
        ChangeNotifierProvider<ChannelService>(create: (_) => ChannelService()),
        ChangeNotifierProvider<FilePickerService>(
            create: (_) => FilePickerService()),
        ChangeNotifierProvider<VideosService>(create: (_) => VideosService()),
      ],
      child: MaterialApp(
        title: 'JewTube',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.red),
        home: AuthWidget(),
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
