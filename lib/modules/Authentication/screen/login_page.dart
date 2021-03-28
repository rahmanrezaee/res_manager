import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Authentication/screen/forgotPasswordWithKey.dart';
import 'package:admin/modules/Authentication/validators/formFieldsValidators.dart';
import 'package:admin/modules/companyPage/Privacy&Policy.dart';
import 'package:admin/modules/companyPage/term&condition_page.dart';
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

class _LoginPageState extends State<LoginPage> {
  StreamSubscription _sub;
   initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
        // if (initialLink != null) initialUri = Uri.parse(String initialLink = initialUri.toString());
      String token = link.toString().substring(
          link.toString().indexOf("token=") + 6, link.toString().length);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ForgotPasswordWithKey(token);
      }));
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      // if (initialLink != null) initialUri = Uri.parse(String initialLink = initialUri.toString());
      String token = initialLink.toString().substring(
          initialLink.toString().indexOf("token=") + 6, initialLink.toString().length);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ForgotPasswordWithKey(token);
      }));

    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    });
  }
//   Future<Null> initUniLinks(context) async {
//   // Uri parsing may fail, so we use a try/catch FormatException.
//   try {
//       String initialUri = await getInitialLink();
//       String uri = initialUri.toString();
//       String token = uri.toString().substring(
//           uri.toString().indexOf("token=") + 6, uri.toString().length);
//       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//         return ForgotPasswordWithKey(token);
//       }));
//       print("This is the token and nothing more: $token");
//   } on FormatException {
//     print("Error Accured");
//     // Handle exception by warning the user their action did not succeed
//     // return?
//   } catch (e) {
//     print("Error Catched $e");
//     // print("Mahdi: initUniLinks: Error $e");
//   }
//   print("Mahdi: initUniLinks: 2");
//   _sub = getUriLinksStream().listen((Uri uri) {
//     if (!mounted) return;  
//     String token = uri
//         .toString()
//         .substring(uri.toString().indexOf("token=") + 6, uri.toString().length);

//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return ForgotPasswordWithKey(token);
//     }));
//     print("This is the token and nothing more: $token");
//   }, onError: (err) {
//     if (!mounted) return;
//     print("Mahdi: initUniLinks: Error $err");
//   });
// }

  
  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken = "";
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
    initUniLinks(context);
    getFcmToken();
    super.initState();
  }

  Future<void> getFcmToken() async {
    print('get Fcm Token');
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) async {
        fcmToken = await _fcm.getToken();
        log("firebase token $fcmToken");
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      fcmToken = await _fcm.getToken();
      log("firebase token $fcmToken");
    }
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
                Image.asset("${AssestPath.logo}", width: 150),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Login with your account",
                          style: Theme.of(context).textTheme.headline4),
                      SizedBox(height: 15),
                      _loginFieldBuilder(
                        "Email Address",
                        emailValidator,
                        _emailController,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: obscureText,
                        controller: _passwordController,
                        // validator: (v) {
                        //   return validator(v);
                        // },
                        decoration: InputDecoration(
                          hintText: "Password",
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
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print("going to forgot password");
                              Navigator.of(context)
                                  .pushNamed(ForgotPassword.routeName);
                            },
                            child: Text(
                              "Forgot Password",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            text:
                                "By using this app you are accepting our ",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushNamed(TermCondition.routeName);
                                  },
                                text: "Terms and Conditions",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('privacy policy');
                                    Navigator.of(context)
                                        .pushNamed(PrivacyPolicy.routeName, arguments: "login");
                                  },
                                text: "Privacy Policy",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                error == null
                    ? Container()
                    : Text(error, style: TextStyle(color: AppColors.redText)),
                SizedBox(height: 10),
                RaisedButton(
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
    }
  }
}

_loginFieldBuilder(
    String hintText, Function validator, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    validator: (v) {
      return validator(v);
    },
    decoration: InputDecoration(
      hintText: hintText,
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
