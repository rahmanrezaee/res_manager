import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Screen/list_resturant_screen.dart';
import 'package:admin/modules/Resturant/Screen/viewRestaurants.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import 'package:admin/modules/dishes/Screen/dishes_page.dart';
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
    return MaterialApp(routes: {
      ResturantForm.routeName: (context) => ResturantForm(
            resId: ModalRoute.of(context).settings.arguments,
          ),
      ViewRestaurant.routeName: (context) => ViewRestaurant(
            resId: ModalRoute.of(context).settings.arguments,
          ),
    }, theme: restaurantTheme, home: ListResturantScreen());
  }
}
