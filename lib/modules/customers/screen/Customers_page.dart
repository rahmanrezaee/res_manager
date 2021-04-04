import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/services.dart';

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
  static const _pageSize = 19;

  final PagingController<int, Customer> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  CustomersProvider customersProvider;
  Future<void> _fetchPage(int pageKey) async {
    try {
      customersProvider =
          Provider.of<CustomersProvider>(context, listen: false);
      final newItems = await customersProvider.fetchCustomers(pageKey);
      print(
          "newItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems");
      print(newItems.length);
      print(_pageSize);
      print(
          "_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize");
      final isLastPage = newItems.length >= _pageSize;
      if (isLastPage) {
        print("Its last page");
        _pagingController.appendLastPage(newItems);
      } else {
        print("ITs not last page");
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      print(s);
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CustomerProfile.routeName: (context) =>
            CustomerProfile(ModalRoute.of(context).settings.arguments),
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
          actions: [
            IconButton(
              icon: Image.asset("assets/images/notification.png"),
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
            )
          ],
          bottom: isLoading
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Customer>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Customer>(
              itemBuilder: (context, item, index) => _customerItemBuilder(
                context,
                item,
                customersProvider,
              ),
            ),
          ),
        ),
        // body: Consumer<CustomersProvider>(
        //     builder: (context, customersProvider, child) {
        //   if (customersProvider.getCustomers == null) {
        //     customersProvider.fetchCustomers(0);
        //     return Center(child: CircularProgressIndicator());
        //   } else if (customersProvider.getCustomers.length < 1) {
        //     return Center(
        //       child: Text(
        //         "The customer list is empty",
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     );
        //   } else {
        //     try {
        //       return PaginationView(
        //         preloadedItems: customersProvider.getCustomers.map((e) {
        //           return _customerItemBuilder(
        //             context,
        //             e,
        //             customersProvider,
        //           );
        //         }).toList(),
        //         // preloadedItems: [
        //         //   Column(
        //         //       crossAxisAlignment: CrossAxisAlignment.start,
        //         //       children: [
        //         //         SizedBox(height: 10),
        //         //         Expanded(
        //         //           child: ListView.builder(
        //         //             itemCount: customersProvider.getCustomers.length,
        //         //             itemBuilder: (context, i) {
        //         //               return _customerItemBuilder(
        //         //                 context,
        //         //                 customersProvider.getCustomers[i],
        //         //                 customersProvider,
        //         //               );
        //         //             },
        //         //           ),
        //         //         ),
        //         //       ],
        //         //     ),
        //         //   ],
        //         itemBuilder: (BuildContext context, user, int index) {
        //           print("Index");
        //           print(index);
        //           if ((customersProvider.getCustomers.length - 1) >= index) {
        //             return _customerItemBuilder(
        //               context,
        //               customersProvider.getCustomers[index],
        //               customersProvider,
        //             );
        //           } else {
        //             return Container();
        //           }
        //         },
        //         paginationViewType: PaginationViewType.listView,
        //         pageFetch: customersProvider.fetchCustomers,
        //         pullToRefresh: true,
        //         onError: (dynamic error) => Center(
        //           child: Text('Some error occured'),
        //         ),
        //         onEmpty: Center(
        //           child: Text('Sorry! This is empty'),
        //         ),
        //         bottomLoader: Center(
        //           // optional
        //           child: CircularProgressIndicator(),
        //         ),
        //         initialLoader: Center(
        //           // optional
        //           child: CircularProgressIndicator(),
        //         ),
        //       );
        //       // return Column(
        //       //   crossAxisAlignment: CrossAxisAlignment.start,
        //       //   children: [
        //       //     SizedBox(height: 10),
        //       //     Expanded(
        //       //       child: ListView.builder(
        //       //         itemCount: customersProvider.getCustomers.length,
        //       //         itemBuilder: (context, i) {
        //       //           return _customerItemBuilder(
        //       //             context,
        //       //             customersProvider.getCustomers[i],
        //       //             customersProvider,
        //       //           );
        //       //         },
        //       //       ),
        //       //     ),
        //       //   ],
        //       // );
        //     } catch (e, s) {
        //       print(e);
        //       print(s);
        //     }
        //   }
        // }),
      ),
    );
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
                  // IconButton(
                  //   icon: Icon(Icons.room_service, color: AppColors.green),
                  //   onPressed: () {},
                  // ),
                  SizedBox(width: 5),
                  // IconButton(
                  //   icon: Icon(Icons.edit, color: AppColors.green),
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return SimpleDialog(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           title: Text("Add/Edit Category",
                  //               style: TextStyle(
                  //                   fontSize: 14, fontWeight: FontWeight.bold),
                  //               textAlign: TextAlign.center),
                  //           contentPadding: EdgeInsets.symmetric(
                  //               horizontal: 35, vertical: 25),
                  //           children: [
                  //             Divider(),
                  //             TextField(
                  //               // minLines: 6,
                  //               // maxLines: 6,
                  //               decoration: InputDecoration(
                  //                 hintText: "Enter here",
                  //                 hintStyle: TextStyle(color: Colors.grey),
                  //                 contentPadding:
                  //                     EdgeInsets.only(left: 10, top: 15),
                  //                 enabledBorder: OutlineInputBorder(
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(10.0)),
                  //                   borderSide: BorderSide(color: Colors.grey),
                  //                 ),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderRadius:
                  //                       BorderRadius.all(Radius.circular(10.0)),
                  //                   borderSide: BorderSide(color: Colors.grey),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             SizedBox(
                  //               width: MediaQuery.of(context).size.width,
                  //               child: RaisedButton(
                  //                 padding: EdgeInsets.symmetric(vertical: 10),
                  //                 color: Theme.of(context).primaryColor,
                  //                 elevation: 0,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Text(
                  //                   "Save",
                  //                   style: Theme.of(context).textTheme.button,
                  //                 ),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  // SizedBox(width: 5),
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
