import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin/modules/drawer/drawer.dart';
import 'package:admin/modules/Authentication/screen/login_page.dart';
import './themes/style.dart';
import './routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ResturantProvider>(
            create: (_) => ResturantProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: restaurantTheme,
          home: LoginPage(),
          routes: routes,
        );
      },
      child: null,
    );
  }
}
