import 'dart:async';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Authentication/screen/forgotPasswordWithKey.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/modules/categories/provider/categories_provider.dart';
import 'package:admin/modules/contactUs/providers/contact_provider.dart';
import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/modules/drawer/drawer.dart';
import 'package:admin/modules/Authentication/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './themes/style.dart';
import './routes.dart';
import 'package:provider/provider.dart';
import './modules/dashboard/provider/dashboard_provider.dart';
import 'package:uni_links/uni_links.dart';
import 'modules/coupons/statement/couponProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'checkingSharedPrefs';

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') == null) {
      setState(() {
        status = 'userNotLogedIn';
      });
    } else {
      setState(() {
        status = 'userLogedIn';
      });
    }
  }

  initState() {
    getPrefs();
    super.initState();
  }

  // StreamSubscription _sub;
  // Future<Null> initUniLinks() async {
  //   // Uri parsing may fail, so we use a try/catch FormatException.
  //   try {
  //     Uri initialUri = await getInitialUri();
  //     String myUri = initialUri.toString();
  //   } on FormatException {
  //     // Handle exception by warning the user their action did not succeed
  //     // return?
  //   } catch (e) {
  //     // print("Mahdi: initUniLinks: Error $e");
  //   }

  //   print("Mahdi: initUniLinks: 2");
  //   _sub = getUriLinksStream().listen((Uri uri) {
  //     String token = uri.toString().substring(
  //         uri.toString().indexOf("token=") + 6, uri.toString().length);

  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return ForgotPasswordWithKey(token);
  //     }));
  //     print("This is the token and nothing more. : $token");
  //   }, onError: (err) {
  //     print("Mahdi: initUniLinks: Error $err");
  //   });
  // }

  Widget page = LoginPage();
  @override
  Widget build(BuildContext context) {
    if (status == "userLogedIn") {
      page = LayoutExample();
    }
    return status == "checkingSharedPrefs"
        ? Center(child: CircularProgressIndicator())
        : MultiProvider(
            providers: [
              ChangeNotifierProvider<ResturantProvider>(
                  create: (_) => ResturantProvider()),
              ChangeNotifierProvider<AuthProvider>(
                  create: (_) => AuthProvider()),
              ChangeNotifierProvider<DashboardProvider>(
                  create: (_) => DashboardProvider()),
              ChangeNotifierProvider<CustomersProvider>(
                  create: (_) => CustomersProvider()),
              ChangeNotifierProvider<CategoryProvider>(
                  create: (_) => CategoryProvider()),
              ChangeNotifierProvider<CoupenProvider>(
                  create: (_) => CoupenProvider()),
              ChangeNotifierProvider<ContactProvider>(
                  create: (_) => ContactProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: restaurantTheme,
              home: page,
              routes: routes,
            ),
          );
  }
}
