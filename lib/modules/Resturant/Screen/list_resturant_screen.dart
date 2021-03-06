import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: Text("Manage Resturant"),
      ),
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
            Consumer<ResturantProvider>(
              builder: (BuildContext context, value, Widget child) {
                
                // return value.listResturant != null ?
                //     value.listResturant.isEmpty ? 
                //     Text("No Resturants"): ListView.builder(itemBuilder: null)



              },
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
