import 'package:admin/modules/Authentication/providers/auth_provider.dart';
import 'package:admin/modules/contentManagement/provider/contentManagement_provider.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/modules/policy/service/privacyPolicy_service.dart';
import 'package:admin/modules/term/services/term&condition_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentManagementPage extends StatefulWidget {
  static String routeName = "Content Management";

  @override
  _ContentManagementPageState createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  TextEditingController subjectCtrl = new TextEditingController();
  TextEditingController messageCtrl = new TextEditingController();
  bool _isLoading = false;
  bool isLoadingData = false;

  final _keyForm = GlobalKey<FormState>();

  String _dropdownController;
  AuthProvider auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Content Management",
          ),
          leading: IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          actions: [
            NotificationAppBarWidget(),
          ],
          bottom: isLoadingData
              ? PreferredSize(
                  preferredSize: Size(10, 10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _keyForm,
            // autovalidateMode: AutovalidateMode.,
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Share your Terms&Conditions/Privacy&Policy/Refund&Return to show for Customers",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ]),
                  child: DropdownButtonFormField<String>(
                    value: _dropdownController,
                    hint: Text(
                      'Select Content Management',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      if (value == "Privacy and Policy") {
                        setState(() {
                          isLoadingData = true;
                        });
                        PrivacyPolicyService().getPrivacy().then((value) {
                          setState(() {
                            messageCtrl.text = value;
                            isLoadingData = false;
                          });
                        });
                      } else if (value == "Terms and Conditions") {
                        setState(() {
                          isLoadingData = true;
                        });
                        TermConditionService().getTerm().then((value) {
                          setState(() {
                            messageCtrl.text = value;
                            isLoadingData = false;
                          });
                        });
                      } else if (value == "Refund and Return") {
                        setState(() {
                          isLoadingData = true;
                        });
                        TermConditionService().getRefound().then((value) {
                          setState(() {
                            messageCtrl.text = value;
                            isLoadingData = false;
                          });
                        });
                      }

                      setState(() {
                        _dropdownController = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please Select an Option' : null,
                    items: [
                      "Privacy and Policy",
                      "Terms and Conditions",
                      "Refund and Return"
                    ]
                        .map((label) => DropdownMenuItem(
                              child: Text(label.toString()),
                              value: label,
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                TextFormField(
                  controller: messageCtrl,
                  minLines: 8,
                  maxLines: 10,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Your Message is Empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Your Message",
                    hintStyle: TextStyle(color: Colors.grey),
                    errorStyle: TextStyle(color: Colors.red),
                    contentPadding: EdgeInsets.only(left: 10, top: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
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
                    child: _isLoading
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator())
                        : Text(
                            "Submit",
                            style: Theme.of(context).textTheme.button,
                          ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_keyForm.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              String slug = "";

                              switch (_dropdownController) {
                                case "Privacy and Policy":
                                  slug = "pandp";
                                  break;
                                case "Terms and Conditions":
                                  slug = "tandc";
                                  break;
                                case "Refund and Return":
                                  slug = "refound";
                                  break;
                              }

                              Provider.of<ContentManagementprovider>(context,
                                      listen: false)
                                  .submitContentMangement(_dropdownController,
                                      messageCtrl.text, slug, auth)
                                  .then((value) {
                                setState(() {
                                  //OK now it is showing the right message.
                                  _isLoading = false;
                                });
                                //First we should check the status
                                if (value['status'] == true) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Successfuly submited",
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: new Duration(seconds: 3),
                                  ));
                                  setState(() {
                                    _keyForm.currentState.reset();

                                    FocusScope.of(context).unfocus();
                                    _dropdownController = null;
                                    messageCtrl.clear();
                                  });
                                } else {
                                  //Now it should shows an error message
                                  //If status false show error message
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      value.message,
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: new Duration(seconds: 3),
                                  ));
                                }
                              });
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget getValueFromtxt(Text text) {
    return Text("Please Select a Restaurant");
  }
}
