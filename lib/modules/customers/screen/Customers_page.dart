import './customerProfile.dart';
import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:admin/themes/colors.dart';
import 'package:admin/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//models
import '../models/customer_model.dart';

class CustomersPage extends StatelessWidget {
  static String routeName = "CustomersPage";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CustomerProfile.routeName: (context) =>
            CustomerProfile(ModalRoute.of(context).settings.arguments),
      },
      theme: restaurantTheme,
      home: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Scaffold(
          appBar: AppBar(
            elevation: .2,
            automaticallyImplyLeading: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text("Manage Customers"),
          ),
          body: Consumer<CustomersProvider>(
              builder: (context, customersProvider, child) {
            customersProvider.fetchCustomers();
            if (customersProvider.getCustomers == null) {
              return Center(child: CircularProgressIndicator());
            } else if (customersProvider.getCustomers.length < 1) {
              return Center(
                child: Text(
                  "The customer list is empty",
                  style: TextStyle(color: Colors.black),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text("Customers",
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 14),
                  Expanded(
                    child: ListView.builder(
                      itemCount: customersProvider.getCustomers.length,
                      itemBuilder: (context, i) {
                        return _customerItemBuilder(
                          context,
                          customersProvider.getCustomers[i],
                          customersProvider,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

_customerItemBuilder(
    context, Customer customer, CustomersProvider customersProvider) {
  return InkWell(
    onTap: () {
      print("this is the customer: ${customer.id}");
      Navigator.of(context)
          .pushNamed(CustomerProfile.routeName, arguments: customer.id);
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              customer.username,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("${customer.activeOrders} Active Orders",
                style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.room_service, color: AppColors.green),
                  onPressed: () {},
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.green),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Add/Edit Category",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 25),
                          children: [
                            Divider(),
                            TextField(
                              // minLines: 6,
                              // maxLines: 6,
                              decoration: InputDecoration(
                                hintText: "Enter here",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Save",
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.green),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                Text("Are you sure to delete this customer!?"),
                            actions: [
                              RaisedButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: AppColors.redText),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(new SnackBar(
                                    content: Text("Deleting customer..."),
                                  ));
                                  customersProvider
                                      .deleteCustomer(customer.id)
                                      .then((res) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    if (res['status'] == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(new SnackBar(
                                        content: Text(
                                            "The user deleted Successfuly."),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(new SnackBar(
                                        content: Text(
                                          "Something went wrong while deleting customer.",
                                          style: TextStyle(
                                              color: AppColors.redText),
                                        ),
                                      ));
                                    }
                                  });
                                },
                              ),
                              RaisedButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
