import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

bool isPlaying = false;
int bpm = 100;
int interval = 1000 ~/ (bpm / 60);

final TextEditingController _controller = TextEditingController();
late AudioPlayer player;

bool getPlaying() => isPlaying;
Timer timer = Timer.periodic(Duration(milliseconds: 0), (Timer t) {});

class Metronome extends StatefulWidget {
  @override
  _MetronomeState createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome> {
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setAsset('assets/sounds/metronome.mp3');
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  void start() {
    interval = 1000 ~/ (bpm / 60);

    timer = Timer.periodic(Duration(milliseconds: interval), onTick);

    setState(() {});
  }

  void onTick(Timer t) {
    player.seek(Duration.zero);
    player.play();
  }

  void stop() {
    timer.cancel();
    player.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PickPro',
          style: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Caveat',
          ),
        ),
        centerTitle: true,
        backgroundColor: blueGreen,
      ),
      body: Container(
        color: darkBlue,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: bpm.toString(),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 224, 224, 224),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (String value) {
                      int number = int.parse(value);
                      if (number != null) {
                        bpm = number;
                        setState(() {});
                      }
                    },
                  ),
                ),
                Image.asset(
                  'assets/images/guitar.png',
                  fit: BoxFit.cover,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(blueGreen),
                    overlayColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 47, 147, 122)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(30)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      start();
                    } else {
                      stop();
                    }
                  },
                  child: Text(
                    getPlaying() ? 'Stop' : 'Play',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
