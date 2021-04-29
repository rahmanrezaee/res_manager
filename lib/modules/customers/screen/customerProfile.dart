import 'dart:async';
import 'dart:developer';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/customers/models/customer_model.dart';
import 'package:admin/modules/customers/models/order_model.dart';
import 'package:admin/modules/customers/models/review_model.dart';
import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/modules/orders/Models/OrderModels.dart';
import 'package:admin/modules/orders/Services/OrderSerives.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/widgets/orderItem_widget.dart';
//widgets
import 'package:admin/widgets/commentItem_widget.dart';

class CustomerProfile extends StatefulWidget {
  static String routeName = 'CustomerProfile';
  final String id;
  CustomerProfile(this.id);
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  Future getData;

  AuthProvider auth;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    getData = Provider.of<CustomersProvider>(context, listen: false)
        .fetchCustomer(widget.id);
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked_s != null) return "${picked_s.hour}:${picked_s.minute}";
  }

  @override
  Widget build(BuildContext context) {
    print("cust");
    print(widget.id);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: .2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Customer Name"),
          centerTitle: true,
          actions: [NotificationAppBarWidget()],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Customer getCustomer = snapshot.data['customer'];
                  List<OrderModels> getOrders = snapshot.data['ordersCustomer'];
                  List<ReviewModel> getReview =
                      snapshot.data['reviewsCustomer'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 40.0,
                            child: ClipRRect(
                              child: FadeInImage.assetNetwork(
                                  placeholder: "",
                                  image: "${getCustomer.avatar}"),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getCustomer.username ?? "",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(height: 5),
                                Text(getCustomer.email ?? "",
                                    style: TextStyle(color: Colors.black45)),
                                SizedBox(height: 5),
                                Text("Total Orders : ${getOrders.length}",
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        SizedBox(
                          width: getHelfIpadAndFullMobWidth(context),
                          height: 50,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            color: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Orders",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        getOrders.length == 0
                            ? Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text("No Order"),
                                  ),
                                ),
                              )
                            : ResponsiveGridRow(
                                children: [
                                  ...List.generate(getOrders.length, (i) {
                                    return ResponsiveGridCol(
                                        xs: 12,
                                        sm: 12,
                                        md: 12,
                                        lg: 12,
                                        xl: 6,
                                        child: getItem(getOrders[i],
                                            getCustomer.username));
                                  }),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Reviews Shared",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        getReview.length == 0
                            ? Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text("No Review"),
                                  ),
                                ),
                              )
                            : ResponsiveGridRow(
                                children: [
                                  ...List.generate(getReview.length, (i) {
                                    return ResponsiveGridCol(
                                      xs: 12,
                                      sm: 12,
                                      md: 12,
                                      lg: 6,
                                      xl: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CommentItem(
                                            getReview[i],
                                            getCustomer.username,
                                            getCustomer.avatar),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  Widget getItem(OrderModels item, String name) {
    log("status ${item.status}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.accentLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer Name: ${name}",
              style: TextStyle(color: AppColors.redText),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${item.cardName} ",
                  style: TextStyle(color: AppColors.redText),
                ),
                Text(
                  "${Jiffy(item.date).format(" h:mm a, MMMM do yyyy")}",
                  style: TextStyle(color: AppColors.redText),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text("Items:", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      itemCount: item.items.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return DishItem(
                          model: item.items[index],
                        );
                      }),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Paid By: ${item.cardName}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.green,
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: item.status == "active",
                      child: Row(children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            color: AppColors.green,
                            child: Icon(Icons.check, color: Colors.white),
                            onPressed: () {
                              OrderServices()
                                  .pickup(item.id, "accepted", auth)
                                  .then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerProfile(widget.id),
                                    ));
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Succecfully Done"),
                                  duration: Duration(seconds: 4),
                                ));
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
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
                              OrderServices()
                                  .pickup(item.id, "rejected", auth)
                                  .then((value) {
                                Timer(Duration(seconds: 3), () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerProfile(widget.id),
                                      ));
                                });
                              });
                            },
                            color: AppColors.redText,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                    Visibility(
                      visible: item.status == "accepted",
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pick Up at: ${item.timePicker ?? "00:00"} ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColors.green,
                              ),
                            ),
                            SizedBox(width: 15),
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: RaisedButton(
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                color: AppColors.green,
                                child: Icon(Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  item.timePicker = await _selectTime(context);

                                  OrderServices()
                                      .updatepickupDate(
                                          item.id, item.timePicker, auth)
                                      .then((value) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Succecfully Done"),
                                      duration: Duration(seconds: 2),
                                    ));
                                  });
                                },
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Visibility(
                      visible: item.status == "accepted",
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        elevation: 0,
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        child: Text("Mark Picked Up",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          OrderServices()
                              .pickup(item.id, "pickedUp", auth)
                              .then((value) {
                            // getOrderData();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Succecfully Done"),
                              duration: Duration(seconds: 4),
                            ));
                            Timer(Duration(seconds: 3), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerProfile(widget.id),
                                  ));
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: item.status == "pickedUp" || item.status == "rejected",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Status :",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14)),
                    Text("${item.status}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
