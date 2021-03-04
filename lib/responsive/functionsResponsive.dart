import 'package:flutter/cupertino.dart';

double getDeviceHeightSize(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getDeviceWidthSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHelfIpadAndFullMobWidth(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 700) {
    return width / 2;
  }
  return width;
}


double getQurIpadAndFullMobWidth(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 700) {
    return width / 3;
  }
  return width;
}