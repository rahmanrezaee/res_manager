import 'package:admin/modules/Authentication/screen/forgotPassword.dart';
import 'package:admin/modules/Resturant/Screen/resturant_screen.dart';
import 'package:admin/modules/customers/screen/Customers_page.dart';
import 'package:admin/modules/dishes/Screen/dishes_page.dart';
import 'package:admin/modules/drawer/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:admin/modules/companyPage/Privacy&Policy.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import 'package:admin/modules/companyPage/term&condition_page.dart';

var routes = <String, WidgetBuilder>{
  LayoutExample.routeName: (context) => LayoutExample(),
  ForgotPassword.routeName: (context) => ForgotPassword(),
  TermCondition.routeName: (context) => TermCondition(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  ResturantScreen.routeName: (context) => ResturantScreen(),
  CustomersPage.routeName: (context) => CustomersPage(),
  // AddNewDish.routeName: (context) => AddNewDish(),
};
