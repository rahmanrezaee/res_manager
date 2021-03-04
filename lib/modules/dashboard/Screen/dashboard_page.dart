import 'package:admin/modules/dashboard/widget/label.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/modules/addNewDish/addNewDish_page.dart';
import 'package:admin/themes/colors.dart';
//widgets
import '../../../themes/style.dart';
import '../../../widgets/appbar_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool openForOrder = true;
  bool autoAcceptOrder = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: adaptiveAppBarBuilder(
            context,
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: getHelfIpadAndFullMobWidth(context),
                  height: 50,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "15 Active Orders",
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: getQurIpadAndFullMobWidth(context),
                  child: LabelDashBoard(
                    color: Colors.white,
                    title: "Total earning Today: \$XX.XX",
                  ),
                ),
                Container(
                  width: getQurIpadAndFullMobWidth(context),
                  child: LabelDashBoard(
                    color: Colors.white,
                    title: "Total Resturant : \$XX",
                  ),
                ),
                Container(
                  width: getQurIpadAndFullMobWidth(context),
                  child: LabelDashBoard(
                    color: Colors.white,
                    title: "Total Customer : \$XX",
                  ),
                ),
              ],
            ),
          )),
      routes: {
        // AddNewDish.routeName: (context) => AddNewDish(),
      },
      theme: restaurantTheme,
    );
  }
}
