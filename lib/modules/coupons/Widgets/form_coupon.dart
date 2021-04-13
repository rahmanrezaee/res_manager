import 'dart:async';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/modules/coupons/model/CouponModel.dart';
import 'package:admin/modules/coupons/statement/couponProvider.dart';
import 'package:admin/modules/report/widget/TextfieldResturant.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormCoupen extends StatefulWidget {
  var formKey;
  String coupenId;
  FormCoupen({this.formKey, this.coupenId});
  @override
  _FormCoupenState createState() => _FormCoupenState();
}

class _FormCoupenState extends State<FormCoupen> {
  CouponModel couponModel = new CouponModel();
  bool _autoValidate = false;
  bool _isLoading = false;
  bool isLoadResturant = false;
  bool _loadUpdate = false;
  List<Map<String, String>> resturnat = [];

  bool _submitted = false;
  var scoffeldKey = GlobalKey<ScaffoldState>();
  AuthProvider auth;
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    ResturantProvider(auth).getResturantListWithoutPro().then((value) {
      resturnat = value;
      setState(() {
        isLoadResturant = true;
      });
    });

    if (widget.coupenId != null) {
      setState(() {
        _loadUpdate = true;
      });
      Provider.of<CoupenProvider>(context, listen: false)
          .getSingleCoupen(widget.coupenId)
          .then((value) {
        setState(() {
          _loadUpdate = false;
          couponModel = value;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scoffeldKey,
      backgroundColor: Colors.transparent,
      body: Form(
        autovalidate: _autoValidate,
        key: widget.formKey,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white30,
          ),
          child: SizedBox(
            child: _loadUpdate
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SimpleDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text("Add/Edit Coupon", textAlign: TextAlign.center),
                    contentPadding: EdgeInsets.all(35),
                    children: [
                      TextFormFieldResturant(
                        initValue: couponModel.name,
                        hintText: "Coupon Name",
                        onChange: (value) {
                          setState(() {
                            couponModel.name = value;
                          });
                        },
                        valide: (String value) {
                          if (value.isEmpty) {
                            return "Your Coupon  Name is Empty";
                          }
                        },
                        onSave: (value) {
                          setState(() {
                            couponModel.name = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormFieldResturant(
                        initValue: couponModel.code,
                        hintText: "Coupon Code",
                        onChange: (value) {
                          setState(() {
                            couponModel.code = value;
                          });
                        },
                        valide: (String value) {
                          if (value.isEmpty) {
                            return "Your Coupon  Code is Empty";
                          }
                          if (value.length < 8 || value.length > 20) {
                            return "Code should be between 8 and 20 characters";
                          }
                        },
                        onSave: (value) {
                          setState(() {
                            couponModel.code = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      isLoadResturant
                          ? DropDownFormField(
                              hintText: "Valid on Restaurants",
                              value: couponModel.resturant,
                              validator: (value) {
                                print(value);
                                if (value == null && value == "") {
                                  return "Please select an Coupen Type";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  couponModel.resturant = value;
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                setState(() {
                                  couponModel.resturant = value;
                                });
                              },
                              dataSource: resturnat,
                              textField: 'display',
                              valueField: 'value',
                            )
                          : TextFormFieldResturant(
                              enable: false,
                              hintText: "Valid on Restaurants",
                            ),
                      _submitted == true && couponModel.resturant == "" ||
                              couponModel.resturant == "none"
                          ? Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please select Restaurants",
                                style: TextStyle(
                                  color: Color(0xffB00020),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      DropDownFormField(
                        hintText: "Coupon Type",
                        value: couponModel.type,
                        validator: (value) {
                          print(value);
                          if (value == null && value == "") {
                            return "Please select an Coupen Type";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            couponModel.type = value;
                          });
                        },
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          setState(() {
                            couponModel.type = value;
                          });
                        },
                        dataSource: [
                          {"display": "Flat", "value": "Flat"},
                          {"display": "Percentage", "value": "Percentage"},
                        ],
                        textField: 'display',
                        valueField: 'value',
                      ),
                      _submitted == true && couponModel.type == null ||
                              couponModel.type == "" ||
                              couponModel.type == "none"
                          ? Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please select type",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      TextFormFieldResturant(
                        typetext: TextInputType.number,
                        initValue: couponModel.mount != null
                            ? "${couponModel.mount}"
                            : null,
                        hintText: "Precentage or Flat",
                        onChange: (String value) {
                          print("moun $value");
                          setState(() {
                            couponModel.mount = double.parse(value);
                          });
                        },
                        valide: (String value) {
                          if (value.isEmpty) {
                            return "Your Coupon  Precentage or Flat is Empty";
                          }
                        },
                        onSave: (String value) {
                          setState(() {
                            couponModel.mount = double.parse(value);
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
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
                                  widget.coupenId != null ? "Update" : "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                          onPress: () {
                            saveDetail();
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  saveDetail() {
    setState(() {
      _submitted = true;
    });
    if (widget.formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      var coupenProvider = Provider.of<CoupenProvider>(context, listen: false);

      if (widget.coupenId != null) {
        coupenProvider
            .editCoupen(couponModel.sendMap(), widget.coupenId)
            .then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result['status'] == true) {
            print("Mahdi: Executed 2");
            scoffeldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly Updated."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
          } else {
            scoffeldKey.currentState.showSnackBar(SnackBar(
              content: Text("${result['massage']}"),
              duration: Duration(seconds: 1),
            ));
          }
          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          scoffeldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        });
      } else {
        coupenProvider.addCoupen(couponModel.sendMap()).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result['status'] == true) {
            print("Mahdi: Executed 2");
            scoffeldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly added."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
          } else {
            scoffeldKey.currentState.showSnackBar(SnackBar(
              content: Text("${result['massage']}"),
              duration: Duration(seconds: 1),
            ));
          }

          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          scoffeldKey.currentState.showSnackBar(SnackBar(
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
}
