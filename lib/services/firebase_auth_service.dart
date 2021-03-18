import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/enum/auth_status.dart';
import 'package:jewtubefirestore/model/user_auth.dart';
import 'package:jewtubefirestore/utils/firebase_exception_handler.dart';

class FirebaseAuthService with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  UserAuth _userAuth = UserAuth(authStatus: null, error: null, user: null);

  UserAuth get userAuth => _userAuth;

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _userAuth = UserAuth(
        authStatus: AuthStatus.LogingInProgress,
      );
      notifyListeners();
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));
      _userAuth = UserAuth(
        authStatus: AuthStatus.LoggedInSuccess,
        user: userCredential.user,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print('exception message: ' + e.message);
      _userAuth.error = e?.message ?? 'Unexpected issue';
      _userAuth.authStatus = AuthStatus.RegistrationFail;
      // _userAuth = firebaseExceptionHandler(
      //   exception: e,
      //   isLogin: true,
      // );
      notifyListeners();
      return false;
    }
  }

  Future<User> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _userAuth = UserAuth(
        authStatus: AuthStatus.RegistrationInProgress,
      );
      notifyListeners();
      final UserCredential _userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _userAuth = UserAuth(
        authStatus: AuthStatus.RegistreredSuccess,
        user: _userCredential.user,
      );
      notifyListeners();
      return _userCredential.user;
    } catch (e) {
      print('Signup Fail Exception: ' + e.message.toString());
      _userAuth.error = e?.message ?? 'Unexpected issue';
      _userAuth.authStatus = AuthStatus.RegistrationFail;
      // _userAuth = firebaseExceptionHandler(
      //   exception: e,
      //   isLogin: false,
      // );
      notifyListeners();
      return null;
    }
  }

  Future<User> registerUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
      name: 'Secondary',
      options: Firebase.app().options,
    );
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }

    await app.delete();
    return Future.sync(() => userCredential.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> signInWithEmailAndLink({String email, String link}) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return userCredential.user;
  }

  Future<bool> isSignInWithEmailLink(String link) async {
    return _firebaseAuth.isSignInWithEmailLink(link);
  }

  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleId: iOSBundleID,
        androidPackageName: androidPackageName,
        androidInstallApp: androidInstallIfNotAvailable,
        androidMinimumVersion: androidMinimumVersion,
      ),
    );
  }

  // Future<User> signInWithGoogle(context) async {
  //   try {
  //     _userAuth = UserAuth(
  //       authStatus: AuthStatus.LogingInProgress,
  //     );
  //     notifyListeners();

  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     final GoogleSignInAccount googleUser = await googleSignIn.signIn();

  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //         final UserCredential userCredential = await _firebaseAuth
  //             .signInWithCredential(GoogleAuthProvider.credential(
  //           idToken: googleAuth.idToken,
  //           accessToken: googleAuth.accessToken,
  //         ));
  //         _userAuth = UserAuth(
  //           authStatus: AuthStatus.LoggedInSuccess,
  //           user: userCredential.user,
  //         );
  //         if (userCredential.additionalUserInfo.isNewUser) {
  //           final database =
  //               Provider.of<FirestoreService>(context, listen: false);
  //           database.uid = userCredential.user.uid;

  //           final currentUser = CurrentUser(
  //             name: userCredential.user.displayName,
  //             email: userCredential.user.email,
  //             notification: true,
  //           );
  //           await database.createUser(user: currentUser);
  //         }
  //         notifyListeners();
  //         return userCredential.user;
  //       } else {
  //         throw PlatformException(
  //             code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //             message: 'Missing Google Auth Token');
  //       }
  //     } else {
  //       throw PlatformException(
  //           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //     }
  //   } catch (e) {
  //     print('Signup Fail Exception: ' + e.toString());
  //     _userAuth = firebaseExceptionHandler(
  //       exception: e,
  //       isLogin: false,
  //     );
  //     notifyListeners();
  //     return null;
  //   }
  // }

  // Future<User> signInWithFacebook(BuildContext context) async {
  //   final FacebookLogin facebookLogin = FacebookLogin();
  //   // https://github.com/roughike/flutter_facebook_login/issues/210
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final FacebookLoginResult result =
  //       await facebookLogin.logIn(<String>['public_profile']);
  //   if (result.accessToken != null) {
  //     final UserCredential userCredential =
  //         await _firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.credential(result.accessToken.token),
  //     );
  //     if (userCredential.additionalUserInfo.isNewUser) {
  //       final database = Provider.of<FirestoreService>(context, listen: false);
  //       database.uid = userCredential.user.uid;

  //       final currentUser = CurrentUser(
  //         name: userCredential.user.displayName,
  //         email: userCredential.user.email,
  //         notification: true,
  //       );
  //       await database.createUser(user: currentUser);
  //     }
  //     return userCredential.user;
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }

  // @override
  // Future<User> signInWithApple({List<Scope> scopes = const []}) async {
  //   // final AuthorizationResult result = await AppleSignIn.performRequests(
  //   //     [AppleIdRequest(requestedScopes: scopes)]);
  //   // switch (result.status) {
  //   //   case AuthorizationStatus.authorized:
  //   //     final appleIdCredential = result.credential;
  //   //     final oAuthProvider = OAuthProvider(providerId: 'apple.com');
  //   //     final credential = oAuthProvider.getCredential(
  //   //       idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //   //       accessToken:
  //   //           String.fromCharCodes(appleIdCredential.authorizationCode),
  //   //     );

  //   //     final authResult = await _firebaseAuth.signInWithCredential(credential);
  //   //     final firebaseUser = authResult.user;
  //   //     if (scopes.contains(Scope.fullName)) {
  //   //       final updateUser = UserUpdateInfo();
  //   //       updateUser.displayName =
  //   //           '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
  //   //       await firebaseUser.updateProfile(updateUser);
  //   //     }
  //   //     return _userFromFirebase(firebaseUser);
  //   //   case AuthorizationStatus.error:
  //   //     throw PlatformException(
  //   //       code: 'ERROR_AUTHORIZATION_DENIED',
  //   //       message: result.error.toString(),
  //   //     );
  //   //   case AuthorizationStatus.cancelled:
  //   //     throw PlatformException(
  //   //       code: 'ERROR_ABORTED_BY_USER',
  //   //       message: 'Sign in aborted by user',
  //   //     );
  //   // }
  //   // return null;
  // }

  User currentUser() {
    final User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    // final FacebookLogin facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
