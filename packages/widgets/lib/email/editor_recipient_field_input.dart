// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Callback type for updating the recipients of a new message
typedef void RecipientsChangedCallback(List<String> recipientList);

/// Google Inbox style 'recipient' field input.
// TODO(dayang): Recipients(users) are kept as String representation, but
// eventually, they should be objects/structs so that metadata such as
// the avatar picture and First/Last name can be kept. This probably might wait
// until the 'Contact Service/Module' gets fleshed out more.
class EditorRecipientFieldInput extends StatefulWidget {


  /// Callback function that is called everytime a new recipient is add or an
  /// existing recipient is removed. The updated recipient list is passed in
  /// as the callback parameter.
  RecipientsChangedCallback onRecipientsChanged;

  /// List of recipients. This is a copy of what is fed in.
  List<String> recipientList;

  /// Label for the recipient field. Ex. To, Cc Bcc...
  String inputLabel;

  /// Creates a [EditorRecipientFieldInput] instance
  EditorRecipientFieldInput({
    Key key,
    @required this.inputLabel,
    this.onRecipientsChanged,
    this.recipientList: const <String>[]
  }) : super(key: key) {
    assert(inputLabel != null);
  }

  @override
  _EditorRecipientFieldInputState createState() =>
          new _EditorRecipientFieldInputState();
}

class _EditorRecipientFieldInputState extends State<EditorRecipientFieldInput> {

  /// 'Working copy' of the recipient list.
  /// This is what is passed through in the onRecipientsChanged callback
  List<String> _recipientList;

  /// The 'in progress' text of the new recipient being composed in the input
  String newRecipient;

  @override
  void initState() {
    super.initState();
    newRecipient = '';
    _recipientList = new List<String>.from(config.recipientList);
  }

  void _handleInputChange(InputValue input) {
    // TODO(dayang): If current newRecipient text is a valid email address,
    // automatically add it to the recipientList.
    print(input.text);
    setState(() {
      newRecipient = input.text;
    });
  }

  void _handleInputSubmit(InputValue input) {
    // TODO(dayang): Actually to check to make sure that text input is a
    // email address.
    if(input.text.isNotEmpty) {
      setState(() {
        _recipientList.add(input.text);
        newRecipient = '';
        config.onRecipientsChanged(_recipientList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> rowChildren = <Widget>[
      new Flexible(
        flex: null,
        child: new Text(config.inputLabel),
      ),
    ];

    //render pre-existing recipients
    _recipientList.forEach((String recipient) {
      rowChildren.add(new Flexible(
        flex: null,
        child: new Chip(
          label: new Text(recipient),
        ),
      ));
    });

    //add text input
    rowChildren.add(new Flexible(
      flex: 1,
      child: new Input(
        onChanged: _handleInputChange,
        onSubmitted: _handleInputSubmit,
        value: new InputValue(text: newRecipient),
      ),
    ));

    return new Container(
      child: new Row(
        children: rowChildren,
      ),
    );
  }
}
