import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:admin/modules/contactUs/providers/contact_provider.dart';
import 'package:admin/modules/notifications/notification_page.dart';
import 'package:admin/responsive/functionsResponsive.dart';
import 'package:admin/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:provider/provider.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  static const _pageSize = 33;

  final PagingController<int, ContactModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  ContactProvider contactProvider;
  Future<void> _fetchPage(int pageKey) async {
    try {
      contactProvider = Provider.of<ContactProvider>(context, listen: false);
      final newItems = await contactProvider.fetchContacts(pageKey, 10);
      print(
          "newItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems.lengthnewItems");
      print(newItems.length);
      print(_pageSize);
      print(
          "_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize_pageSize");
      final isLastPage = newItems.length >= _pageSize;
      if (isLastPage) {
        print("Its last page");
        _pagingController.appendLastPage(newItems);
      } else {
        print("ITs not last page");
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      print(s);
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us Request"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/images/notification.png"),
            onPressed: () {
              Navigator.pushNamed(context, NotificationPage.routeName);
            },
          )
        ],
        leading: showAppBarNodepad(context)
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, ContactModel>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ContactModel>(
            itemBuilder: (context, item, index) => _contactItemBuilder(
              context,
              item,
            ),
          ),
        ),
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
                  "${contact.username}",
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 5),
                Text(
                  "${contact.email}",
                ),
                SizedBox(height: 5),
                Text("${contact.restaurant ?? "All resturant"}"),
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
