import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants/assest_path.dart';
import 'package:admin/themes/colors.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CouponsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .2,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Manage Coupons"),
      ),
      // appBar: AppBar(
      //   elevation: .2,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   title: Text("Manage Categories"),
      // ),
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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                  ),
                                  child: SizedBox(
                                    // width: 400,
                                    // height: 250,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //       color: Colors.black45,
                                    //       blurRadius: 4,
                                    //     ),
                                    //   ],
                                    // ),
                                    child: SimpleDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text("Add/Edite Coupon",
                                          textAlign: TextAlign.center),
                                      contentPadding: EdgeInsets.all(35),
                                      children: [
                                        Divider(height: 1, color: Colors.grey),
                                        SizedBox(height: 5),
                                        _textFieldBuilder("Coupon Name"),
                                        SizedBox(height: 10),
                                        _textFieldBuilder("Coupon Code"),
                                        SizedBox(height: 10),
                                        _textFieldBuilder("Precentage or Flat"),
                                        SizedBox(height: 10),
                                        DropDownFormField(
                                          hintText: "Coupon Type",
                                          value: "Coupon 1",
                                          validator: (value) {
                                            if (value == null) {
                                              return "Please select an industry";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {},
                                          onChanged: (value) {},
                                          dataSource: [
                                            {
                                              "display": "Coupon 1",
                                              "value": "Coupon 1"
                                            },
                                            {
                                              "display": "Coupon 3",
                                              "value": "Coupon 3"
                                            },
                                            {
                                              "display": "Coupon 2",
                                              "value": "Coupon 2"
                                            },
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                        ),
                                        SizedBox(height: 10),
                                        DropDownFormField(
                                          hintText: "Valid on Restaurants",
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
                                            {
                                              "display": "Resturant 1",
                                              "value": "Resturant 1"
                                            },
                                            {
                                              "display": "Resturant 3",
                                              "value": "Resturant 3"
                                            },
                                            {
                                              "display": "Resturant 2",
                                              "value": "Resturant 2"
                                            },
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 300,
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            color:
                                                Theme.of(context).primaryColor,
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
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
            _couponsItemBuilder(context),
            _couponsItemBuilder(context),
            _couponsItemBuilder(context),
          ],
        ),
      ),
    );
  }
}

_textFieldBuilder(String hintText) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}

_couponsItemBuilder(context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Coupons 1", style: Theme.of(context).textTheme.headline4),
          Text("idofcoupon", style: TextStyle(color: Colors.grey)),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.green),
                onPressed: () {
                  print("Ali Azad");
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
