import 'package:admin/modules/report/widget/TextfieldResturant.dart';
import 'package:admin/modules/report/widget/buttonResturant.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:admin/widgets/orderItem_widget.dart';
//widgets
import 'package:admin/widgets/commentItem_widget.dart';

class ResturantForm extends StatefulWidget {
  static final routeName = "resturantform";
  @override
  _ResturantFormState createState() => _ResturantFormState();
}

class _ResturantFormState extends State<ResturantForm> {
  bool openForOrder = false;
  bool autoAcceptOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(children: [
              Container(
                height: 130,
                child: ClipRRect(
                  child: Image.network('https://i.pravatar.cc/300'),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldResturant(
                            hintText: "Resturant Name",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldResturant(
                            hintText: "Resturant Name",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Open for Orders",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: openForOrder,
                  onChanged: (value) {
                    setState(() {
                      openForOrder = value;
                    });
                  },
                  // trackColor: AppColors.green,
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Auto Accept Order",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                CupertinoSwitch(
                  value: autoAcceptOrder,
                  onChanged: (value) {
                    setState(() {
                      autoAcceptOrder = value;
                    });
                  },
                  // trackColor: AppColors.green,
                ),
              ],
            ),
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(child: _dataBody()),
                    ],
                  )),
            ),
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 6,
                  md: 6,
                  sm: 12,
                  xl: 12,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormFieldResturant(
                      hintText: "User Email Address",
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 6,
                  md: 6,
                  sm: 12,
                  xl: 12,
                  xs: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormFieldResturant(
                      hintText: "User Email Address",
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                width: getQurIpadAndFullMobWidth(context),
                child: ButtonRaiseResturant(
                  color: Theme.of(context).primaryColor,
                  label: "Save",
                  onPress: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// Let's create a DataTable and show the employee list in it.
  Widget _dataBody() {
    return DataTable(
      dataTextStyle: TextStyle(
        color: Colors.black
      ),
      columns: [
      DataColumn(
          label: Text(
        'Timings',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      )),
      DataColumn(
          label: Text(
        'Open',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      )),
      DataColumn(
          label: Text(
        'Close',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      )),
    ], rows: [
      DataRow(

        cells: [
          DataCell(Text("MONDAY")),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text("MONDAY")),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text("MONDAY")),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(Text("MONDAY")),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          DataCell(
            Row(
              children: [
                Text("09:00"),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
