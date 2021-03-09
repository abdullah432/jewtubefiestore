import 'package:firebase_auth/firebase_auth.dart';
import 'package:jewtubefirestore/enum/auth_status.dart';

class UserAuth {
  AuthStatus authStatus;
  String error;
  User user;
  UserAuth({this.authStatus, this.error, this.user});
}
