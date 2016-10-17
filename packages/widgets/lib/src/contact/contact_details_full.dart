// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:models/contact.dart';

import '../user/alphatar.dart';
import 'type_defs.dart';

const String _kDefaultBackgroundImage =
    'https://static.pexels.com/photos/2042/sea-city-mountains-landmark.jpg';

/// Full Contact Details designed to take up much of the screen.
class ContactDetailsFull extends StatelessWidget {
  /// Size (radius) of alphatar in Contact Detail
  double alphatarSize;

  /// User [Contact] that is being rendered
  Contact contact;

  /// Height of header where background image is shown
  double headerHeight;

  /// Callback when given phone entry is selected for a call
  PhoneActionCallback onCallPhone;

  /// Callback when given phone entry is selected for a text message
  PhoneActionCallback onTextPhone;

  /// Callback when given email entry is selected
  EmailActionCallback onSendEmail;

  /// Constructor
  ContactDetailsFull(
      {Key key,
      this.alphatarSize: 100.0,
      @required this.contact,
      this.headerHeight: 150.0,
      this.onCallPhone,
      this.onTextPhone,
      this.onSendEmail})
      : super(key: key) {
    assert(contact != null);
  }

  void _handleCallPhone(PhoneEntry phoneEntry) {
    if (onCallPhone != null) {
      onCallPhone(phoneEntry);
    }
  }

  void _handleTextPhone(PhoneEntry phoneEntry) {
    if (onTextPhone != null) {
      onTextPhone(phoneEntry);
    }
  }

  void _handleSendEmail(EmailEntry emailEntry) {
    if (onSendEmail != null) {
      onSendEmail(emailEntry);
    }
  }

  /// Build background image
  Widget _buildBackgroundImage() {
    return new Container(
      height: headerHeight,
      decoration: new BoxDecoration(
        backgroundImage: new BackgroundImage(
          image: contact.backgroundImageUrl != null
              ? new NetworkImage(contact.backgroundImageUrl)
              : new NetworkImage(_kDefaultBackgroundImage),
          fit: ImageFit.cover,
          //TODO(dayang): Leverage ThemeData so that the color theme will
          // change the highlights for UI elements and also change the color
          // filter on the background.
          // https://fuchsia.atlassian.net/browse/SO-43
          colorFilter: new ColorFilter.mode(
            Colors.orange[300].withAlpha(30),
            TransferMode.color,
          ),
        ),
      ),
    );
  }

  /// Build single quick action button
  Widget _buildQuickActionButton({
    IconData icon,
    VoidCallback onPressed,
    bool disabled,
    String label,
  }) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Material(
            type: MaterialType.circle,
            color: Colors.grey[200],
            child: new Container(
              padding: const EdgeInsets.all(4.0),
              child: new IconButton(
                size: 32.0,
                color: Colors.orange[700],
                icon: new Icon(icon),
                onPressed: disabled ? null : onPressed,
              ),
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(top: 4.0),
            child: new Text(
              label,
              style: new TextStyle(
                color: Colors.grey[400],
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Action Buttons (Call, Message, Email)
  Widget _buildQuickActionButtonRow() {
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildQuickActionButton(
            icon: Icons.phone,
            onPressed: () => _handleCallPhone(contact.primaryPhoneNumber),
            disabled: contact.primaryPhoneNumber == null,
            label: 'Call',
          ),
          _buildQuickActionButton(
            icon: Icons.message,
            onPressed: () => _handleTextPhone(contact.primaryPhoneNumber),
            disabled: contact.primaryPhoneNumber == null,
            label: 'Message',
          ),
          _buildQuickActionButton(
            icon: Icons.email,
            onPressed: () => _handleSendEmail(contact.primaryEmail),
            disabled: contact.primaryEmail == null,
            label: 'Email',
          ),
        ],
      ),
    );
  }

  Widget _buildNameHeader() {
    List<Widget> children = <Widget>[
      new Text(
        contact.user.name,
        style: new TextStyle(
          fontSize: 16.0,
        ),
      ),
    ];

    if (contact.regionPreview != null) {
      children.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.place,
              size: 14.0,
            ),
            new Text(
              contact.regionPreview,
            ),
          ],
        ),
      );
    }

    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: new Center(
        child: new Column(
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CustomMultiChildLayout(
      delegate: new _ContactLayoutDelegate(
        alphatarSize: alphatarSize,
        headerHeight: headerHeight,
      ),
      children: <Widget>[
        new LayoutId(
          id: _ContactLayoutDelegate.headerBackgroundId,
          child: _buildBackgroundImage(),
        ),
        new LayoutId(
          id: _ContactLayoutDelegate.contentId,
          child: new Container(
            padding: new EdgeInsets.only(
              top: alphatarSize / 2.0,
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildNameHeader(),
                _buildQuickActionButtonRow(),
              ],
            ),
          ),
        ),
        new LayoutId(
          id: _ContactLayoutDelegate.alphatarId,
          child: new Container(
            padding: const EdgeInsets.all(1.0),
            decoration: new BoxDecoration(
              backgroundColor: Colors.orange[700],
              shape: BoxShape.circle,
            ),
            child: new Alphatar.withUrl(
              avatarUrl: contact.user.picture,
              size: alphatarSize,
              letter: contact.user.name[0],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactLayoutDelegate extends MultiChildLayoutDelegate {
  final double alphatarSize;
  final double headerHeight;

  static final String headerBackgroundId = 'headerBackground';
  static final String alphatarId = 'alphatar';
  static final String contentId = 'content';

  _ContactLayoutDelegate(
      {@required this.alphatarSize, @required this.headerHeight});

  @override
  void performLayout(Size size) {
    // Height is fixed for background.
    // Width should stretch out to the parent
    Size headerBackgroundSize = layoutChild(
      headerBackgroundId,
      new BoxConstraints.tightForFinite(
        height: headerHeight,
        width: size.width,
      ),
    );

    // Fixed size for Alphatar
    Size alphatarSize = layoutChild(
      alphatarId,
      new BoxConstraints.tightFor(
        width: this.alphatarSize,
        height: this.alphatarSize,
      ),
    );

    // Content should stretch out to the rest of the parent
    layoutChild(
      contentId,
      new BoxConstraints.tightFor(
        height: size.height - headerHeight,
        width: size.width,
      ),
    );

    positionChild(headerBackgroundId, Offset.zero);
    positionChild(contentId, new Offset(0.0, headerBackgroundSize.height));
    positionChild(
      alphatarId,
      new Offset(
        headerBackgroundSize.width / 2.0 - alphatarSize.width / 2.0,
        headerBackgroundSize.height - alphatarSize.width / 2.0,
      ),
    );
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
