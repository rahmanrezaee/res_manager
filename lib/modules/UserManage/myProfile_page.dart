import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/widgets/orderItem_widget.dart';
//widgets
import 'package:admin/widgets/commentItem_widget.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool openForOrder = false;
  bool autoAcceptOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User Profile",
                    ),
                    // SizedBox(
                    //   width: 35,
                    //   height: 35,
                    //   child: RaisedButton(
                    //     padding: EdgeInsets.all(0),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     elevation: 0,
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, ResturantForm.routeName);
                    //     },
                    //     color: Colors.white,
                    //     child: Icon(Icons.add,
                    //         color: Theme.of(context).primaryColor),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("User Profile",
                      style: Theme.of(context).textTheme.headline4),
                  // SizedBox(
                  //   width: 35,
                  //   height: 35,
                  //   child: RaisedButton(
                  //     padding: EdgeInsets.all(0),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     elevation: 0,
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, ResturantForm.routeName);
                  //     },
                  //     color: Colors.white,
                  //     child: Icon(Icons.add,
                  //         color: Theme.of(context).primaryColor),
                  //   ),
                  // ),
                ],
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(children: [
              CircleAvatar(
                radius: 40.0,
                child: ClipRRect(
                  child: Image.network('https://i.pravatar.cc/300'),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rahman Rezaiee",
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 5),
                  Text("johndoe2021@gmail.com",
                      style: TextStyle(color: Colors.black45)),
                  Text("Total Order Placed",
                      style: TextStyle(color: Colors.black45)),
                ],
              ),
              SizedBox(width: 10),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Open for Orders",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: openForOrder,
                  onChanged: (value) {
                    setState(() {
                      openForOrder = value;
                    });
                  },
                  // trackColor: AppColors.green,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Auto Accept Order",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: autoAcceptOrder,
                  onChanged: (value) {
                    setState(() {
                      autoAcceptOrder = value;
                    });
                  },
                  // trackColor: AppColors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
