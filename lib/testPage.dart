// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// PushNotification _notificationInfo;
// int _totalNotifications;

// Future<dynamic> _firebaseMessagingBackgroundHandler(
//   Map<String, dynamic> message,
// ) async {
//   // Initialize the Firebase app
//   await Firebase.initializeApp();
//   print('onBackgroundMessage received: $message');
// }

// class TestApp extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<TestApp> {
//   FirebaseMessaging _messaging = FirebaseMessaging();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       new FlutterLocalNotificationsPlugin();
//   void notifyInitialize() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     final MacOSInitializationSettings initializationSettingsMacOS =
//         MacOSInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false);
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//             macOS: initializationSettingsMacOS);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   Future onSelectNotification(String payload) async {
//     Navigator.pushNamed(
//       context,
//       payload,
//     );
//   }

//   void registerNotification() async {
//     // Initialize the Firebase app
//     await Firebase.initializeApp();

//     // On iOS, this helps to take the user permissions
//     await _messaging.requestNotificationPermissions(
//       IosNotificationSettings(
//         alert: true,
//         badge: true,
//         provisional: false,
//         sound: true,
//       ),
//     );

//     // For handling the received notifications
//     _messaging.configure(
//       onMessage: (message) async {
//         print('onMessage received: $message');

//         PushNotification notification = PushNotification.fromJson(message);

//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });

//         // For displaying the notification as an overlay
//       },
//       onBackgroundMessage: _firebaseMessagingBackgroundHandler,
//       onLaunch: (message) async {
//         print('onLaunch: $message');

//         PushNotification notification = PushNotification.fromJson(message);

//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//       },
//       onResume: (message) async {
//         print('onResume: $message');

//         PushNotification notification = PushNotification.fromJson(message);

//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//       },
//     );

//     // Used to get the current FCM token
//     _messaging.getToken().then((token) {
//       print('Token: $token');
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   void initState() {
//     _totalNotifications = 0;
//     notifyInitialize();
//     registerNotification();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notify'),
//         brightness: Brightness.dark,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'App for capturing Firebase Push Notifications',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           SizedBox(height: 16.0),
//           NotificationBadge(totalNotifications: _totalNotifications),
//           SizedBox(height: 16.0),
//           _notificationInfo != null
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'TITLE: ${_notificationInfo.title ?? _notificationInfo.dataTitle}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'BODY: ${_notificationInfo.body ?? _notificationInfo.dataBody}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }

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
