//core
import 'dart:async';

import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/dishes/DishServics/dishServices.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/modules/dishes/Screen/addNewDish_page.dart';
import '../../../themes/style.dart';

// class DishPage extends StatelessWidget {
//

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(routes: {
//       AddNewDish.routeName: (context) => AddNewDish(),
//     }, theme: restaurantTheme, home: DishHome());
//   }
// }

class DishPage extends StatefulWidget {
  static String routeName = "DishPage";
  Map params;
  DishPage(this.params);
  @override
  _DishHomeState createState() => _DishHomeState();
}

class _DishHomeState extends State<DishPage> {
  bool isLoadDish = true;

  List<DishModel> dishList;
  String catId;
  String resturantId;
  final _scoffoldKey = GlobalKey<ScaffoldState>();
  Future getDish;
  AuthProvider auth;
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    catId = widget.params['catId'];
    resturantId = widget.params['resturantId'];
    getDish = getFootListWithoutPro(catId, auth).then((value) {
      dishList = value;
    });

    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: _scoffoldKey,
      appBar: AppBar(
        elevation: .2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Manage Dishes"),
        centerTitle: true,
        bottom: isLoading
            ? PreferredSize(
                preferredSize: Size(10, 10),
                child: LinearProgressIndicator(),
              )
            : null,
        actions: [NotificationAppBarWidget()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dish of Category",
                        style: Theme.of(context).textTheme.headline4),
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
                          Navigator.of(context)
                              .pushNamed(AddNewDish.routeName, arguments: {
                            "dishId": null,
                            "catId": catId,
                            "resturantId": resturantId,
                          }).then((value) {
                            print("Done Adding");
                            getFootListWithoutPro(catId, auth).then((value) {
                              setState(() {
                                dishList = value;
                              });
                            });
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: getDish,
                builder: (context, snapshot) {
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
                      return dishList.isEmpty
                          ? Center(
                              child: Text("No Dish"),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ResponsiveGridRow(
                                  children: getColumnDish(dishList),
                                ),
                              ),
                            );
                    }
                  } else {
                    return Center(
                      child: Text("error in Fetch orders"),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  List<ResponsiveGridCol> getColumnDish(List<DishModel> items) {
    List<ResponsiveGridCol> wid = [];

    items.forEach((element) {
      wid.add(ResponsiveGridCol(
        xs: 6,
        sm: 6,
        md: 4,
        lg: 3,
        child: DishItem(element, this.catId, this.resturantId, () {
          showDialog(
              context: context,
              builder: (BuildContext context) => FancyDialog(
                    title: "Delete Dish!",
                    okFun: () {
                      setState(() {
                        isLoading = true;
                      });
                      deleteDish(element.foodId, auth).then((res) {
                        setState(() {
                          isLoading = false;
                        });
                        if (res["status"]) {
                          _scoffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("The Dish Deleted Successfully"),
                          ));

                          getFootListWithoutPro(catId, auth).then((value) {
                            setState(() {
                              dishList = value;
                            });
                          });
                        } else {
                          _scoffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("${res["message"]}"),
                          ));
                        }
                      });
                    },
                    cancelFun: () {},
                    descreption: "Are You Sure To Delete Dish?",
                  ));
        }, _scoffoldKey),
      ));
    });

    return wid;
  }
}

class DishItem extends StatefulWidget {
  DishModel dishItem;
  String catId;
  String resturantId;
  Function onDelete;
  final keySc;
  DishItem(
      this.dishItem, this.catId, this.resturantId, this.onDelete, this.keySc);

  @override
  _DishItemState createState() => _DishItemState();
}

class _DishItemState extends State<DishItem> {
  int visible = 0;
  int quantity = 0;
  AuthProvider auth;
  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(DishDetails.routeName);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ]),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "${widget.dishItem.images[0].url}",
                      fit: BoxFit.cover,
                      color: widget.dishItem.visibility
                          ? Colors.transparent
                          : Colors.white54,
                      colorBlendMode: BlendMode.lighten,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.dishItem.visibility =
                            !widget.dishItem.visibility;
                      });
                      changeVisiablity(widget.dishItem.foodId,
                              widget.dishItem.visibility, auth)
                          .then((value) {
                        print("widget.dishItem.foodId visible");

                        if (!value) {
                          setState(() {
                            widget.dishItem.visibility =
                                !widget.dishItem.visibility;
                          });
                        } else {
                          widget.keySc.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "The Dish ${widget.dishItem.visibility ? "Visiable" : "Invisiable"} "),
                          ));
                        }
                      });
                    },
                    child: Icon(
                      widget.dishItem.visibility == false
                          ? FontAwesomeIcons.eyeSlash
                          : Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: RatingBar.builder(
                    initialRating: widget.dishItem.averageRating != null
                        ? widget.dishItem.averageRating
                        : 0,
                    itemSize: 25,
                    minRating: 1,
                    updateOnDrag: false,
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    glowColor: Colors.white,
                    unratedColor: Colors.white,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${widget.dishItem.foodName}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "\$ ${widget.dishItem.price}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AddNewDish.routeName, arguments: {
                            "dishId": widget.dishItem.foodId,
                            "catId": widget.catId,
                            "resturantId": widget.resturantId,
                          });
                        }),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 35,
                  height: 35,
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    onPressed: () => widget.onDelete(),
                    color: Theme.of(context).primaryColor,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ]),
            ]),
          )
        ]),
      ),
    );
  }
}
