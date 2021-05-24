import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';
import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/dishes/Models/AddonModel.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/orders/Models/OrderModels.dart';
import 'package:admin/modules/orders/Services/OrderSerives.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:jiffy/jiffy.dart';
import 'package:num_to_txt/num_to_txt.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../themes/colors.dart';
import 'package:admin/widgets/capitalize.dart';

class OrderItem extends StatefulWidget {
  String status;
  String resturantId;
  var scaffoldKey;
  OrderItem({@required this.status, this.resturantId, this.scaffoldKey});
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  AuthProvider auth;
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    initRefresh();
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  List<OrderModels> orderList;
  bool _loadingMore;
  bool _hasMoreItems;
  int _maxItems;
  Future _initialLoad;
  int page = 1;

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (picked_s != null) return "${picked_s.hour}:${picked_s.minute}";
  }

  Future<void> initRefresh() async {
    page = 1;
    _initialLoad = OrderServices()
        .getAllOrder(auth: auth, state: widget.status, page: page)
        .then((data) {
      setState(() {
        orderList = data["orders"];
        _maxItems = data["total"];
        _hasMoreItems = true;
      });
    });
  }

  Future _loadMoreItems() async {
    print("this not work");
    ++page;
    await OrderServices()
        .getAllOrder(auth: auth, state: widget.status, page: page)
        .then((data) {
      List<OrderModels> temp = data["orders"];
      orderList.addAll(temp);
    });
    _hasMoreItems = orderList.length < _maxItems;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialLoad,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text("error in Fetch orders"),
            );
          } else {
            return orderList.isEmpty
                ? Center(
                    child: Text("No Order"),
                  )
                : IncrementallyLoadingListView(
                    hasMore: () => _hasMoreItems,
                    itemCount: () => orderList.length,
                    loadMore: () async {
                      print("loading again");
                      await _loadMoreItems();
                    },
                    onLoadMore: () {
                      setState(() {
                        _loadingMore = true;
                      });
                    },
                    onLoadMoreFinished: () {
                      setState(() {
                        _loadingMore = false;
                      });
                    },
                    loadMoreOffsetFromBottom: 2,
                    itemBuilder: (context, index) {
                      if ((_loadingMore ?? false) &&
                          index == orderList.length - 1) {
                        return Column(
                          children: <Widget>[
                            getItem(orderList[index]),
                            PlaceholderItemCard()
                          ],
                        );
                      }
                      return getItem(orderList[index]);
                    },
                  );
            // : ListView.builder(
            //     itemCount: orderList.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return
            //     },
            //   );
          }
        } else {
          return Center(
            child: Text("error in Fetch orders"),
          );
        }
      },
    );
  }

  Widget getItem(OrderModels item) {
    log("status ${item.status}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.accentLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer Name: ${item.user['username']}",
              style: TextStyle(color: AppColors.redText),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${item.orderNumber} ",
                  style: TextStyle(color: AppColors.redText),
                ),
                Text(
                  "${Jiffy(item.date).yMMMMd}",
                  style: TextStyle(color: AppColors.redText),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 30),
            Text("Items:", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      itemCount: item.items.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return DishItem(
                          model: item.items[index],
                        );
                      }),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Paid By: ${item.cardName}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.green,
              ),
            ),
            SizedBox(height: 10),
            Visibility(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: item.status == "active",
                      child: Row(children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            color: AppColors.green,
                            child: Icon(Icons.check, color: Colors.white),
                            onPressed: () {
                              OrderServices()
                                  .pickup(item.id, "accepted", auth)
                                  .then((value) {
                                initRefresh();
                                widget.scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Succecfully Done"),
                                  duration: Duration(seconds: 4),
                                ));
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
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
                              OrderServices()
                                  .pickup(item.id, "rejected", auth)
                                  .then((value) {
                                initRefresh();
                                widget.scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Succecfully Done"),
                                  duration: Duration(seconds: 4),
                                ));
                              });
                            },
                            color: AppColors.redText,
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                    Visibility(
                      visible: item.status == "accepted",
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pick Up at: ${item.timePicker ?? "00:00"} ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppColors.green,
                              ),
                            ),
                            SizedBox(width: 15),
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: RaisedButton(
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                color: AppColors.green,
                                child: Icon(Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  item.timePicker = await _selectTime(context);

                                  OrderServices()
                                      .updatepickupDate(
                                          item.id, item.timePicker, auth)
                                      .then((value) {
                                    initRefresh();
                                    widget.scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Succecfully Done"),
                                      duration: Duration(seconds: 2),
                                    ));
                                  });
                                },
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Visibility(
                      visible: item.status == "accepted",
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        elevation: 0,
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        child: Text("Mark Picked Up",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          OrderServices()
                              .pickup(item.id, "pickedUp", auth)
                              .then((value) {
                            initRefresh();
                            widget.scaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              content: Text("Succecfully Done"),
                              duration: Duration(seconds: 4),
                            ));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: item.status == "pickedUp" || item.status == "rejected",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Status :",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14)),
                    Text("${item.status}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class DishItem extends StatelessWidget {
  DishModel model;

  DishItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("food ${model.sendMap()}");
    return Container(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text("${model.foodName}"),
            FlatButton.icon(
              textColor: AppColors.green,
              label: Text(
                "View Add On",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              icon: Icon(
                Icons.description_rounded,
                color: AppColors.green,
              ),
              onPressed: () {
                int _isRadioSelected = 1;

                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return ListTileTheme(
                          iconColor: AppColors.green,
                          textColor: AppColors.green,
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                  toggleableActiveColor: AppColors.green),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Add On List",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.close))
                                    ],
                                  ),
                                  titlePadding: EdgeInsets.only(top: 15),
                                  children: [
                                    Divider(),
                                    getAddonList(model.addOn, context)
                                  ],
                                  // children:  [

                                  // ],
                                ),
                              )),
                        );
                      });
                    });
              },
            ),
            FlatButton.icon(
              textColor: AppColors.green,
              label: Text(
                "View Note",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              icon: Icon(
                Icons.description_rounded,
                color: AppColors.green,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return ListTileTheme(
                          iconColor: AppColors.green,
                          textColor: AppColors.green,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                toggleableActiveColor: AppColors.green),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: SimpleDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  "Order Note",
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center,
                                ),
                                titlePadding: EdgeInsets.only(top: 15),
                                contentPadding: EdgeInsets.all(15),
                                children: [
                                  Divider(),
                                  Container(
                                    height: getDeviceHeightSize(context) - 500,
                                    width: getDeviceWidthSize(context),
                                    child: ListView.builder(
                                      itemCount: model.orderNote.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return new Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 5,
                                              ),
                                              child: new Text(
                                                "${NumToTxt.numToOrdinal(i + 1).capitalize()} Dish",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10),
                                              color: Colors.grey[100],
                                              child: new Text(
                                                model.orderNote[i] == ""
                                                    ? "No Instruction"
                                                    : model.orderNote[i],
                                                style: new TextStyle(
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                            Divider()
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
            Text("Qty : ${model.quantity}"),
            SizedBox(
              width: 20,
            ),
            Text("Price : ${model.price}"),
          ],
        ),
      ),
    );
  }

  Widget getAddonList(List<List<AddonItems>> addOn, context) {
    return Container(
      height: getDeviceHeightSize(context) - 500,
      width: getDeviceWidthSize(context),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: addOn.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return new ExpansionTile(
                  title: new Text(
                      "${NumToTxt.numToOrdinal(i + 1).capitalize()} Dish",
                      style: Theme.of(context).textTheme.headline6),
                  children: <Widget>[
                    addOn[i].length > 0
                        ? Container(
                            color: Colors.grey[100],
                            child: new Column(
                              children: _buildExpandableContent(addOn[i]),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("no Addon"),
                            ),
                          ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _buildExpandableContent(List<AddonItems> addon) {
    List<Widget> columnContent = [];

    for (AddonItems content in addon)
      columnContent.add(
        new ListTile(
          title: new Text(
            content.name,
            style: new TextStyle(fontSize: 14.0),
          ),
          trailing: Text("\$ ${content.price}"),
        ),
      );

    return columnContent;
  }
}
