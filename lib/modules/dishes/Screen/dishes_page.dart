//core
import 'package:admin/modules/dishes/DishServics/dishServices.dart';
import 'package:admin/modules/dishes/Models/dishModels.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';

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

  Future getDish;
  @override
  void initState() {
    catId = widget.params['catId'];
    resturantId = widget.params['resturantId'];
    getDish = getFootListWithoutPro(catId).then((value) {
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
      appBar: AppBar(
        elevation: .2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Manage Dishes"),
        bottom: isLoading
            ? PreferredSize(
                preferredSize: Size(10, 10),
                child: LinearProgressIndicator(),
              )
            : null,
        actions: [
          Visibility(
            visible: showAppBarNodepad(context),
                      child: IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewDish.routeName, arguments: {
                  "dishId": null,
                  "catId": catId,
                  "resturantId": resturantId,
                }).then((value) {
                  print("Done Adding");
                  getFootListWithoutPro(catId).then((value) {
                    setState(() {
                      dishList = value;
                    });
                  });
                });
              },
            ),
          ),
        ],
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
                  Text("Dish of Category", style: Theme.of(context).textTheme.headline4),
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
                          getFootListWithoutPro(catId).then((value) {
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
                      deleteDish(element.foodId).then((res) {
                        setState(() {
                          isLoading = false;
                        });
                        if (res) {
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(
                          //   content: Text(
                          //       "The Category Deleted Successfully"),
                          // ));

                        } else {
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(
                          //   content: Text(res['message']),
                          // ));

                        }
                      });
                    },
                    cancelFun: () {},
                    descreption: "Are You Sure To Delete Dish?",
                  ));
        }),
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
  DishItem(this.dishItem, this.catId, this.resturantId, this.onDelete);

  @override
  _DishItemState createState() => _DishItemState();
}

class _DishItemState extends State<DishItem> {
  int visible = 0;
  int quantity = 0;
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
                              !widget.dishItem.visibility)
                          .then((value) {
                        if (!value) {
                          setState(() {
                            widget.dishItem.visibility =
                                !widget.dishItem.visibility;
                          });
                        }
                      });
                    },
                    child: Icon(
                      widget.dishItem.visibility
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child:
                      Icon(Icons.star, color: Theme.of(context).primaryColor),
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
                "${widget.dishItem.price}\$",
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
