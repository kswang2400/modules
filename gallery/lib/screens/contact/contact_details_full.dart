// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:models/contact.dart';
import 'package:models/user.dart';
import 'package:widgets/contact.dart';

/// Full contact details page
class ContactDetailsFullScreen extends StatelessWidget {
  /// Creates a [ContactDetailsFullScreen] instance.
  ContactDetailsFullScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ContactDetailsFull(
      contact: new Contact(
        user: new User(
          name: 'Coco Yang',
          email: 'coco@cu.te',
          familyName: 'Yang',
          givenName: 'Coco',
          picture:
              'https://raw.githubusercontent.com/dvdwasibi/DogsOfFuchsia/master/coco.jpg',
        ),
        addresses: <AddressEntry>[
          new AddressEntry(
            city: 'Mountain View',
            region: 'CA',
          )
        ],
        emails: <EmailEntry>[
          new EmailEntry(
            label: 'Work',
            value: 'coco@cu.te',
          ),
        ],
        phoneNumbers: <PhoneEntry>[
          new PhoneEntry(
            label: 'Work',
            number: '13371337',
          ),
        ],
      ),
    );
  }
}
