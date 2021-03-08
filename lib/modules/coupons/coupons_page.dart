import 'package:admin/modules/coupons/Widgets/form_coupon.dart';
import 'package:admin/modules/coupons/model/CouponModel.dart';
import 'package:admin/modules/coupons/statement/couponProvider.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants/assest_path.dart';
import 'package:admin/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CouponsPage extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                  title: Text("Manage Coupons"),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  )),
            )
          : AppBar(
              title: Text("Manage Coupons"),
              elevation: 0,
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
                  Text("Coupen", style: Theme.of(context).textTheme.headline4),
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
                              child: FormCoupen(
                                  formKey: _formKey, scoffeldKey: _scaffoldKey),
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
          Expanded(
            child: Consumer<CoupenProvider>(
              builder: (BuildContext context, value, Widget child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    value.getCoupenList();
                    return true;
                  },
                  child: value.list != null
                      ? value.list.isEmpty
                          ? Text("No Coupen")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: value.list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _couponsItemBuilder(
                                    context, value.list[index]);
                                ;
                              },
                            )
                      : FutureBuilder(
                          future: value.getCoupenList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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

_couponsItemBuilder(context, CouponModel coupen) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${coupen.name}", style: Theme.of(context).textTheme.headline4),
          Text("${coupen.code}", style: TextStyle(color: Colors.grey)),
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
