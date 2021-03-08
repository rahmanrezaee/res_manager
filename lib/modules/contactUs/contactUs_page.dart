import 'package:admin/modules/contactUs/model/contact_model.dart';
import 'package:admin/modules/contactUs/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Scaffold(
        body: Consumer<ContactProvider>(
            builder: (context, contactProvider, child) {
          contactProvider.fetchContacts();
          return contactProvider.getContacts == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: contactProvider.getContacts.length,
                  itemBuilder: (context, i) {
                    return ContactItem(contactProvider.getContacts[0]);
                  },
                );
        }),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final ContactModel contact;

  ContactItem(this.contact);
  @override
  Widget build(BuildContext context) {
    print(contact.email);
    try {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.username,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 5),
              Text(contact.email),
              SizedBox(height: 5),
              Text(contact.restaurant),
              SizedBox(height: 5),
              Text(contact.subject),
              SizedBox(height: 5),
              Text(
                contact.message,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    } catch (e, s) {
      print(s);
      return Text("Error Accured");
    }
  }
}
