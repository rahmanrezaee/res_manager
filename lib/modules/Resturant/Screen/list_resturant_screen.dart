import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ListResturantScreen extends StatefulWidget {
  static var routeName = "resturant";

  @override
  _ListResturantScreenState createState() => _ListResturantScreenState();
}

class _ListResturantScreenState extends State<ListResturantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: .2,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                lg: 8,
                md: 8,
                sm: 6,
                xl: 6,
                xs: 6,
                child: Text("Manage Resturant"),
              ),
              ResponsiveGridCol(
                lg: 4,
                md: 4,
                sm: 6,
                xl: 6,
                xs: 6,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DropDownFormField(
                    hintText: "Interested Industry",
                    value: "Resturant 1",
                    validator: (value) {
                      if (value == null) {
                        return "Please select an industry";
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    dataSource: [
                      {"display": "Resturant 1", "value": "Resturant 1"},
                      {"display": "Resturant 3", "value": "Resturant 3"},
                      {"display": "Resturant 2", "value": "Resturant 2"},
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Resturants",
                        style: Theme.of(context).textTheme.headline4),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: RaisedButton(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        onPressed: () {
                          Navigator.pushNamed(context, ResturantForm.routeName);
                        },
                        color: Theme.of(context).primaryColor,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ResturantItem(),
            ResturantItem(),
            ResturantItem(),
          ],
        ),
      ),
    );
  }
}
