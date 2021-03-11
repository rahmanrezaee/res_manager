import 'package:admin/modules/Resturant/Models/Resturant.dart';
import 'package:admin/modules/Resturant/statement/resturant_provider.dart';
import 'package:admin/modules/dishes/Screen/dishes_page.dart';
import 'package:admin/themes/colors.dart';
import 'package:admin/modules/Resturant/Screen/formResturant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResturantItem extends StatelessWidget {
  ResturantModel resturantModel;

  ResturantItem(this.resturantModel);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text("${resturantModel.resturantName}",
                  style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              flex: 2,
              child: Text("${resturantModel.activeOrder} Active Orders",
                  style: TextStyle(color: Colors.grey)),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.green),
                  onPressed: () {
                    Navigator.pushNamed(context, ResturantForm.routeName,
                        arguments: resturantModel.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.green),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                Text("Are you sure to delete this Resturant!?"),
                            actions: [
                              RaisedButton(
                                child: Text(
                                  "Delete",
                                ),
                                onPressed: () {
                                  print("hello");
                                  Provider.of<ResturantProvider>(context,
                                          listen: false)
                                      .deleteResturant(resturantModel.id)
                                      .then((res) {
                                    // ScaffoldMessenger.of(context)
                                    //     .hideCurrentSnackBar();
                                    if (res == true) {
                                      Navigator.of(context).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(new SnackBar(
                                      //   content: Text(
                                      //       "The user deleted Successfuly."),
                                      // ));
                                    } else {
                                      Navigator.of(context).pop();
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
    );
  }
}
