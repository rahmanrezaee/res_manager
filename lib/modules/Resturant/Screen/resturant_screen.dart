import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Screen/list_resturant_screen.dart';
import 'package:admin/modules/Resturant/Screen/viewRestaurants.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import 'package:admin/modules/dishes/Screen/dishes_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/modules/orders/orders_page_notification.dart';
import 'package:admin/themes/style.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/modules/notifications/notification_page.dart';

class ResturantScreen extends StatefulWidget {
  static var routeName = "Restaurants";

  @override
  _ResturantScreenState createState() => _ResturantScreenState();
}

class _ResturantScreenState extends State<ResturantScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          ResturantForm.routeName: (context) => ResturantForm(
                resId: ModalRoute.of(context)!.settings.arguments as String,
              ),
          ViewRestaurant.routeName: (context) => ViewRestaurant(
                resId: ModalRoute.of(context)!.settings.arguments as String,
              ),
          OrdersPageNotification.routeName: (context) =>
              OrdersPageNotification(),
          NotificationPage.routeName: (context) => NotificationPage(),
        },
        theme: restaurantTheme,
        home: ListResturantScreen());
  }
}
