import 'package:admin/modules/coupons/Widgets/form_coupon.dart';
import 'package:admin/modules/coupons/model/CouponModel.dart';
import 'package:admin/modules/coupons/statement/couponProvider.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/DropDownFormField.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants/assest_path.dart';
import 'package:admin/themes/colors.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CouponsPage extends StatefulWidget {
  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final _formKey = new GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                title: Text("Manage Coupons"),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                actions: [NotificationAppBarWidget()],
                bottom: isLoading
                    ? PreferredSize(
                        preferredSize: Size(10, 10),
                        child: LinearProgressIndicator(),
                      )
                    : null,
              ),
            )
          : AppBar(
              title: Text("Manage Coupons"),
              elevation: 0,
              bottom: isLoading
                  ? PreferredSize(
                      preferredSize: Size(10, 10),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Coupon", style: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: RaisedButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: FormCoupen(formKey: _formKey),
                            );
                          },
                        );
                      },
                      color: Theme.of(context).primaryColor,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<CoupenProvider>(
              builder: (BuildContext context, value, Widget child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    value.setPage(1);
                  },
                  child: value.list == null
                      ? FutureBuilder(
                          future: value.getCoupenList(),
                          builder: (context, snapshot) {
                            return Center(child: CircularProgressIndicator());
                          })
                      : IncrementallyLoadingListView(
                          shrinkWrap: true,
                          hasMore: () => value.hasMoreItems,
                          itemCount: () => value.list.length,
                          loadMore: () async {
                            await value.getCoupenList();
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
                                index == value.list.length - 1) {
                              return Column(
                                children: <Widget>[
                                  _couponsItemBuilder(
                                      context,
                                      value.list[index],
                                      _formKey,
                                      _scaffoldKey),
                                  PlaceholderItemCard()
                                ],
                              );
                            }
                            return _couponsItemBuilder(context,
                                value.list[index], _formKey, _scaffoldKey);
                          },
                        ),
                );
              },
            ),
            //  Consumer<CoupenProvider>(
            //         builder: (BuildContext context, value, Widget child) {
            //           return RefreshIndicator(
            //             onRefresh: () async {
            //               value.getCoupenList();
            //               return true;
            //             },
            //             child: value.list != null
            //                 ? value.list.isEmpty
            //                     ? Center(child: Text("No Coupen"))
            //                     : ListView.builder(
            //                         shrinkWrap: true,
            //                         physics: NeverScrollableScrollPhysics(),
            //                         itemCount: value.list.length,
            //                         itemBuilder: (BuildContext context, int index) {
            //                           return _couponsItemBuilder(context,
            //                               value.list[index], _formKey, _scaffoldKey);
            //                           ;
            //                         },
            //                       )
            //                 : FutureBuilder(
            //                     future: value.getCoupenList(),
            //                     builder: (BuildContext context,
            //                         AsyncSnapshot<dynamic> snapshot) {
            //                       if (snapshot.connectionState ==
            //                           ConnectionState.waiting) {
            //                         return Center(
            //                           child: CircularProgressIndicator(),
            //                         );
            //                       } else {
            //                         if (snapshot.hasData) {
            //                           return Center(
            //                             child: Text("Error In Fetch Data"),
            //                           );
            //                         }
            //                       }
            //                     },
            //                   ),
            //           );
            //         },
            //       ),
          ),
        ],
      ),
    );
  }

  _couponsItemBuilder(context, CouponModel coupen, _formKey, _scaffoldKey) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${coupen.name}",
                style: Theme.of(context).textTheme.headline4),
            Text("${coupen.code}", style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                IconButton(
                  icon: Image.asset("assets/images/edit.png"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: FormCoupen(
                            formKey: _formKey,
                            coupenId: coupen.id,
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Image.asset("assets/images/delete.png"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "Delete Coupon!",
                              okFun: () {
                                setState(() {
                                  isLoading = true;
                                });

                                Provider.of<CoupenProvider>(context,
                                        listen: false)
                                    .deleteCoupen(coupen.id)
                                    .then((res) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (res) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Deleted Successfully"),
                                      duration: Duration(seconds: 1),
                                    ));
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(SnackBar(
                                    //   content: Text(
                                    //       "The Category Deleted Successfully"),
                                    // // ));
                                    // Navigator.of(context).pop();
                                  } else {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("You can not delete"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  }
                                });
                              },
                              cancelFun: () {},
                              descreption: "Are You Sure To Delete Coupon?",
                            ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_textFieldBuilder(String hintText) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}
