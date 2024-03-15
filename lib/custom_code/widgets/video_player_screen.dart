// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://tekeye.uk/html/images/Joren_Falls_Izu_Jap.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller),
                    Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                        child: IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 64,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // _buildPlayPauseButton(),
                    _buildFullScreenButton(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Slider(
      value: _controller.value.position.inMilliseconds.toDouble(),
      min: 0.0,
      max: _controller.value.duration!.inMilliseconds.toDouble(),
      onChanged: (value) {
        setState(() {
          _controller.seekTo(Duration(milliseconds: value.toInt()));
        });
      },
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      icon: Icon(
        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
        size: 32,
      ),
      onPressed: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
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
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FullScreenVideoScreen(controller: _controller),
          ),
        ).then((value) {
          setState(() {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          });
        });
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
          formatDuration(_controller.value.position),
          style: TextStyle(color: Colors.white),
        ),
        Text(
          '/',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          formatDuration(_controller.value.duration!),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
