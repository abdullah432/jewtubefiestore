import 'package:flutter/material.dart';
import 'package:jewtubefirestore/enum/auth_status.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/services/firebase_auth_service.dart';
import 'package:jewtubefirestore/services/firestoreservice.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:jewtubefirestore/utils/custom_colors.dart';
import 'package:jewtubefirestore/utils/locator.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:jewtubefirestore/utils/naviation_services.dart';
import 'package:jewtubefirestore/utils/responsive_ui.dart';
import 'package:jewtubefirestore/utils/router/routing_names.dart';
import 'local_widgets/custom_shape.dart';
import 'local_widgets/customelevatedbtn.dart';
import 'local_widgets/textformfield.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // String _userEmail;

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                CustomElevatedButton(
                  onPressed: () async {
                    // locator<NavigationService>()
                    //     .navigateAndReplaceTo(MyBottomNavBarRoute);
                    if (_formKey.currentState.validate()) {
                      if (checkBoxValue) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        final database = context.read<FirestoreService>();
                        final firebaseauth =
                            context.read<FirebaseAuthService>();
                        var user =
                            await firebaseauth.createUserWithEmailAndPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (user != null) {
                          database.uid = user.uid;

                          final currentUser = CurrentUser(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            isAdmin: false,
                          );
                          await database.createUser(user: currentUser);

                          // Navigator.pop(context);
                          locator<NavigationService>()
                              .navigateAndReplaceTo(AuthRoute);
                        }

                        if (user == null) {
                          Methods.showSnackbar(
                            scafoldKey: scaffoldKey,
                            message: firebaseauth.userAuth.error,
                          );
                        }
                      } else {
                        Methods.showToast(
                            message: 'Please accept terms and condition');
                      }
                    }
                  },
                  title: 'SIGN UP',
                  width: _large
                      ? _width / 4
                      : (_medium ? _width / 3.75 : _width / 3.5),
                  fontSize: _large ? 16 : (_medium ? 14 : 12),
                ),
                // infoTextRow(),
                // socialIconsRow(),
                signInTextRow(),
                //login in progress widget
                Consumer<FirebaseAuthService>(
                  builder: (context, data, child) {
                    return data.userAuth.authStatus ==
                            AuthStatus.RegistrationInProgress
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                CustomColor.primaryColor,
                              ),
                            ),
                          )
                        : Container(height: 0.0);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            nameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget nameTextFormField() {
    return CustomTextField(
      textEditingController: _nameController,
      keyboardType: TextInputType.name,
      icon: Icons.account_box,
      hint: "Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: _emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      textEditingController: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              // locator<NavigationService>().navigateTo(LoginRoute);
              Navigator.pop(context);
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/transparentlogo.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
        //back button
        Positioned(
          top: 50,
          left: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
      ],
    );
  }
}
