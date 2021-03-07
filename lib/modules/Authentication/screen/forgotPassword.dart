import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  static String routeName = "ForgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.arrow_back_ios, color: Colors.white),
                  Text("back",
                      style: TextStyle(color: Colors.white, fontSize: 20))
                ],
              ),
            ),
            Expanded(
                child: Text("Forgot Password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button)),
          ],
        ),
      ),
      body: LayoutBuilder(
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
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: contentSize,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Forgotten your Password ? Don't worry just type in your Registered Email address and we will take it from there",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login with your account",
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 15),
                          Form(
                            key: _formKey,
                            child: _loginFieldBuilder(
                                "Forgot Password", _emailController),
                          ),
                        ],
                      ),
                    ),
                    error != null
                        ? Text(
                            error,
                            style: TextStyle(color: AppColors.redText),
                          )
                        : Container(),
                    SizedBox(height: 15),
                    SizedBox(
                      width: contentSize - 100,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: loading == true
                            ? CircularProgressIndicator()
                            : Text(
                                "Submit",
                                style: Theme.of(context).textTheme.button,
                              ),
                        onPressed: () {
                          forgotPassword();
                        },
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool loading = false;
  String error;
  forgotPassword() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      String email = _emailController.text;
      authProvider.forgotPassword(email).then((v) {
        setState(() {
          loading = false;
        });
        if (v == true) {
          showDialog(
              context: context,
              builder: (context) {
                return LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: 400,
                    child: SimpleDialog(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.all(15),
                      children: [
                        Text(
                          "A link will be shared to your registered email address please click it to reset your password",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            color: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "OK",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Navigator.pushNamed(context, )
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                });
              });
          setState(() {
            error = null;
          });
        } else {
          setState(() {
            error = "User Not Exist";
          });
        }
      });
    }
  }
}

_loginFieldBuilder(String hintText, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
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
