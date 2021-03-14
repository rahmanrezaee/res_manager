import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import './service/privacyPolicy_service.dart';

class PrivacyPolicy extends StatelessWidget {
  static String routeName = "PrivacyPolicy";
  PrivacyPolicyService privacyPolicyService = new PrivacyPolicyService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarNodepad(context)
          ? adaptiveAppBarBuilder(
              context,
              AppBar(
                title: Text("Privacy Policy"),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Image.asset("assets/images/notification.png"),
                    onPressed: () {
                      Navigator.pushNamed(context, NotificationPage.routeName);
                    },
                  )
                ],
                elevation: 0,
                leading: showAppBarNodepad(context)
                    ? IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      )
                    : null,
              ),
            )
          : AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text("Privacy Policy")),
      body: FutureBuilder(
          future: privacyPolicyService.getPrivacy(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    snapshot.data,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14, height: 1.5),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Something went wrong!! Please check your internet connection and try again."),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
