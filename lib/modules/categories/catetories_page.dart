import 'package:admin/modules/Resturant/Screen/list_resturant_screen.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import 'package:admin/modules/categories/provider/categories_provider.dart';
import 'package:admin/modules/dishes/Screen/dishes_page.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/themes/style.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants/assest_path.dart';
import 'package:admin/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'models/categorie_model.dart';

class CatetoriesPage extends StatefulWidget {
  @override
  _CatetoriesPageState createState() => _CatetoriesPageState();
}

class _CatetoriesPageState extends State<CatetoriesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          NotificationPage.routeName: (context) => NotificationPage(),
          CatetoriesListPage.routeName: (context) => CatetoriesListPage(),
          DishPage.routeName: (context) => DishPage(
                ModalRoute.of(context).settings.arguments,
              ),
          AddNewDish.routeName: (context) => AddNewDish(
                ModalRoute.of(context).settings.arguments,
              ),
        },
        theme: restaurantTheme,
        home: CatetoriesListPage());
  }
}

class CatetoriesListPage extends StatefulWidget {
  static final routeName = "categoryList";
  @override
  _CatetoriesListPageState createState() => _CatetoriesListPageState();
}

class _CatetoriesListPageState extends State<CatetoriesListPage> {
  TextEditingController newCategoryController = new TextEditingController();

  String error;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, catProvider, child) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: showAppBarNodepad(context)
            ? AppBar(
                elevation: .2,
                title: Text("Manage Category"),
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [NotificationAppBarWidget()],
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // bottom:
              )
            : AppBar(
                elevation: .2,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title:
                    // Consumer<CategoryProvider>(builder: (context, catProvider, child) {
                    ResponsiveGridRow(
                  children: [
                    ResponsiveGridCol(
                      lg: 8,
                      md: 8,
                      sm: 12,
                      xl: 12,
                      xs: 12,
                      child: Text("Manage Categories"),
                    ),
                    ResponsiveGridCol(
                      lg: 4,
                      md: 4,
                      sm: 12,
                      xl: 12,
                      xs: 12,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: catProvider.getRestaurant == null
                            ? FutureBuilder(
                                future: catProvider.fetchRes(),
                                builder: (context, snapshot) {
                                  return Center(
                                      child: Text("Loading restaurants..."));
                                })
                            : DropDownFormField(
                                hintText: "Select Restaurants ",
                                value: catProvider.resturantId,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select an Restaurants";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  catProvider.setResturantId(value);
                                  // setState(() {
                                  //   resturantid = value;
                                  // });
                                },
                                onChanged: (value) {
                                  catProvider.setResturantId(value);
                                  print(value);
                                  // setState(() {
                                  //   resturantid = value;
                                  // });
                                },
                                dataSource: [
                                  ...catProvider.getRestaurant.map((e) {
                                    return {
                                      "display": e.restaurant['username'],
                                      "value": e.restaurant['_id'],
                                    };
                                  }).toList()
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                      ),
                    ),
                  ],
                )
                // }),
                ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Visibility(
              visible: showAppBarNodepad(context),
              child: Padding(
                padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: PreferredSize(
                  preferredSize:
                      Size(double.infinity, AppBar().preferredSize.height),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: catProvider.getRestaurant == null
                        ? FutureBuilder(
                            future: catProvider.fetchRes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                catProvider.setResturantId(catProvider
                                    .getRestaurant[0].restaurant['_id']);

                                catProvider.setCategoryToNull();
                              }
                              return Center(child: CircularProgressIndicator());
                            })
                        : DropDownFormField(
                            hintText: "Select Restaurant",
                            value: catProvider.resturantId,
                            onChanged: (value) {
                              catProvider.setResturantId(value);
                              catProvider.setCategoryToNull();
                            },
                            dataSource: [
                              ...catProvider.getRestaurant.map((e) {
                                return {
                                  "display": e.restaurant['username'],
                                  "value": e.restaurant['_id'],
                                };
                              }).toList()
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories",
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              bool addingCat = false;
                              return StatefulBuilder(
                                  builder: (context, snapshot) {
                                return SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text("Add New Category",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 25),
                                  children: [
                                    Divider(),
                                    TextField(
                                      // minLines: 6,
                                      // maxLines: 6,
                                      controller: newCategoryController,
                                      decoration: InputDecoration(
                                        hintText: "Enter here",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        contentPadding:
                                            EdgeInsets.only(left: 10, top: 15),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    error == null
                                        ? Container()
                                        : Text(error,
                                            style: TextStyle(
                                                color: AppColors.redText)),
                                    SizedBox(height: 10),
                                    addingCat == true
                                        ? Text("Adding...")
                                        : Container(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        color: Theme.of(context).primaryColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text("Save",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button),
                                        onPressed: () {
                                          if (newCategoryController
                                                  .text.length <
                                              1) {
                                            setState(() {
                                              error = "Please fill the field";
                                            });
                                          } else if (newCategoryController
                                                  .text.length <
                                              2) {
                                            setState(() {
                                              error =
                                                  "Please add more character";
                                            });
                                          } else {
                                            setState(() {
                                              addingCat = true;
                                            });
                                            catProvider
                                                .addNewCategory(
                                              catProvider.resturantId,
                                              newCategoryController.text,
                                            )
                                                .then((value) {
                                              setState(() {
                                                addingCat = false;
                                              });
                                              if (value['status'] == true) {
                                                newCategoryController.text = "";

                                                Navigator.of(context).pop();
                                              } else {
                                                // ScaffoldMessenger.of(
                                                //         context)
                                                //     .showSnackBar(
                                                //         SnackBar(
                                                //   content: const Text(
                                                //       'Something went wrong!'),
                                                //   duration:
                                                //       const Duration(
                                                //     seconds: 3,
                                                //   ),
                                                // ));
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              });
                            },
                          );
                        },
                        color: Theme.of(context).primaryColor,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            catProvider.resturantId == null
                ? Expanded(
                    child: Center(
                      child: Text("Please Select A Restaurants"),
                    ),
                  )
                : catProvider.getCategories == null
                    ? FutureBuilder(
                        future: catProvider.fetchCategories(),
                        builder: (context, snapshot) {
                          return Expanded(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        })
                    : catProvider.getCategories.length < 1
                        ? Expanded(
                            child: Center(
                              child: Text("No Category"),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: catProvider.getCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _categoryItemBuilder(
                                  context,
                                  catProvider.getCategories[index],
                                  catProvider,
                                  catProvider.resturantId,
                                );
                              },
                            ),
                          )
          ],
        ),
      );
    });
  }

  _categoryItemBuilder(context, CategoryModel category,
      CategoryProvider catProvider, String resId) {
    TextEditingController editCatController = new TextEditingController();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.categoryName,
                style: Theme.of(context).textTheme.headline4),
            Text("${category.foodNumber} Dishes",
                style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.room_service, color: AppColors.green),
                  onPressed: () {
                    Map pa = {
                      "catId": category.id,
                      "resturantId": resId,
                    };
                    print("pa $pa");
                    Navigator.pushNamed(context, DishPage.routeName,
                        arguments: pa);
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.green),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        editCatController.text = category.categoryName;
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Add/Edit Category",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 25),
                          children: [
                            Divider(),
                            TextFormField(
                              // initialValue: category.categoryName,
                              controller: editCatController,
                              // minLines: 6,
                              // maxLines: 6,
                              decoration: InputDecoration(
                                hintText: "Enter here",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Save",
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  if (editCatController.text.length < 2) {
                                  } else if (editCatController.text.length >
                                      1) {
                                    print("Editing the category");
                                    catProvider
                                        .editCategory(category.id, resId,
                                            editCatController.text)
                                        .then((re) {
                                      Navigator.of(context).pop();
                                      if (re['status'] == true) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'The Category Edited Successfully'),
                                          ),
                                        );
                                      } else {}
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.green),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "Delete Category!",
                              okFun: () {
                                catProvider
                                    .deleteCategoy(category.id)
                                    .then((res) {
                                  if (res['status']) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "The Category Deleted Successfully"),
                                    ));
                                    Navigator.of(context).pop();
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(res['message']),
                                    ));
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              cancelFun: () {},
                              descreption: "Are You Sure To Delete Category?",
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
