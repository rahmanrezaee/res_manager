import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Authentication/screen/forgotPasswordWithKey.dart';
import 'package:admin/modules/Authentication/validators/formFieldsValidators.dart';
// import 'package:admin/modules/companyPage/Privacy&Policy.dart';
// import 'package:admin/modules/companyPage/term&condition_page.dart';
import 'package:admin/modules/term/term&condition_page.dart';
import 'package:admin/modules/policy/Privacy&Policy.dart';
// import 'package:admin/modules/companyPage/Privacy&Policy.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/themes/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import '../../../constants/assest_path.dart';
import '../../drawer/drawer.dart';
import './forgotPassword.dart';
import '../providers/linkListener.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "loginpage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

bool first = true;

class _LoginPageState extends State<LoginPage> {
  StreamSubscription _sub;
  String _latestLink = 'Unknown';
  Uri _latestUri;

  Function get autovalidate => null;

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      _latestLink = link ?? 'Unknown';
      _latestUri = null;
      try {
        if (link != null) {
          String token = link.toString().substring(
              link.toString().indexOf("token=") + 6, link.toString().length);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ForgotPasswordWithKey(token);
          }));
        }
      } on FormatException {}
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Get the latest link
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      //   print('initial link: $initialLink');
      if (initialLink != null && first == true) {
        first = false;
        String token = initialLink.toString().substring(
            initialLink.toString().indexOf("token=") + 6,
            initialLink.toString().length);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ForgotPasswordWithKey(token);
        }));
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  final _formKey = GlobalKey<FormState>();
  String fcmToken = "fcm token";
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;
  StreamSubscription iosSubscription;

  @override
  void dispose() {
    if (_sub != null) _sub.cancel();
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initPlatformStateForStringUniLinks();
    getFcmToken();
    super.initState();
  }

  Future<void> getFcmToken() async {
    print('get Fcm Token');

    FirebaseMessaging.instance.getToken().then((valu) {
      this.fcmToken = valu;
      log("firebase token $fcmToken");
    });
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Image.asset("${AssestPath.logo}", width: 150),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login with Your Account",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: getHelfIpadAndFullMobWidth(context),
                        child: _loginFieldBuilder(
                          "Email Address",
                          emailValidator,
                          _emailController,
                          autovalidate,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: getHelfIpadAndFullMobWidth(context),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: obscureText,
                          controller: _passwordController,
                          validator: (v) {
                            return passwordValidator(v);
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorStyle: TextStyle(color: Colors.red),
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: obscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.only(left: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: AppColors.redText),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: showAppBarNodepad(context)
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print("going to forgot password");
                              Navigator.of(context)
                                  .pushNamed(ForgotPassword.routeName);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                error == null
                    ? Container()
                    : Text(error, style: TextStyle(color: AppColors.redText)),
                SizedBox(height: 10),
                Container(
                  width: getHelfIpadAndFullMobWidth(context),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loading == true
                            ? CircularProgressIndicator()
                            : Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.button,
                              ),
                      ],
                    ),
                    onPressed: () {
                      login();
                      // Navigator.pushReplacementNamed(
                      //     context, LayoutExample.routeName);
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
  String error;
  login() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      try {
        authProvider.login(email, password, this.fcmToken).then((res) {
          setState(() {
            loading = false;
          });
          if (res['status'] == true) {
            setState(() {
              error = null;
            });
            Navigator.pushReplacementNamed(context, LayoutExample.routeName);
          } else {
            setState(() {
              error = res['message'];
            });
          }
        });
      } catch (e) {
        setState(() {
          loading = false;
          error = "Error: please try again.";
        });
      }
    }
  }
}

_loginFieldBuilder(String hintText, Function validator,
    TextEditingController controller, Function autovalidate) {
  return TextFormField(
    controller: controller,
    validator: (v) {
      return validator(v);
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      hintText: hintText,
      errorStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.redText),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}
