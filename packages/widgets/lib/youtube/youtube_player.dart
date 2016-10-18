// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Represents a module that can play Youtube videos.
///
/// Since there is no video support for Flutter, this widget just shows a
/// slideshow of thumbnails for the video.
class YoutubePlayer extends StatefulWidget {

  /// Youtube video ID of specific video
  String videoId;

  /// Constructor
  YoutubePlayer({
    Key key,
    @required this.videoId,
  }) : super(key: key) {
    assert(videoId != null);
  }

  @override
  _YoutubePlayerState createState() => new _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {

  /// Flag for whether the video is playing or not
  bool _playing = false;

  /// The play overlay that extends
  bool _showPlayOverlay = true;

  /// Track the current thumbnail that is being shown
  /// Youtube provides 4 thumbnails (0,1,2,3)
  int _thumbnailIndex = 0;

  const Duration _kSlideDuration = const Duration(seconds:1);


  void _togglePlay() {
    setState(() {
      _playing = !_playing;
    });
  }

  void _play() {
    // do timer stuff here
    return new T
  }

  String _getCurrentThumbnailURL() {
    return 'http://img.youtube.com/vi/${config.videoId}/$_thumbnailIndex.jpg';
  }

  /// Overlay widget that contains playback controls
  Widget _buildControlOverlay() {

    return new Container(
      decoration: new BoxDecoration(
        gradient: new RadialGradient(
          center: FractionalOffset.center,
          colors: <Color>[
            const Color.fromRGBO(0, 0, 0, 0.1),
            const Color.fromRGBO(0, 0, 0, 0.7),
            const Color.fromRGBO(0, 0, 0, 1.0),
          ],
          stops: <double>[
            0.0,
            0.7,
            1.0,
          ],
          radius: 1.0,
        ),
      ),
      child: new Material(
        color: const Color.fromRGBO(0, 0, 0, 0.0),
        child: new Center(
          child: new IconButton(
            icon: new Icon(Icons.play_arrow),
            size: 60.0,
            onPressed: _togglePlay,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 250.0,
      height: 250.0,
      child: new Stack(
        children: <Widget>[
          new Image.network(
            _getCurrentThumbnailURL(),
            gaplessPlayback: true,
            fit: ImageFit.cover,
            width: 250.0,
            height: 250.0,
          ),
          new Offstage(
            offstage: !_showPlayOverlay,
            child: _buildControlOverlay(),
          ),
        ],
      ),
    );
  }
}
