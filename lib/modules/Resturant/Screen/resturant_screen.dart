import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Screen/list_resturant_screen.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/addNewDish/addNewDish_page.dart';
import 'package:admin/modules/dishes/dishes_page.dart';
import 'package:admin/themes/style.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ResturantScreen extends StatefulWidget {
  static var routeName = "resturant";

  @override
  _ResturantScreenState createState() => _ResturantScreenState();
}

class _ResturantScreenState extends State<ResturantScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      DishPage.routeName: (context) => DishPage(),
      ResturantForm.routeName: (context) => ResturantForm(
            resId: ModalRoute.of(context).settings.arguments,
          ),
    }, theme: restaurantTheme, home: ListResturantScreen());
  }
}
