import 'package:flutter/cupertino.dart';
import 'package:admin/modules/Privacy&Policy.dart';
import 'package:admin/modules/addNewDish/addNewDish_page.dart';
import 'package:admin/modules/forgotPassword/forgotPassword.dart';
import 'package:admin/modules/term&condition_page.dart';

var routes = <String, WidgetBuilder>{
  //add routes here
  ForgotPassword.routeName: (context) => ForgotPassword(),
  TermCondition.routeName: (context) => TermCondition(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  // AddNewDish.routeName: (context) => AddNewDish(),
};
