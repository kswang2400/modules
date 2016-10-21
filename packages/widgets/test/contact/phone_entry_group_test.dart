// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/contact.dart';
import 'package:widgets/contact.dart';

void main() {
  testWidgets(
      'Test to see if tapping on the call, text, email'
      'buttons will call the appropiate callbacks',
      (WidgetTester tester) async {
    List<PhoneEntry> phoneEntries = <PhoneEntry>[
      new PhoneEntry(
        label: 'Work',
        number: '13371337',
      ),
      new PhoneEntry(
        label: 'Home',
        number: '10101010',
      ),
    ];

    int workPhoneTaps = 0;

    await tester.pumpWidget(new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return new Material(
        child: new PhoneEntryGroup(
          phoneEntries: phoneEntries,
          onSelectPhoneEntry: (PhoneEntry phone) {
            workPhoneTaps++;
            expect(phone, phoneEntries[0]);
          },
        ),
      );
    }));

    expect(workPhoneTaps, 0);
    await tester.tap(find.text('Work'));
    expect(workPhoneTaps, 1);
  });
}
