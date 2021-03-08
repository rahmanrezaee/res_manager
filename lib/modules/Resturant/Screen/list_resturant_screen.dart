import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
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
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Manage Resturants",
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
                        color: Colors.white,
                        child: Icon(Icons.add,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Manage Resturants",
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
                      color: Colors.white,
                      child: Icon(Icons.add,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
      body: Consumer<ResturantProvider>(
        builder: (BuildContext context, value, Widget child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<ResturantProvider>(context, listen: false)
                  .getResturantList();
              return true;
            },
            child: value.listResturant != null
                ? value.listResturant.isEmpty
                    ? Text("No Resturants")
                    : ListView.builder(
                        itemCount: value.listResturant.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ResturantItem(value.listResturant[index]);
                        },
                      )
                : FutureBuilder(
                    future: value.getResturantList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          return Center(
                            child: Text("Error In Fetch Data"),
                          );
                        }
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
