import 'package:admin/modules/notifications/models/notification_model.dart';
import 'package:admin/modules/notifications/provider/notificaction_provider.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'notification_details.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = "Notification";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Notifications"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              onPressed: () {},
            ),
          ],


      ),
      body: Consumer<NotificationProvider>(
        builder: (BuildContext context, value, Widget child) {
          return value.notificatins == null
              ? FutureBuilder(
                  future: value.fetchNotifications(),
                  builder: (context, snapshot) {
                    return Center(child: CircularProgressIndicator());
                  })
              : ListView.builder(
                  itemCount: value.notificatins.length,
                  itemBuilder: (context, i) {
                    return NotificationItem(value.notificatins[i]);
                  },
                );
        },
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;

  NotificationItem(this.notification);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationDetails()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.notification.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text("${widget.notification.body.substring(0, 100)}"),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '${Jiffy(widget.notification.createdAt).fromNow()}',
                        style: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
