import 'package:contacts_service/contacts_service.dart';

enum SaveContactStatus {
  OK,
  ERROR,
  EXIST,
}

class SaveContactFromVCARD {
  String vcard;
  Contact contact = Contact();

  static initializeDefault(String vcard) async {
    return await SaveContactFromVCARD(vcard)._execute();
  }

  // static initialize(String vcard, var locationApi) async {
  //   return await SearchLocationFromDirection(text, locationApi)._execute();
  // }

  SaveContactFromVCARD(vcard) {
    this.vcard = vcard;
  }

  _execute() async {
    List<String> elements = this.vcard.split('\n');

    elements.forEach((String element) {
      if (element != 'BEGIN:VCARD' &&
          element != 'VERSION:3.0' &&
          !element.contains('FN:') &&
          element != 'END:VCARD') {
        if (element.contains('N:')) {
          List<String> fullname = element.replaceAll('N:', '').split(';');
          this.contact.familyName = fullname[0];
          this.contact.givenName = fullname[1];
        } else if (element.contains('EMAIL')) {
          List<String> email = element.split(':');
          this.contact.emails = [
            Item(label: "personal", value: email[email.length - 1])
          ];
        } else if (element.contains('TEL')) {
          List<String> phone = element.split(':');
          this.contact.phones = [
            Item(label: "personal", value: phone[phone.length - 1])
          ];
        } else if (element.contains('ORG')) {
          this.contact.company = element.split(':')[1];
        } else if (element.contains('TITLE')) {
          this.contact.jobTitle = element.split(':')[1];
        }
      }
    });

    ContactsService.addContact(this.contact).catchError((e) {
      print(e);
      return SaveContactStatus.ERROR;
    });
    return SaveContactStatus.OK;
  }
}
