// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/email/message.dart';
import 'package:widgets/email/message_content.dart';
import 'package:widgets/email/message_list_item.dart';

void main() {
  String profileUrl =
      'https://raw.githubusercontent.com/dvdwasibi/DogsOfFuchsia/master/coco.jpg';
  testWidgets(
      'Test to see if tapping the header for a MessageListItem will call the'
      'appropiate callback with given Message', (WidgetTester tester) async {
    Message message = new Message(
      sender: 'Coco Yang',
      recipientList: <String>['David Yang'],
      senderProfileUrl: profileUrl,
      subject: 'Feed Me!!!',
      text: "Woof Woof. I'm so hungry. You need to feed me!",
      timestamp: new DateTime.now(),
      isRead: true,
    );

    int taps = 0;

    await tester.pumpWidget(new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return new Material(
        child: new MessageListItem(
          message: message,
          onForward: (Message m) {},
          onReply: (Message m) {},
          onReplyAll: (Message m) {},
          onHeaderTap: (Message m) {
            expect(m, message);
            taps++;
          },
        ),
      );
    }));

    expect(taps, 0);
    await tester.tap(find.byType(ListItem));
    expect(taps, 1);
  });

  testWidgets(
      'Test to see if the MessageContent is not shown if a MessageListItem'
      'is not expanded', (WidgetTester tester) async {
    Message message = new Message(
      sender: 'Coco Yang',
      recipientList: <String>['David Yang'],
      senderProfileUrl: profileUrl,
      subject: 'Feed Me!!!',
      text: "Woof Woof. I'm so hungry. You need to feed me!",
      timestamp: new DateTime.now(),
      isRead: true,
    );

    await tester.pumpWidget(new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return new Material(
        child: new MessageListItem(
          message: message,
          onForward: (Message m) {},
          onReply: (Message m) {},
          onReplyAll: (Message m) {},
          isExpanded: false,
        ),
      );
    }));

    expect(find.byType(MessageContent), findsNothing);
  });

  testWidgets(
      'Test to see if the MessageContent is shown if a MessageListItem'
      'is expanded', (WidgetTester tester) async {
    Message message = new Message(
      sender: 'Coco Yang',
      recipientList: <String>['David Yang'],
      senderProfileUrl: profileUrl,
      subject: 'Feed Me!!!',
      text: "Woof Woof. I'm so hungry. You need to feed me!",
      timestamp: new DateTime.now(),
      isRead: true,
    );

    await tester.pumpWidget(new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return new Material(
        child: new MessageListItem(
          message: message,
          onForward: (Message m) {},
          onReply: (Message m) {},
          onReplyAll: (Message m) {},
          isExpanded: true,
        ),
      );
    }));

    expect(find.byType(MessageContent), findsOneWidget);
  });

  testWidgets(
      'Test to see if tapping REPLY in the quick actions popup-menu '
      'will call the appropiate callback with given Message',
      (WidgetTester tester) async {
    Message message = new Message(
      sender: 'Coco Yang',
      recipientList: <String>['David Yang'],
      senderProfileUrl: profileUrl,
      subject: 'Feed Me!!!',
      text: "Woof Woof. I'm so hungry. You need to feed me!",
      timestamp: new DateTime.now(),
      isRead: true,
    );

    int taps = 0;

    await tester.pumpWidget(new StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return new MaterialApp(
          routes: <String, WidgetBuilder> {
            '/next': (BuildContext context) {
              return new Text('Next');
            }
          },
          home: new Material(
            child:  new MessageListItem(
              message: message,
              onForward: (Message m) {},
              onReply: (Message m) {
                // debugPrintStack(label: 'tap!!');
                expect(m, message);
                taps++;
                expect(taps, 1);
                print(taps);
              },
              onReplyAll: (Message m) {},
              isExpanded: true,
            ),
          ),
        );
    }));

    expect(taps, 0);
    // Open Popup Menu
    await tester.tap(find.byWidgetPredicate(
        (Widget widget) => widget is Icon && widget.icon == Icons.more_vert));
    // finish the menu animation
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Reply'), findsOneWidget);
    await tester.tap(find.text('Reply'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    print("final result: $taps");
    expect(taps, 1);
  });
}
