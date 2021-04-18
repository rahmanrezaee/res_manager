import 'dart:async';

import 'package:admin/Services/UploadFile.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Resturant/Models/Resturant.dart';
import 'package:admin/modules/Resturant/Models/location.dart';
import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/modules/Resturant/Screen/resturant_screen.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/modules/report/widget/TextfieldResturant.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:string_validator/string_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewRestaurant extends StatefulWidget {
  String resId;
  ViewRestaurant({this.resId});
  static final routeName = "ViewResturant";
  @override
  _ViewRestaurantState createState() => _ViewRestaurantState();
}

class _ViewRestaurantState extends State<ViewRestaurant> {
  bool openForOrder = false;
  bool autoAcceptOrder = true;
  bool _isUploadingImage = false;
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  TextEditingController locationPickerController = new TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  ResturantModel resturantModel = new ResturantModel();
  LocationModel locationMo = new LocationModel();
  bool _loadUpdate = true;

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF504d4d),
                accentColor: const Color(0xFF504d4d),
                colorScheme:
                    ColorScheme.light(primary: const Color(0xFF504d4d)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ));
        });

    if (picked_s != null) return "${picked_s.hour}:${picked_s.minute}";
  }

  @override
  void initState() {
    if (widget.resId != null) {
      setState(() {
        _loadUpdate = false;
      });
      print(widget.resId);
      getRestuantData(widget.resId);
    }
    super.initState();
  }

  void getRestuantData(id) {
    Provider.of<ResturantProvider>(context, listen: false)
        .getSingleResturant(id)
        .then((value) {
      setState(() {
        resturantModel = value;
        _loadUpdate = true;
        locationPickerController.text =
            "(${resturantModel.location.lat.toStringAsFixed(2)}, ${resturantModel.location.log.toStringAsFixed(2)})";
      });
      print("resturant : ${resturantModel.location.lat}");
    });
  }

  bool _isSubmit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "View Restaurant",
          ),
        ),
        body: _loadUpdate
            ? SingleChildScrollView(
                child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Container(
                          height: 130,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: 130,
                          child: ClipRRect(
                            child: new Container(
                              width: 70,
                              height: 70,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(70.0)),
                                border: new Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 4.0,
                                ),
                              ),
                              child: resturantModel.avatar != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(70.0),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: "assets/images/loader.gif",
                                        image: "${resturantModel.avatar}",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.no_photography),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormFieldResturant(
                                      initValue: resturantModel.resturantName,
                                      hintText: "Restaurant Name",
                                      enable: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormFieldResturant(
                                      icon: Icons.location_on_outlined,
                                      hintText: "Restaurant Location",
                                      enable: true,
                                      // enable: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ]),

                      _isSubmit == true && resturantModel.avatar == null ||
                              resturantModel.avatar == ""
                          ? Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please select Avatar",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Open for Orders",
                      //         style:
                      //             TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      //     CupertinoSwitch(
                      //       value: openForOrder,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           openForOrder = value;
                      //         });
                      //       },
                      //       // trackColor: AppColors.green,
                      //     ),
                      //   ],
                      // ),
                      // Divider(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Auto Accept Order",
                      //         style:
                      //             TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      //     CupertinoSwitch(
                      //       value: autoAcceptOrder,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           autoAcceptOrder = value;
                      //         });
                      //       },
                      //       // trackColor: AppColors.green,
                      //     ),
                      //   ],
                      // ),
                      Container(
                        height: 500,
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(child: _dataBody()),
                                ],
                              )),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlineButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Total Dishes: ${resturantModel.totalDishies}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: OutlineButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Total Orders: ${resturantModel.totalOrder}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: getQurIpadAndFullMobWidth(context),
                            child: ButtonRaiseResturant(
                              color: Theme.of(context).primaryColor,
                              label: _isLoading == true
                                  ? SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : Text(
                                      "Edit",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                              onPress: () {
                                Navigator.pushNamed(
                                    context, ResturantForm.routeName,
                                    arguments: resturantModel.id);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

// Let's create a DataTable and show the employee list in it.
  Widget _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
            DataTable(dataTextStyle: TextStyle(color: Colors.black), columns: [
          DataColumn(
              label: Text(
            'Timings',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
          DataColumn(
              label: Text(
            'Open',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
          DataColumn(
              label: Text(
            'Close',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )),
        ], rows: [
          DataRow(
            cells: [
              DataCell(Text("Sunday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.sunday.startTime == null ? '0:00' : resturantModel.sunday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.sunday.endTime == null ? '0:00' : resturantModel.sunday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Monday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.monday.startTime == null ? '0:00' : resturantModel.monday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.monday.endTime == null ? '0:00' : resturantModel.monday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Tuesday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.tuesday.startTime == null ? '0:00' : resturantModel.tuesday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.tuesday.endTime == null ? '0:00' : resturantModel.tuesday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Wednesday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.wednesday.startTime == null ? '0:00' : resturantModel.wednesday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.wednesday.endTime == null ? '0:00' : resturantModel.wednesday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Thursday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.thursday.startTime == null ? '0:00' : resturantModel.thursday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.thursday.endTime == null ? '0:00' : resturantModel.thursday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Friday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.friday.startTime == null ? '0:00' : resturantModel.friday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.friday.endTime == null ? '0:00' : resturantModel.friday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Saturday")),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.saturday.startTime == null ? '0:00' : resturantModel.saturday.startTime}"),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.saturday.endTime == null ? '0:00' : resturantModel.saturday.endTime}"),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
