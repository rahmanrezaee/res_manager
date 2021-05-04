import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/modules/report/Services/ReportServices.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/modules/report/widget/TextfieldResturant.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/themes/colors.dart';
import 'package:provider/provider.dart';
import '../../widgets/orderItem_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ResturantProvider snapshot;
  Future getResturantList;
  List<Map> listRest = [
    {"display": "All Resturant", "value": "none"}
  ];
  AuthProvider auth;
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    snapshot = Provider.of<ResturantProvider>(context, listen: false);

    getResturantList = snapshot.getResturantList().then((value) {
      listRest.addAll(snapshot.listResturant.map((e) {
        return {"display": "${e.resturantName}", "value": "${e.id}"};
      }).toList());
      setState(() {
        orderResturantId = listRest[0]['value'];
        earingResturantId = listRest[0]['value'];
      });
    });
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  String orderResturantId;
  String earingResturantId;
  String startDateEarn;
  String endDateEarn;
  String startDateOrder;
  String endDateOrder;
  String income = "";
  String earning = "";
  bool enabletoOrdersReport = false;
  bool enabletoEarningReport = false;
  var couponController = TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: adaptiveAppBarBuilder(
          context,
          AppBar(
            title: Text("Reports"),
            centerTitle: true,
            actions: [NotificationAppBarWidget()],
            elevation: 2,
            leading: showAppBarNodepad(context)
                ? IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  )
                : null,
            bottom: isLoading
                ? PreferredSize(
                    preferredSize: Size(10, 10),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
        ),
        body: FutureBuilder(
            future: getResturantList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error In Fetch Data"),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ResponsiveGridRow(children: [
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              sm: 12,
                              xl: 12,
                              xs: 12,
                              child: Card(
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Orders",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      DropDownFormField(
                                        hintText: "Select Restaurant",
                                        value: orderResturantId,
                                        onSaved: (value) {},
                                        onChanged: (value) {
                                          setState(() {
                                            orderResturantId = value;
                                          });
                                        },
                                        dataSource: listRest,
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormFieldResturant(
                                        hintText: "By Coupon",
                                        controller: couponController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        startDateOrder ??
                                                            "From Date",
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        _selectDate(context)
                                                            .then((value) =>
                                                                setState(() {
                                                                  startDateOrder =
                                                                      value;
                                                                }));
                                                      },
                                                      icon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        endDateOrder ??
                                                            "To Date",
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        _selectDate(context)
                                                            .then((value) =>
                                                                setState(() {
                                                                  endDateOrder =
                                                                      value;
                                                                }));
                                                      }, // Refer step 3
                                                      icon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: earning != "",
                                        child: ListTile(
                                          title: Text("Total Orders"),
                                          trailing: Text("$earning"),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: ButtonRaiseResturant(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              label: Text(
                                                "Email Report",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onPress: !enabletoOrdersReport
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      getSendReportEmil(
                                                        fromDate:
                                                            startDateOrder,
                                                        toDate: endDateOrder,
                                                        auth: auth,
                                                        restaurantId: this
                                                            .orderResturantId,
                                                        totalUser: earning,
                                                        coupenCode:
                                                            couponController
                                                                .text,
                                                      ).then((value) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent,
                                                          content: Text(
                                                              "Successfuly Send To Email."),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ));
                                                      });
                                                    },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: ButtonRaiseResturant(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              label: Text(
                                                "View Report",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onPress: () {
                                                setState(() {
                                                  isLoading = true;
                                                  earning = "";
                                                });
                                                getReport(
                                                        type: "orders",
                                                        fromDate:
                                                            startDateOrder,
                                                        toDate: endDateOrder,
                                                        restaurantId: this
                                                            .orderResturantId,
                                                        coupenCode:
                                                            couponController
                                                                .text,
                                                        auth: auth)
                                                    .then((value) {
                                                  setState(() {
                                                    earning = "${value}";
                                                    enabletoOrdersReport = true;
                                                    isLoading = false;
                                                  });
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              lg: 6,
                              md: 12,
                              sm: 12,
                              xl: 12,
                              xs: 12,
                              child: Card(
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Earnings",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      DropDownFormField(
                                        hintText: "Select Restaurant",
                                        value: earingResturantId,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Please select an Restaurant";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {},
                                        onChanged: (value) {
                                          setState(() {
                                            earingResturantId = value;
                                          });
                                        },
                                        dataSource: listRest,
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        startDateEarn ??
                                                            "From Date",
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        _selectDate(context)
                                                            .then((value) {
                                                          setState(() {
                                                            print(
                                                                "date $value");
                                                            startDateEarn =
                                                                value;
                                                          });
                                                        });
                                                      }, // Refer step 3
                                                      icon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        endDateEarn ??
                                                            "To Date",
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        _selectDate(context)
                                                            .then((value) {
                                                          setState(() {
                                                            print(
                                                                "date $value");
                                                            endDateEarn = value;
                                                          });
                                                        });
                                                      }, // Refer step 3
                                                      icon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: income != "",
                                        child: ListTile(
                                          title: Text("Total Earning"),
                                          trailing: Text("$income"),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: ButtonRaiseResturant(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              label: Text(
                                                "Email Report",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onPress: !enabletoEarningReport
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      getSendReportEmailEarnings(
                                                              fromDate:
                                                                  startDateEarn,
                                                              toDate:
                                                                  endDateEarn,
                                                              resturant:
                                                                  earingResturantId,
                                                              earning: income,
                                                              auth: auth)
                                                          .then((value) {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent,
                                                          content: Text(
                                                              "Successfuly Send To Email."),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ));
                                                      });
                                                    },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: ButtonRaiseResturant(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              label: Text(
                                                "View Report",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onPress: () {
                                                setState(() {
                                                  isLoading = true;

                                                  income = "";
                                                });

                                                print("hello world");
                                                getReport(
                                                        type: "earnings",
                                                        fromDate: startDateEarn,
                                                        toDate: endDateEarn,
                                                        restaurantId:
                                                            earingResturantId,
                                                        auth: auth)
                                                    .then((value) {
                                                  setState(() {
                                                    income = "${value}";
                                                    enabletoEarningReport =
                                                        true;
                                                    isLoading = false;
                                                  });
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  );
                }
              }
            }));
  }

  Future<String> _selectDate(BuildContext context) async {
    final dateResult = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(primary: const Color(0xFF000000)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (dateResult != null)
      return "${dateResult.year}-${dateResult.month}-${dateResult.day}";
  }
}
