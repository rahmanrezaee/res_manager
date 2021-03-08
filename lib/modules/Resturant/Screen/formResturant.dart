import 'dart:async';

import 'package:admin/Services/UploadFile.dart';
import 'package:admin/constants/UrlConstants.dart';
import 'package:admin/modules/Resturant/Models/Resturant.dart';
import 'package:admin/modules/Resturant/Models/location.dart';
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

class ResturantForm extends StatefulWidget {
  String resId;
  ResturantForm({this.resId});
  static final routeName = "resturantform";
  @override
  _ResturantFormState createState() => _ResturantFormState();
}

class _ResturantFormState extends State<ResturantForm> {
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

  bool _loadUpdate = true;

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
              widget.resId != null ? "Update Resturants" : "Add Resturants"),
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
                          width: 130,
                          child: ClipRRect(
                            child: GestureDetector(
                              onTap: () {
                                openImagePickerModal(context)
                                    .then((value) async {
                                  if (value != null) {
                                    setState(() {
                                      _isUploadingImage = true;
                                    });
                                    await uploadFile(
                                            value, "profile-photo", token)
                                        .then((value) => resturantModel.avatar =
                                            value['uriPath']);

                                    setState(() {
                                      _isUploadingImage = false;
                                    });
                                  }
                                });
                              },
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
                                child: _isUploadingImage
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator())
                                    : resturantModel.avatar != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(70.0),
                                            child: Image.network(
                                                resturantModel.avatar))
                                        : Icon(Icons.add_a_photo),
                              ),
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
                                      hintText: "Resturant Name",
                                      onChange: (value) {
                                        setState(() {
                                          resturantModel.resturantName = value;
                                        });
                                      },
                                      valide: (String value) {
                                        if (value.isEmpty) {
                                          return "Your Resturant Name is Empty";
                                        }
                                      },
                                      onSave: (value) {
                                        setState(() {
                                          resturantModel.resturantName = value;

                                          print(
                                              "re ${resturantModel.resturantName}");
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormFieldResturant(
                                      icon: Icons.location_searching,
                                      hintText: "Resturant Location",

                                      onChange: (value) {},
                                      onTap: () {
                                        print("hel");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlacePicker(
                                              apiKey:
                                                  "AIzaSyBY1nLDcGY1NNgV89rnDR8jg_eBsQBJ39E", // Put YOUR OWN KEY here.
                                              onPlacePicked: (result) {
                                                LocationModel locationMo =
                                                    new LocationModel();
                                                locationMo.lat = result
                                                    .geometry.location.lat;
                                                locationMo.log = result
                                                    .geometry.location.lng;
                                                locationMo.type = "Point";

                                                setState(() {
                                                  locationPickerController
                                                          .text =
                                                      "(${resturantModel.location.lat.toStringAsFixed(2)}, ${resturantModel.location.log.toStringAsFixed(2)})";
                                                });

                                                resturantModel.location =
                                                    locationMo;
                                                Navigator.of(context).pop();
                                              },
                                              initialPosition: LatLng(34, 65),

                                              useCurrentLocation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      controller: locationPickerController,
                                      // enable: false,
                                      valide: (String value) {
                                        if (value.isEmpty) {
                                          return "Your Resturant Name is Empty";
                                        }
                                      },
                                      onSave: (value) {
                                        setState(() {
                                          // resturantModel.location = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ]),
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
                      ResponsiveGridRow(
                        children: [
                          ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            sm: 12,
                            xl: 12,
                            xs: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormFieldResturant(
                                initValue: resturantModel.email,
                                hintText: "User Email Address",
                                onChange: (value) {
                                  setState(() {
                                    resturantModel.email = value;
                                  });
                                },
                                valide: (String value) {
                                  if (value.isEmpty) {
                                    return "Your Resturant Name is Empty";
                                  }
                                  if (!isEmail(value)) {
                                    return "Your Email envalid";
                                  }
                                },
                                onSave: (value) {
                                  setState(() {
                                    resturantModel.email = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            sm: 12,
                            xl: 12,
                            xs: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormFieldResturant(
                                initValue: resturantModel.password,
                                hintText: "Password",
                                onChange: (value) {
                                  setState(() {
                                    resturantModel.password = value;
                                  });
                                },
                                valide: (String value) {
                                  if (widget.resId != null) {
                                    return null;
                                  }
                                  if (value.isEmpty) {
                                    return "Your Password is Empty";
                                  }
                                },
                                onSave: (value) {
                                  if (widget.resId != null) {
                                    if (value == null || value == "") {
                                      return null;
                                    } else {
                                      setState(() {
                                        resturantModel.password = value;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      resturantModel.password = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
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
                                      widget.resId != null ? "Update" : "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                              onPress: () {
                                addResturant();
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

  addResturant() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      var resturantProvider =
          Provider.of<ResturantProvider>(context, listen: false);

      print("resturantModel ${resturantModel.resturantName}");

      if (widget.resId != null) {
        resturantProvider
            .editResturant(resturantModel.sendMap(), widget.resId)
            .then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result == true) {
            print("Mahdi: Executed 2");
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly Updated."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          } else {
            print("Mahdi: Executed 3");

            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Something went wrong!! Please try again later."),
              duration: Duration(seconds: 4),
            ));
          }

          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        });
      } else {
        resturantProvider.addResturant(resturantModel.sendMap()).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result == true) {
            print("Mahdi: Executed 2");
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly added."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          } else {
            print("Mahdi: Executed 3");

            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Something went wrong!! Please try again later."),
              duration: Duration(seconds: 4),
            ));
          }

          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.sunday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.sunday.endTime == null ? '0:00' : resturantModel.sunday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.sunday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.monday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.monday.endTime == null ? '0:00' : resturantModel.monday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.monday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.tuesday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.tuesday.endTime == null ? '0:00' : resturantModel.tuesday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.tuesday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.wednesday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.wednesday.endTime == null ? '0:00' : resturantModel.wednesday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.wednesday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.thursday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.thursday.endTime == null ? '0:00' : resturantModel.thursday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.thursday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.friday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.friday.endTime == null ? '0:00' : resturantModel.friday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.friday.endTime = value;
                            }));
                      },
                    ),
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
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.saturday.startTime = value;
                            }));
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Text(
                        "${resturantModel.saturday.endTime == null ? '0:00' : resturantModel.saturday.endTime}"),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _selectTime(context).then((value) => setState(() {
                              resturantModel.saturday.endTime = value;
                            }));
                      },
                    ),
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
