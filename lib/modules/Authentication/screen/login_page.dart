import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Authentication/validators/formFieldsValidators.dart';
import 'package:admin/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/assest_path.dart';
import '../../drawer/drawer.dart';
import './forgotPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double contentSize = MediaQuery.of(context).size.width;
              double percentage = 1; //1 = 100%, .8 = 80% ...
              if (constraints.maxWidth > 1024) {
                percentage = .3;
                contentSize = MediaQuery.of(context).size.width / 2;
              } else if (constraints.maxWidth > 660.0) {
                percentage = .4;
                contentSize = MediaQuery.of(context).size.width / 1.8;
              } else {
                percentage = .9;
                contentSize = MediaQuery.of(context).size.width / .8;
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: contentSize,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(height: 15),
                                _loginFieldBuilder(
                                  "Email Address",
                                  emailValidator,
                                  _emailController,
                                ),
                                SizedBox(height: 15),
                                _loginFieldBuilder(
                                  "Password",
                                  passwordValidator,
                                  _passwordController,
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print("going to forgot password");
                                        Navigator.of(context).pushNamed(
                                            ForgotPassword.routeName);
                                      },
                                      child: Text(
                                        "Forgot Password",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          error == null
                              ? Container()
                              : Text(error,
                                  style: TextStyle(color: AppColors.redText)),
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
                                        style:
                                            Theme.of(context).textTheme.button,
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
                  ],
                ),
              );
            },
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
      authProvider.login(email, password).then((res) {
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
