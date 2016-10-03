// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Playground for testing animations
class AnimationScreen extends StatefulWidget {
  /// Creates a [AnimationScreen] instance.
  AnimationScreen({Key key}) : super(key: key);

  @override
  _AnimationScreenState createState() => new _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text('Email - Editor'),
      ),
      body: new Container(),
    );
  }
}
