import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';

import '/src/navigation.dart';
import '/src/styles.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);

// Singleton to retain information about the audio player
class PlayerInfo {
  AudioPlayer player = AudioPlayer();
  Duration songLength = const Duration(seconds: 12);
  Duration currentTime = Duration.zero;
  double playbackSpeed = -1; // Is changed to 1 on initial run
  bool isPlaying = false;
  String assetPath = 'sounds/demoSong.mp3';
  int bpm = 100;

  Metadata metaData =
      const Metadata(trackName: 'Demo Song', trackArtistNames: ['David Tam']);

  PlayerInfo._internal();
  static final PlayerInfo _instance = PlayerInfo._internal();
}

class Playback extends StatefulWidget {
  @override
  PlaybackState createState() => PlaybackState();
}

class PlaybackState extends State<Playback> {
  final _playerInfo = PlayerInfo._instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // These actions occur only on the first load
    if (_playerInfo.playbackSpeed == -1) {
      _playerInfo.playbackSpeed = 1;

      // Set default song
      _playerInfo.player.setReleaseMode(ReleaseMode.stop);
      _playerInfo.player.setSource(AssetSource(_playerInfo.assetPath));
    }

    // Listeners for changes in player states
    _playerInfo.player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerInfo.isPlaying = state == PlayerState.playing;
      });
    });

    _playerInfo.player.onDurationChanged.listen((newSongLength) {
      setState(() {
        _playerInfo.songLength = newSongLength;
      });
    });

    _playerInfo.player.onPositionChanged.listen((newCurrentTime) {
      setState(() {
        if (_playerInfo.isPlaying) {
          _playerInfo.currentTime = newCurrentTime;
        }
      });
    });
  }

  // Load file from device and set audio player source
  void loadFile(FilePickerResult result) async {
    File file = File(result.files.first.path!.toString());
    _playerInfo.player.setSource(DeviceFileSource(file.path));

    // Gather metadata from mp3
    _playerInfo.metaData = await MetadataRetriever.fromFile(file);
  }

  @override
  Widget build(BuildContext context) {
    SizeManager size = SizeManager(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Container(
            color: background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: size.width < size.height
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.titlePadding, top: size.titlePadding),
                      child: Text(
                        'Playback',
                        style: titleText(size.barFont),
                      ),
                    ),
                    const SizedBox(width: 0, height: 0),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.titlePadding, right: size.titlePadding),
                      child: IconButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['mp3']);

                            // Load file if a proper file is chosen
                            if (result != null) {
                              loadFile(result);
                            }

                            setState(() {});
                          },
                          icon: Icon(
                            LucideIcons.copyPlus,
                            size: size.iconSize,
                            color: foreground,
                          )),
                    ),
                  ],
                ),
                // Load image info from metadata or load default image
                Padding(
                  padding: EdgeInsets.only(
                      left: size.titlePadding,
                      top: size.smallBox,
                      bottom: size.smallBox),
                  child: _playerInfo.metaData.albumArt != null
                      ? Image.memory(_playerInfo.metaData.albumArt!,
                          height: size.imageSize, width: size.imageSize)
                      : Image.asset('assets/images/logo.png',
                          height: size.imageSize, width: size.imageSize),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.titlePadding),
                  child: Text('${_playerInfo.metaData.trackName}',
                      style: songText(size.songSize),
                      textAlign: TextAlign.left),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.titlePadding),
                  child: Text(
                    _playerInfo.metaData.trackArtistNames.toString().substring(
                        1,
                        _playerInfo.metaData.trackArtistNames
                                .toString()
                                .length -
                            1),
                    style: artistText(size.artistSize),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.smallBox,
                      left: size.sliderPadding,
                      right: size.sliderPadding),
                  child: Slider(
                    min: 0,
                    max: _playerInfo.songLength.inSeconds.toDouble(),
                    value: _playerInfo.currentTime.inSeconds.toDouble(),
                    onChanged: (value) {
                      _playerInfo.currentTime =
                          Duration(seconds: value.toInt());
                      _playerInfo.player.pause();
                      _playerInfo.player.seek(_playerInfo.currentTime);
                      setState(() {});
                    },
                    activeColor: foreground,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.titlePadding, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(_playerInfo.currentTime),
                        style: timeText(size.artistSize),
                      ),
                      Text(
                        formatTime(_playerInfo.songLength),
                        style: timeText(size.artistSize),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 0, height: 0),
                    IconButton(
                      icon: Icon(
                        LucideIcons.rewind,
                        size: size.playButtonSize,
                        color: foreground,
                      ),
                      onPressed: () {
                        _playerInfo.currentTime = _playerInfo.currentTime -
                            const Duration(seconds: 10);
                        if (_playerInfo.currentTime.inSeconds < 0) {
                          _playerInfo.currentTime = Duration.zero;
                        }
                        _playerInfo.player.seek(_playerInfo.currentTime);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          _playerInfo.isPlaying
                              ? LucideIcons.pause
                              : LucideIcons.play,
                          color: foreground),
                      iconSize: size.playButtonSize,
                      onPressed: () {
                        if (_playerInfo.isPlaying) {
                          setState(() {
                            _playerInfo.player.pause();
                          });
                        } else {
                          setState(() {
                            _playerInfo.player.resume();
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.fastForward,
                          size: size.playButtonSize, color: foreground),
                      onPressed: () {
                        _playerInfo.currentTime = _playerInfo.currentTime +
                            const Duration(seconds: 10);
                        if (_playerInfo.currentTime > _playerInfo.songLength) {
                          _playerInfo.currentTime = _playerInfo.songLength;
                        }
                        _playerInfo.player.seek(_playerInfo.currentTime);
                      },
                    ),
                    const SizedBox(width: 0, height: 0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SliderTheme(
                            data: const SliderThemeData(
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 5),
                            ),
                            child: Slider(
                              min: 0.5,
                              max: 1.5,
                              value: _playerInfo.playbackSpeed,
                              onChanged: (value) {
                                _playerInfo.playbackSpeed =
                                    double.parse(value.toStringAsFixed(2));
                                _playerInfo.player
                                    .setPlaybackRate(_playerInfo.playbackSpeed);
                                setState(() {});
                              },
                              activeColor: foreground,
                            ),
                          ),
                          Text(
                            'Speed: ${_playerInfo.playbackSpeed}x',
                            style: timeText(size.buttonFont),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyNavBar(index: 2),
    );
  }

  String formatTime(Duration duration) {
    // Format single integers to 2 digits long (i.e. 02)
    String formatDigits(int n) => n.toString().padLeft(2, '0');

    final hours = formatDigits(duration.inHours);
    final minutes = formatDigits(duration.inMinutes);
    final seconds = formatDigits(
        duration.inSeconds - 60 * (duration.inSeconds / 60).floor());

    List<String> time = [];

    if (duration.inHours > 0) {
      time.add(hours);
    }

    time.add(minutes);
    time.add(seconds);
    return time.join(':');
  }
}
