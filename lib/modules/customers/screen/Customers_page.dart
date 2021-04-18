import 'dart:developer';

import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/modules/orders/orders_page_notification.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/services.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';

import './customerProfile.dart';
import 'package:admin/modules/customers/provider/customers_provider.dart';
import 'package:admin/themes/colors.dart';
import 'package:admin/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//models
import '../models/customer_model.dart';

import 'dart:core';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class CustomersPage extends StatefulWidget {
  static String routeName = "CustomersPage";

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
  }

  CustomersProvider customersProvider;

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CustomerProfile.routeName: (context) =>
            CustomerProfile(ModalRoute.of(context).settings.arguments),
        OrdersPageNotification.routeName: (context) => OrdersPageNotification(),
        NotificationPage.routeName: (context) => NotificationPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: restaurantTheme,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Manage Customers"),
          centerTitle: true,
          leading: showAppBarNodepad(context)
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : null,
          actions: [NotificationAppBarWidget()],
          bottom: isLoading
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customers",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Expanded(child: Consumer<CustomersProvider>(
                builder: (BuildContext context, value, Widget child) {
              return RefreshIndicator(
                onRefresh: () {
                  return value.fetchCustomers(pageInit: 1);
                },
                child: value.getCustomers == null
                    ? FutureBuilder(
                        future: value.fetchCustomers(pageInit: 1),
                        builder: (context, snapshot) {
                          return Center(child: CircularProgressIndicator());
                        })
                    : IncrementallyLoadingListView(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        hasMore: () => value.hasMoreItems,
                        itemCount: () => value.getCustomers.length,
                        loadMore: () async {
                          await value.fetchCustomers();
                        },
                        onLoadMore: () {
                          value.showLoadingBottom(true);
                        },
                        onLoadMoreFinished: () {
                          value.showLoadingBottom(false);
                        },
                        loadMoreOffsetFromBottom: 0,
                        itemBuilder: (context, index) {
                          if ((value.loadingMore ?? false) &&
                              index == value.getCustomers.length - 1) {
                            log(value.getCustomers[index].username);
                            return Column(
                              children: <Widget>[
                                _customerItemBuilder(
                                  context,
                                  value.getCustomers[index],
                                  customersProvider,
                                ),
                                PlaceholderItemCard()
                              ],
                            );
                          }
                          return _customerItemBuilder(
                            context,
                            value.getCustomers[index],
                            customersProvider,
                          );
                        },
                      ),
              );
            })),
          ],
        ),
      ),
    );
  }

  _customerItemBuilder(
      context, Customer customer, CustomersProvider customersProvider) {
    return InkWell(
      onTap: () {
        print("this is the customer: ${customer.username}");
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
              Container(
                width: getDeviceWidthSize(context)/2,
                child: Text(
                  "${customer.username}",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text("${customer.activeOrders} Active Orders",
                  style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  SizedBox(width: 5),
                  IconButton(
                    icon: Image.asset("assets/images/delete.png"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => FancyDialog(
                                title: "Delete Customer!",
                                okFun: () {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  print("customer ${customer.id}");
                                  Provider.of<CustomersProvider>(context,
                                          listen: false)
                                      .deleteCustomer(customer.id)
                                      .then((res) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // ScaffoldMessenger.of(context)
                                    //     .hideCurrentSnackBar();
                                    if (res == true) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(new SnackBar(
                                      //   content: Text(
                                      //       "The user deleted Successfuly."),
                                      // ));
                                    } else {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(new SnackBar(
                                      //   content: Text(
                                      //     "Something went wrong while deleting customer.",
                                      //     style: TextStyle(
                                      //         color: AppColors.redText),
                                      //   ),
                                      // ));
                                    }
                                  });
                                },
                                cancelFun: () {},
                                descreption: "Are You Sure To Delete Customer?",
                              ));
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
}
