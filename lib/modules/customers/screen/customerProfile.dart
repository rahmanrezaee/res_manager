import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:admin/modules/customers/widget/orderItem_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CustomersProvider>(
          builder: (context, customerProvider, child) {
        customerProvider.fetchCustomer(widget.id);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customerProvider.getCustomer == null
                  ? Center(child: CircularProgressIndicator())
                  : Row(children: [
                      CircleAvatar(
                        radius: 40.0,
                        child: ClipRRect(
                          child: Image.network(
                              customerProvider.getCustomer.avatar['uriPath']),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customerProvider.getCustomer.username,
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 5),
                          Text(customerProvider.getCustomer.email,
                              style: TextStyle(color: Colors.black45)),
                          Text("${customerProvider.getCustomer.totalOrder}",
                              style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                    ]),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
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
              customerProvider.getOrders == null
                  ? CircularProgressIndicator()
                  : ResponsiveGridRow(
                      children: [
                        ...List.generate(customerProvider.getOrders.length,
                            (i) {
                          return ResponsiveGridCol(
                            xs: 12,
                            sm: 12,
                            md: 12,
                            lg: 12,
                            xl: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OrderCardItem(
                                  customerProvider.getOrders[i],
                                  'customeProfile'),
                            ),
                          );
                        }),
                      ],
                    ),
              Text(
                "Reviews Shared",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 20),
              ),
              customerProvider.getReview == null
                  ? Center(child: CircularProgressIndicator())
                  : ResponsiveGridRow(
                      children: [
                        ...List.generate(customerProvider.getReview.length,
                            (i) {
                          return ResponsiveGridCol(
                            xs: 12,
                            sm: 12,
                            md: 12,
                            lg: 6,
                            xl: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CommentItem(customerProvider.getReview[i]),
                            ),
                          );
                        }),
                      ],
                    ),
            ],
          ),
        );
      }),
    );
  }
}
