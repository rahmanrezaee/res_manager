import 'package:admin/modules/dishes/Models/AddonModel.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:admin/modules/orders/Models/OrderModels.dart';
import 'package:admin/modules/orders/Services/OrderSerives.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../themes/colors.dart';

class OrderItem extends StatefulWidget {
  String status;
  String resturantId;
  var scaffoldKey;
  OrderItem({@required this.status, this.resturantId, this.scaffoldKey});
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Future getOrder;

  @override
  void initState() {
    super.initState();

    getOrderData();
  }

  void getOrderData() {
    if (widget.resturantId != null) {
      getOrder = OrderServices()
          .getSingleOrder(state: widget.status, resturantId: widget.resturantId)
          .then((value) {
        setState(() {
          orderList = value;
        });
      });
    } else {
      getOrder = OrderServices()
          .getAllOrder(
            state: widget.status,
          )
          .then((value) => setState(() {
                orderList = value;
              }));
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  List<OrderModels> orderList;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getOrder,
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
                : ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return getItem(orderList[index]);
                    },
                  );
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
                  "Order ID: ${item.cardName} ",
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
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
                              .updatepickupDate(item.id, item.timePicker)
                              .then((value) {
                            getOrderData();
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
                  // Row(children: [
                  //   SizedBox(
                  //     width: 35,
                  //     height: 35,
                  //     child: RaisedButton(
                  //       padding: EdgeInsets.all(0),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       elevation: 0,
                  //       color: AppColors.green,
                  //       child: Icon(Icons.check, color: Colors.white),
                  //       onPressed: () {},
                  //     ),
                  //   ),
                  //   SizedBox(width: 20),
                  //   SizedBox(
                  //     width: 35,
                  //     height: 35,
                  //     child: RaisedButton(
                  //       padding: EdgeInsets.all(0),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       elevation: 0,
                  //       onPressed: () {},
                  //       color: AppColors.redText,
                  //       child: Icon(Icons.close, color: Colors.white),
                  //     ),
                  //   ),
                  // ]),
                  Visibility(
                    visible: item.status != "completed",
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
                            .pickup(item.id, "completed")
                            .then((value) {
                          getOrderData();
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
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
                            child: SimpleDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  "Add On List",
                                  style: Theme.of(context).textTheme.headline3,
                                  textAlign: TextAlign.center,
                                ),
                                titlePadding: EdgeInsets.only(top: 15),
                                children: getAddonList(model.addOn)),
                          ),
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
                            child: SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                "Order Note",
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              ),
                              titlePadding: EdgeInsets.only(top: 15),
                              contentPadding: EdgeInsets.all(15),
                              children: [
                                Divider(),
                                Text("Heloo w", textAlign: TextAlign.center),
                              ],
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
            Text("Price : ${model.quantity}"),
          ],
        ),
      ),
    );
  }

  List<Widget> getAddonList(List<AddonModel> addOn) {
    List<Widget> addonItem = [];

    for (AddonModel item in model.addOn) {
      addonItem.add(
          Text("${item.name} : ${item.quantity}", textAlign: TextAlign.center));
    }

    return addonItem;
  }
}
