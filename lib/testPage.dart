import 'package:flutter/material.dart';

class TestApp extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            /// wrap:positioned of "Rectangle 239"
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Container(
                          child: Stack(
                            children: [
                              /// wrap:positioned of "BG"
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            width: 219,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                        /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                                        Container(),
                                      ],
                                    ),
                                    width: 375,
                                    height: 46,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 293.67,
                                top: 17.33,
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Opacity(
                                                opacity: 0.5,
                                                child: Container(
                                                  width: 18,
                                                  height: 7.33,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              width: 22,
                                              height: 11.33,
                                              padding: EdgeInsets.all(
                                                2,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Opacity(
                                              opacity: 0.5,
                                              child: Container(
                                                width: 1.33,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                                            Container(),
                                          ],
                                        ),
                                        width: 24.33,
                                        height: 11.33,
                                      ),

                                      /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                                      Container(),
                                    ],
                                  ),
                                  width: 66.66,
                                  height: 11.34,
                                ),
                              ),
                              Positioned(
                                left: 33.45,
                                top: 17.17,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    width: 28.43,
                                    height: 11.09,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                              Container(),
                            ],
                          ),
                          width: 375,
                          height: 44,
                        ),
                        width: 375,
                        height: 44,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Settings",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                            ),
                            SizedBox(
                              width: 65.5,
                            ),
                            Text(
                              "Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter",
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 65.5,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                        ),
                        width: 343,
                        height: 36,
                      ),
                    ],
                  ),
                  width: 376,
                  padding: EdgeInsets.only(
                    left: 1,
                    bottom: 149,
                  ),
                  decoration: BoxDecoration(
                    color: Color(
                      0xff5db074,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 108,
              top: 128,
              child: Container(
                width: 158,
                height: 158,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "bridged://url-reservation/image-hosting/151:686",
                    ),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(
                        0x26646464,
                      ),
                      offset: Offset(
                        0,
                        4,
                      ),
                      blurRadius: 20,
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 52,
              top: 302,
              child: Container(
                child: Stack(
                  children: [
                    Text(
                      "Victoria Robertson",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "A mantra goes here",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
                      textAlign: TextAlign.center,
                    ),

                    /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                    Container(),
                  ],
                ),
                width: 272,
                height: 63,
              ),
            ),
            Positioned(
              left: 16,
              top: 389,
              child: Container(
                child: Container(
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                child: Text(
                                  "Posts",
                                  style: TextStyle(
                                    color: Color(
                                      0xff5db074,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                width: 171.5,
                                height: 46,
                                padding: EdgeInsets.only(
                                  top: 14,
                                  bottom: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),

                              /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                              Container(),
                            ],
                          ),
                          width: 171.5,
                          height: 46,
                        ),
                        SizedBox(
                          width: 0.25,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Color(
                              0xffbdbdbd,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 0.25,
                        ),
                        Text(
                          "Photos",
                          style: TextStyle(
                            color: Color(
                              0xffbdbdbd,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                    ),
                    width: 343,
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 2,
                      right: 61,
                    ),
                    decoration: BoxDecoration(
                      color: Color(
                        0xfff6f6f6,
                      ),
                    ),
                  ),
                  width: 343,
                  height: 50,
                ),
                width: 343,
                height: 50,
              ),
            ),
            Positioned(
              left: 16,
              top: 455,
              child: Container(
                child: Stack(
                  children: [
                    /// wrap:positioned of "Content Block"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(
                              0xfff6f6f6,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 0,
                      child: Text(
                        "Header",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),

                    /// wrap:positioned of "8m ago"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "8m ago",
                          style: TextStyle(
                            color: Color(
                              0xffbdbdbd,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 27,
                      child: SizedBox(
                        child: Text(
                          "He\'ll want to use your yacht, and I don\'t want this thing smelling like fish.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                        width: 269,
                      ),
                    ),

                    /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                    Container(),
                  ],
                ),
                width: 343,
                height: 77,
              ),
            ),
            Positioned(
              left: 16,
              top: 548,
              child: Container(
                child: Stack(
                  children: [
                    /// wrap:positioned of "Content Block"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(
                              0xfff6f6f6,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 0,
                      child: Text(
                        "Header",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),

                    /// wrap:positioned of "8m ago"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "8m ago",
                          style: TextStyle(
                            color: Color(
                              0xffbdbdbd,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 27,
                      child: SizedBox(
                        child: Text(
                          "He\'ll want to use your yacht, and I don\'t want this thing smelling like fish.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                        width: 269,
                      ),
                    ),

                    /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                    Container(),
                  ],
                ),
                width: 343,
                height: 77,
              ),
            ),
            Positioned(
              left: 16,
              top: 641,
              child: Container(
                child: Stack(
                  children: [
                    /// wrap:positioned of "Content Block"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(
                              0xfff6f6f6,
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 0,
                      child: Text(
                        "Header",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                    ),

                    /// wrap:positioned of "8m ago"
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "8m ago",
                          style: TextStyle(
                            color: Color(
                              0xffbdbdbd,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 66,
                      top: 27,
                      child: SizedBox(
                        child: Text(
                          "He\'ll want to use your yacht, and I don\'t want this thing smelling like fish.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                          ),
                        ),
                        width: 269,
                      ),
                    ),

                    /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                    Container(),
                  ],
                ),
                width: 343,
                height: 77,
              ),
            ),

            /// wrap:positioned of "Content/Content Block/Small"
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Stack(
                    children: [
                      /// wrap:positioned of "Content Block"
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(
                                0xfff6f6f6,
                              ),
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 66,
                        top: 0,
                        child: Text(
                          "Header",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),

                      /// wrap:positioned of "8m ago"
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "8m ago",
                            style: TextStyle(
                              color: Color(
                                0xffbdbdbd,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 66,
                        top: 27,
                        child: SizedBox(
                          child: Text(
                            "He\'ll want to use your yacht, and I don\'t want this thing smelling like fish.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                            ),
                          ),
                          width: 269,
                        ),
                      ),

                      /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                      Container(),
                    ],
                  ),
                  width: 343,
                  height: 77,
                ),
              ),
            ),

            /// image content of "iOS/Bottom Bar/5 Tabs"
            Image.network(
              "bridged://url-reservation/image-hosting/151:567",
              width: 375,
              height: 83.5,
              fit: BoxFit.cover,
            ),

            /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
            Container(),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}

// class NotificationBadge extends StatelessWidget {
//   final int totalNotifications;

//   const NotificationBadge({@required this.totalNotifications});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       decoration: new BoxDecoration(
//         color: Colors.red,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '$totalNotifications',
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PushNotification {
//   PushNotification({
//     this.title,
//     this.body,
//     this.dataTitle,
//     this.dataBody,
//   });

//   String title;
//   String body;
//   String dataTitle;
//   String dataBody;

//   factory PushNotification.fromJson(Map<String, dynamic> json) {
//     return PushNotification(
//       title: json["notification"]["title"],
//       body: json["notification"]["body"],
//       dataTitle: json["data"]["title"],
//       dataBody: json["data"]["body"],
//     );
//   }
// }
