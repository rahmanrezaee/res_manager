import 'dart:ui';

import 'package:flutter/material.dart';

class TextFormFieldResturant extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  Function onChange;
  Function onTap;
  Function onSave;
  Function valide;
  String initValue;
  bool enable;
  IconData icon;
  TextInputType typetext;
  TextFormFieldResturant(
      {this.hintText,
      this.controller,
      this.onChange,
      this.onSave,
      this.initValue,
      this.onTap,
      this.typetext = TextInputType.text,
      this.enable = false,
      this.valide,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: this.typetext,
        controller: controller,
        onChanged: this.onChange,
        onSaved: this.onSave,
        initialValue: this.initValue,
        readOnly: enable,
        onTap: onTap,
        validator: this.valide,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          hintText: hintText,
          errorStyle: TextStyle(color: Colors.red, height: 1),
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,

          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white, width: 32.0),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
        ),
      ),
    );
  }
}
