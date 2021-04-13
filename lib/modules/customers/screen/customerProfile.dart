import 'package:admin/modules/customers/models/customer_model.dart';
import 'package:admin/modules/customers/models/order_model.dart';
import 'package:admin/modules/customers/models/review_model.dart';
import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:admin/modules/customers/widget/orderItem_widget.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/widgets/orderItem_widget.dart';
//widgets
import 'package:admin/widgets/commentItem_widget.dart';

class CustomerProfile extends StatefulWidget {
  static String routeName = 'CustomerProfile';
  final String id;
  CustomerProfile(this.id);
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  Future getData;
  @override
  void initState() {
    getData = Provider.of<CustomersProvider>(context, listen: false)
        .fetchCustomer(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    print("cust");
    print(widget.id);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: .2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Customer Name"),
          centerTitle: true,
          actions: [NotificationAppBarWidget()],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Customer getCustomer = snapshot.data['customer'];
                  List<OrderModel> getOrders = snapshot.data['ordersCustomer'];
                  List<ReviewModel> getReview =
                      snapshot.data['reviewsCustomer'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 40.0,
                            child: ClipRRect(
                              child: FadeInImage.assetNetwork(
                                  placeholder: "",
                                  image: "${getCustomer.avatar}"),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getCustomer.username ?? "",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                SizedBox(height: 5),
                                Text(getCustomer.email ?? "",
                                    style: TextStyle(color: Colors.black45)),
                                SizedBox(height: 5),
                                Text("Total Orders :${getOrders.length}",
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
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
                              "Orders",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        getOrders.length == 0
                            ? Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text("No Order"),
                                  ),
                                ),
                              )
                            : ResponsiveGridRow(
                                children: [
                                  ...List.generate(getOrders.length, (i) {
                                    return ResponsiveGridCol(
                                      xs: 12,
                                      sm: 12,
                                      md: 12,
                                      lg: 12,
                                      xl: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: OrderCardItem(
                                            getOrders[i], 'customeProfile'),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Reviews Shared",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        getReview.length == 0
                            ? Card(
                                child: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text("No Review"),
                                  ),
                                ),
                              )
                            : ResponsiveGridRow(
                                children: [
                                  ...List.generate(getReview.length, (i) {
                                    return ResponsiveGridCol(
                                      xs: 12,
                                      sm: 12,
                                      md: 12,
                                      lg: 6,
                                      xl: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CommentItem(getReview[i]),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
