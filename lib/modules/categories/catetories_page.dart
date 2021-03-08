import 'package:admin/modules/categories/provider/categories_provider.dart';
import 'package:admin/widgets/DropDownFormField.dart';
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
  TextEditingController newCategoryController = new TextEditingController();

  String error;

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
                child: Text("Manage Categories"),
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
      // appBar: AppBar(
      //   elevation: .2,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   title: Text("Manage Categories"),
      // ),
      body: SingleChildScrollView(
        child:
            Consumer<CategoryProvider>(builder: (context, catProvider, child) {
          catProvider.fetchCustomers();
          return Column(
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
                                        child: Text(
                                          "Save",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
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
                                            catProvider
                                                .addNewCategory(
                                              "603f313fd0c6141040de8c89",
                                              newCategoryController.text,
                                            )
                                                .then((value) {
                                              if (value['satus'] == true) {
                                                Navigator.of(context).pop();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      'Something went wrong!'),
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                ));
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
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
              catProvider.getCategories == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ...List.generate(
                          catProvider.getCategories.length,
                          (index) {
                            return _categoryItemBuilder(
                              context,
                              catProvider.getCategories[index],
                            );
                          },
                        )
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }
}

_categoryItemBuilder(context, CategoryModel category) {
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
                onPressed: () {},
              ),
              SizedBox(width: 5),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text("Add/Edit Category",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                        children: [
                          Divider(),
                          TextField(
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
                                Navigator.of(context).pop();
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
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
