import 'package:flutter/material.dart';

class ButtonRaiseResturant extends StatelessWidget {
  Function()? onPress;
  Widget? label;
  Color ?color;

  ButtonRaiseResturant({this.color, this.label, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: this.color,
      child: label,
      onPressed: this.onPress,
    );
  }
}
