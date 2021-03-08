import 'dart:async';

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
  var scoffeldKey;
  String coupenId;
  FormCoupen({this.formKey, this.scoffeldKey, this.coupenId});
  @override
  _FormCoupenState createState() => _FormCoupenState();
}

class _FormCoupenState extends State<FormCoupen> {
  CouponModel couponModel = new CouponModel();
  bool _autoValidate = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: _autoValidate,
      key: widget.formKey,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white30,
        ),
        child: SizedBox(
          child: SimpleDialog(
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
                },
                onSave: (value) {
                  setState(() {
                    couponModel.code = value;
                  });
                },
              ),
              SizedBox(height: 10),
              DropDownFormField(
                hintText: "Valid on Restaurants",
                value: couponModel.resturant,
                validator: (value) {
                  if (value == null) {
                    return "Please select an Restaurants";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    couponModel.resturant = value;
                  });
                },
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  setState(() {
                    couponModel.resturant = value;
                  });
                },
                dataSource: [
                  {"display": "Resturant 1", "value": "Resturant 1"},
                  {"display": "Resturant 3", "value": "Resturant 3"},
                  {"display": "Resturant 2", "value": "Resturant 2"},
                ],
                textField: 'display',
                valueField: 'value',
              ),
              DropDownFormField(
                hintText: "Coupon Type",
                value: couponModel.type,
                validator: (value) {
                  if (value == null) {
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
              SizedBox(height: 10),
              TextFormFieldResturant(
                typetext: TextInputType.number,
                initValue:
                    couponModel.mount != null ? "${couponModel.mount}" : null,
                hintText: "Coupon Mount",
                onChange: (String value) {
                  print("moun $value");
                  setState(() {
                    couponModel.mount = double.parse(value);
                  });
                },
                valide: (String value) {
                  if (value.isEmpty) {
                    return "Your Coupon  Mount is Empty";
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
    );
  }

  saveDetail() {
    if (widget.formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      var coupenProvider = Provider.of<CoupenProvider>(context, listen: false);

      if (widget.coupenId != null) {
        // coupenProvider
        //     .editResturant(resturantModel.sendMap(), widget.resId)
        //     .then((result) {
        //   setState(() {
        //     _isLoading = false;
        //   });

        //   if (result == true) {
        //     print("Mahdi: Executed 2");
        //     _scaffoldKey.currentState.showSnackBar(SnackBar(
        //       content: Text("Successfuly Updated."),
        //       duration: Duration(seconds: 3),
        //     ));
        //     Timer(Duration(seconds: 3), () {
        //       Navigator.of(context).pop();
        //     });
        //   } else {
        //     print("Mahdi: Executed 3");

        //     _scaffoldKey.currentState.showSnackBar(SnackBar(
        //       content: Text("Something went wrong!! Please try again later."),
        //       duration: Duration(seconds: 4),
        //     ));
        //   }

        //   print("Mahdi: Executed 4");
        // }).catchError((error) {
        //   print("Mahdi Error: $error");
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   _scaffoldKey.currentState.showSnackBar(SnackBar(
        //     content: Text("Something went wrong!! Please try again later."),
        //     duration: Duration(seconds: 4),
        //   ));
        // });
      } else {
        coupenProvider.addCoupen(couponModel.sendMap()).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result == true) {
            print("Mahdi: Executed 2");
            widget.scoffeldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly added."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          } else {
            print("Mahdi: Executed 3");

            widget.scoffeldKey.currentState.showSnackBar(SnackBar(
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
          widget.scoffeldKey.currentState.showSnackBar(SnackBar(
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
