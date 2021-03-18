import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:jewtubefirestore/enum/auth_status.dart';
import 'package:jewtubefirestore/model/user_auth.dart';

UserAuth firebaseExceptionHandler({
  @required exception,
  @required bool isLogin,
}) {
  if (Platform.isAndroid) {
    switch (exception.message) {
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'User not found',
        );
      case 'The password is invalid or the user does not have a password.':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Invalid Password',
        );
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Network connection failed',
        );
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Missing Google Auth Token',
        );
      case 'ERROR_ABORTED_BY_USER':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Sign in aborted by user',
        );
      case 'Password should be at least 6 characters':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Password should be at least 6 characters',
        );
      // ...
      default:
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Unexpected Error',
        );
    }
  } else if (Platform.isIOS) {
    switch (exception.code) {
      case 'Error 17011':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'User not found',
        );
      case 'Error 17009':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Invalid Password',
        );
      case 'Error 17020':
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Network connection failed',
        );
      // ...
      default:
        print('signinwithgoogel error: ' + exception.toString());
        return UserAuth(
          authStatus:
              isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
          error: 'Unexpected Error',
        );
    }
  } else {
    return UserAuth(
      authStatus:
          isLogin ? AuthStatus.LoggedInFail : AuthStatus.RegistrationFail,
      error: 'Unexpected Error',
    );
  }
}
