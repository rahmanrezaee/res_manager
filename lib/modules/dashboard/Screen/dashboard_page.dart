import 'package:admin/modules/dashboard/widget/label.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import 'package:admin/themes/colors.dart';
import 'package:provider/provider.dart';
//provider
import '../provider/dashboard_provider.dart';
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
              title: Text("Home Page"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          body: Consumer<DashboardProvider>(
              builder: (context, dashProvider, child) {
            dashProvider.fetchDashData();
            if (dashProvider.getDashData == null) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
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
                          "${dashProvider.getDashData['activeOrders']} Active Orders",
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: getQurIpadAndFullMobWidth(context),
                      child: LabelDashBoard(
                        color: Colors.white,
                        title: "Total earning Today: \$XX.XX",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: getQurIpadAndFullMobWidth(context),
                      child: LabelDashBoard(
                        color: Colors.white,
                        title:
                            "Total Resturant : ${dashProvider.getDashData['totalRestaurants']}",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: getQurIpadAndFullMobWidth(context),
                      child: LabelDashBoard(
                        color: Colors.white,
                        title:
                            "Total Customer : ${dashProvider.getDashData['totalCustomers']}",
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
      routes: {
        // AddNewDish.routeName: (context) => AddNewDish(),
      },
      theme: restaurantTheme,
    );
  }
}
