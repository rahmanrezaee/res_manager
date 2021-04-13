import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:admin/modules/contactUs/providers/contact_provider.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:provider/provider.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  ContactProvider contactProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us Request"),
        centerTitle: true,
        actions: [NotificationAppBarWidget()],
        leading: showAppBarNodepad(context)
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              )
            : null,
      ),
      body: Consumer<ContactProvider>(
        builder: (BuildContext context, value, Widget child) {
          return RefreshIndicator(
            onRefresh: () async {
              value.setPage(1);
            },
            child: value.contacts == null
                ? FutureBuilder(
                    future: value.fetchContacts(),
                    builder: (context, snapshot) {
                      return Center(child: CircularProgressIndicator());
                    })
                : IncrementallyLoadingListView(
                    shrinkWrap: true,
                    hasMore: () => value.hasMoreItems,
                    itemCount: () => value.contacts.length,
                    loadMore: () async {
                      await value.fetchContacts();
                    },
                    onLoadMore: () {
                      value.showLoadingBottom(true);
                    },
                    onLoadMoreFinished: () {
                      value.showLoadingBottom(false);
                    },
                    loadMoreOffsetFromBottom: 0,
                    itemBuilder: (context, index) {
                      if ((value.loadingMore ?? false) &&
                          index == value.contacts.length - 1) {
                        return Column(
                          children: <Widget>[
                            _contactItemBuilder(context, value.contacts[index]),
                            PlaceholderItemCard()
                          ],
                        );
                      }
                      return _contactItemBuilder(
                          context, value.contacts[index]);
                    },
                  ),
          );
        },
      ),

      // body: Consumer<ContactProvider>(
      //   builder: (context, contactProvider, child) {
      //     return contactProvider.getContacts == null
      //         ? FutureBuilder(
      //             future: contactProvider.fetchContacts(),
      //             builder: (context, snapshot) {
      //               return Center(child: CircularProgressIndicator());
      //             })
      //         : contactProvider.getContacts.isEmpty
      //             ? Center(child: Text("No Contact us "))
      //             : ListView.builder(
      //                 itemCount: contactProvider.getContacts.length,
      //                 itemBuilder: (context, i) {
      //                   return _contactItemBuilder(
      //                     context,
      //                     contactProvider.getContacts[i],
      //                   );
      //                 },
      //               );
      //   },
      // ),
    );
  }
}

_contactItemBuilder(context, ContactModel contact) {
  return contact.email != null
      ? Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${contact.username ?? "User Was Deleted"}",
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 5),
                Text(
                  "${contact.email ?? "User Was Deleted"}",
                ),
                SizedBox(height: 5),
                Text("${contact.restaurant ?? "Resturant Was Deleted"}"),
                SizedBox(height: 5),
                Text("${contact.subject ?? "no Subject"}"),
                SizedBox(height: 5),
                Text(
                  "${contact.message ?? "No Message"}",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        )
      : SizedBox();
}

// class ContactItem extends StatelessWidget {
//   final ContactModel contact;

//   ContactItem(this.contact);
//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Card(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 contact.username,
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//               SizedBox(height: 5),
//               Text(contact.email),
//               SizedBox(height: 5),
//               Text(contact.restaurant),
//               SizedBox(height: 5),
//               Text(contact.subject),
//               SizedBox(height: 5),
//               Text(
//                 contact.message,
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       );
//     } catch (e, s) {
//       print(contact.message);
//       return Text("Error Accured");
//     }
//   }
// }
