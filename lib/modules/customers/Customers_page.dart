import 'package:admin/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomersPage extends StatelessWidget {
  static String routeName = "CustomersPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .2,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Manage Customers"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text("Customers", style: Theme.of(context).textTheme.headline4),
          SizedBox(height: 14),
          _customerItemBuilder(context),
        ],
      ),
    );
  }
}

_customerItemBuilder(context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Username",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text("15 Active Orders", style: TextStyle(color: Colors.grey)),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 25),
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
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
