// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;
  const FullScreenVideoScreen(
      {super.key, this.width, this.height, required this.controller});

  final double? width;
  final double? height;

  @override
  State<FullScreenVideoScreen> createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (mounted) {
      setState(() {
        // Update state here
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Full Screen')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
                    }
                  });
                },
                child: Stack(
                  children: [
                    VideoPlayer(widget.controller),
                    Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: widget.controller.value.isPlaying ? 0.0 : 1.0,
                        child: IconButton(
                          icon: Icon(
                            widget.controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 64,
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.controller.value.isPlaying) {
                                widget.controller.pause();
                              } else {
                                widget.controller.play();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    _buildControlsOverlay(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return '$twoDigitMinutes:$twoDigitSeconds';
    }

    return AnimatedOpacity(
      opacity: widget.controller.value.isPlaying ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        color: Colors.black26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                _buildVideoInfo(),
                Expanded(child: _buildProgressBar()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildPlayPauseButton(),
                _buildFullScreenButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Slider(
      value: widget.controller.value.position.inMilliseconds.toDouble(),
      min: 0.0,
      max: widget.controller.value.duration!.inMilliseconds.toDouble(),
      onChanged: (value) {
        setState(() {
          widget.controller.seekTo(Duration(milliseconds: value.toInt()));
        });
      },
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      icon: Icon(
        widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
        size: 32,
      ),
      onPressed: () {
        setState(() {
          if (widget.controller.value.isPlaying) {
            widget.controller.pause();
          } else {
            widget.controller.play();
          }
        });
      },
    );
  }

  Widget _buildFullScreenButton() {
    return IconButton(
      icon: Icon(
        Icons.fullscreen,
        color: Colors.white,
        size: 32,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildVideoInfo() {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return '$twoDigitMinutes:$twoDigitSeconds';
    }

    return Row(
      children: [
        Text(
          formatDuration(widget.controller.value.position),
          style: TextStyle(color: Colors.white),
        ),
        Text(
          '/',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          formatDuration(widget.controller.value.duration!),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
