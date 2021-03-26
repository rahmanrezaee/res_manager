import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Widget/ResturantItemBuilder.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ListResturantScreen extends StatefulWidget {
  static var routeName = "resturant";

  @override
  _ListResturantScreenState createState() => _ListResturantScreenState();
}

class _ListResturantScreenState extends State<ListResturantScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    Text(
                      "Manage Resturants",
                    ),
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
                bottom: isLoading
                    ? PreferredSize(
                        preferredSize: Size(10, 10),
                        child: LinearProgressIndicator(),
                      )
                    : null,
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
                    child: Visibility(
                      visible: showAppBarNodepad(context),
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
                  ),
                ],
              ),
              bottom: isLoading
                  ? PreferredSize(
                      preferredSize: Size(10, 10),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Resturants", style: Theme.of(context).textTheme.headline4),
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
          Expanded(
                      child: Consumer<ResturantProvider>(
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
                                return resturantItem(value.listResturant[index]);
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
          ),
        ],
      ),
    );
  }

  Widget resturantItem(resturantModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text("${resturantModel.resturantName}",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 2,
              child: Text("${resturantModel.activeOrder} Active Orders",
                  style: TextStyle(color: Colors.grey)),
            ),
            Row(
              children: [
                IconButton(
                  icon: Image.asset("assets/images/edit.png"),
                  onPressed: () {
                    Navigator.pushNamed(context, ResturantForm.routeName,
                        arguments: resturantModel.id);
                  },
                ),
                IconButton(
                  icon: Image.asset("assets/images/delete.png"),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "Delete Resturant!",
                              okFun: () {
                                Provider.of<ResturantProvider>(context,
                                        listen: false)
                                    .deleteResturant(resturantModel.id)
                                    .then((res) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // ScaffoldMessenger.of(context)
                                  //     .hideCurrentSnackBar();
                                  if (res == true) {
                                    // Navigator.of(context).pop();
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(new SnackBar(
                                    //   content: Text(
                                    //       "The user deleted Successfuly."),
                                    // ));
                                  } else {
                                    // Navigator.of(context).pop();
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(new SnackBar(
                                    //   content: Text(
                                    //     "Something went wrong while deleting customer.",
                                    //     style: TextStyle(
                                    //         color: AppColors.redText),
                                    //   ),
                                    // ));
                                  }
                                });
                              },
                              cancelFun: () {},
                              descreption: "Are You Sure To Delete Resturants?",
                            ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
