import 'package:flutter/material.dart';

class TextFormFieldResturant extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  Function onChange;
  Function onTap;
  Function onSave;
  Function valide;
  bool enable;
  IconData icon;
  TextInputType typetext;
  TextFormFieldResturant(
      {this.hintText,
      this.controller,
      this.onChange,
      this.onSave,
      this.onTap,
      this.typetext = TextInputType.text,
      this.enable = false,
      this.valide,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.typetext,
      controller: controller,
      onChanged: this.onChange,
      onSaved: this.onSave,
      readOnly: enable,
      onTap: onTap,
      validator: this.valide,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Icon(this.icon),
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
}
