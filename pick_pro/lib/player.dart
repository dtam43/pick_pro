import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_pro/main.dart';
import 'package:pick_pro/metronome.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:io';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

final TextEditingController _controller = TextEditingController();
final TextEditingController _speedController = TextEditingController();
final TextEditingController _hintController = TextEditingController();

class Playback extends StatefulWidget {
  @override
  PlaybackState createState() => PlaybackState();
}

class PlaybackState extends State<Playback> {
  final player = AudioPlayer();

  Metadata metaData = Metadata(
      trackName: 'Demo Song',
      trackArtistNames: ['David Tam'],
      albumArt: Uint8List(128));
  late Duration songLength;
  Duration currentTime = Duration.zero;
  double playbackSpeed = 1;
  String assetPath = 'sounds/demoSong.mp3';
  bool isPlaying = false;
  int bpm = 100;

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    player.setReleaseMode(ReleaseMode.stop);

    player.setSourceAsset(assetPath);

    // Set defualt song
    player.setSource(AssetSource(assetPath));
    songLength = const Duration(seconds: 259);

    loadMetaData(File(assetPath));

    // Listeners for changes in player states
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newSongLength) {
      setState(() {
        songLength = newSongLength;
      });
    });

    player.onPositionChanged.listen((newCurrentTime) {
      setState(() {
        if (isPlaying) {
          currentTime = newCurrentTime;
        }
      });
    });
  }

  // Load file from device and set audio player source
  void loadFile(FilePickerResult result) async {
    File file = File(result.files.first.path!.toString());
    player.setSource(DeviceFileSource(file.path));

    // Gather metadata from mp3
    loadMetaData(file);
  }

  // Loading meta data from mp3
  void loadMetaData(File file) async {
    metaData = await MetadataRetriever.fromFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PickPro',
          style: TextStyle(
            fontSize: 32.0,
            fontFamily: 'Caveat',
          ),
        ),
        centerTitle: true,
        backgroundColor: blueGreen,
      ),
      body: Container(
        color: darkBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: buttonStyle(),
              // Open file picking menu
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['mp3']);

                // Load file if a proper file is chosen
                if (result != null) {
                  loadFile(result);
                }

                setState(() {});
              },
              child: Text(
                "Import Media",
                style: buttonText(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Image.memory(metaData.albumArt!, height: 256, width: 256),
            const SizedBox(height: 5),
            Text('${metaData.trackName}', style: buttonText()),
            Text(
                '${metaData.trackArtistNames.toString().substring(1, metaData.trackArtistNames.toString().length - 1)}',
                style: buttonText()),
            const SizedBox(height: 5),
            Slider(
                min: 0,
                max: songLength.inSeconds.toDouble(),
                value: currentTime.inSeconds.toDouble(),
                onChanged: (value) {
                  currentTime = Duration(seconds: value.toInt());
                  setState(() {
                    player.pause();
                    player.seek(currentTime);
                  });
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(currentTime),
                    style: buttonText(),
                  ),
                  Text(
                    formatTime(songLength),
                    style: buttonText(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('-10', style: buttonText()),
                  style: buttonStyle(),
                  onPressed: () {
                    currentTime = currentTime - Duration(seconds: 10);
                    if (currentTime.inSeconds < 0) currentTime = Duration.zero;
                    player.seek(currentTime);
                  },
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white),
                  iconSize: 50,
                  onPressed: () {
                    if (isPlaying) {
                      setState(() {
                        player.pause();
                      });
                    } else {
                      setState(() {
                        player.resume();
                        print(formatTime(currentTime));
                      });
                    }
                  },
                ),
                TextButton(
                  child: Text('+10', style: buttonText()),
                  style: buttonStyle(),
                  onPressed: () {
                    currentTime = currentTime + Duration(seconds: 10);
                    if (currentTime > songLength) currentTime = songLength;
                    player.seek(currentTime);
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            Slider(
                min: 0.5,
                max: 1.5,
                value: playbackSpeed,
                onChanged: (value) {
                  playbackSpeed = double.parse(value.toStringAsFixed(2));
                  player.pause();
                  player.setPlaybackRate(playbackSpeed);
                  setState(() {});
                }),
            Center(
              child: Text(
                'Speed: ${playbackSpeed}x',
                style: buttonText(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 80,
                        height: 15,
                        child: TextField(
                            textAlign: TextAlign.center,
                            controller: _hintController,
                            enabled: false,
                            decoration: const InputDecoration(
                                hintText: 'Song BPM:',
                                hintStyle:
                                    TextStyle(color: blueGreen, fontSize: 14),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero),
                            cursorColor: Colors.white,
                            onSubmitted: (String value) {})),
                    SizedBox(
                      width: 60.0,
                      height: 15.0,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: blueGreen,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                            hintText: '${bpm}',
                            hintStyle:
                                const TextStyle(color: blueGreen, fontSize: 14),
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero),
                        cursorColor: Colors.white,
                        onSubmitted: (String value) {
                          _controller.clear();
                          try {
                            bpm = int.parse(value);
                            setState(() {});
                          } catch (e) {
                            ErrorPopup.show(
                                context, "The BPM you entered is invalid.");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 90,
                        height: 15,
                        child: TextField(
                            textAlign: TextAlign.center,
                            controller: _hintController,
                            enabled: false,
                            decoration: const InputDecoration(
                                hintText: 'Desired BPM:',
                                hintStyle:
                                    TextStyle(color: blueGreen, fontSize: 14),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero),
                            cursorColor: Colors.white,
                            onSubmitted: (String value) {})),
                    SizedBox(
                      width: 60.0,
                      height: 15.0,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _speedController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: blueGreen,
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                            hintText: '${bpm * playbackSpeed}',
                            hintStyle:
                                TextStyle(color: blueGreen, fontSize: 14),
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero),
                        cursorColor: Colors.white,
                        onSubmitted: (String value) {
                          _controller.clear();
                          try {
                            int newBPM = int.parse(value);
                            playbackSpeed =
                                double.parse((newBPM / bpm).toStringAsFixed(2));
                            player.pause();
                            player.setPlaybackRate(playbackSpeed);
                            setState(() {});
                          } catch (e) {
                            ErrorPopup.show(
                                context, "The BPM you entered is invalid.");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: MyDrawer(index: 3),
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
