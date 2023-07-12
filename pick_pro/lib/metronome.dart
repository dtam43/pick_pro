import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

const Color darkBlue = Color(0xFF000c24);
Color blueGreen = const Color.fromARGB(255, 121, 207, 175);

// Tracking the condition of the metronome for animation
enum MetronomeIs { playing, stopped, stopping }

final TextEditingController _controller = TextEditingController();
late AudioPlayer player;

class Metronome extends StatefulWidget {
  @override
  MetronomeState createState() => MetronomeState();
}

class MetronomeState extends State<Metronome> {
  // Constraints on metronome speed and rotation
  final _maxAngle = 0.26;
  final _minTempo = 20;
  final _maxTempo = 240;

  int _bpm = 100;
  bool _bobPanning = false;

  // Preventing BPM editing during metronome playback
  bool _isLocked = false;

  // Variables for animation
  MetronomeIs _metronomeIs = MetronomeIs.stopped;
  int _lastFrameTime = 0;
  Timer _timer = Timer.periodic(const Duration(milliseconds: 0), (Timer t) {});
  Timer _frameTimer =
      Timer.periodic(const Duration(milliseconds: 0), (Timer t) {});
  int _lastEvenTick = 0;
  bool _lastTickWasEven = true;
  int _interval = 0;

  double _angle = 0;

  // Cancel timers when leaving page
  @override
  void dispose() {
    _timer.cancel();
    _frameTimer.cancel();
    super.dispose();
  }

  // Initialize audio player
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setAsset('assets/sounds/metronome.mp3');
  }

  // Method to start the metronome animation
  void _start() {
    _metronomeIs = MetronomeIs.playing;
    _interval = 1000 ~/ (_bpm / 60);

    _lastEvenTick = DateTime.now().millisecondsSinceEpoch;

    _timer = Timer.periodic(Duration(milliseconds: _interval), _onTick);
    _animate();

    // Play first metronome sound
    player.pause();
    player.seek(Duration.zero);
    player.play();

    // Lock text field
    _isLocked = true;

    setState(() {});
  }

  // Method to create the animation delay and timer
  void _animate() {
    _frameTimer.cancel();

    int frameTime = DateTime.now().millisecondsSinceEpoch;

    if (_metronomeIs == MetronomeIs.playing ||
        _metronomeIs == MetronomeIs.stopping) {
      int delay =
          max(0, _lastFrameTime + 17 - DateTime.now().millisecondsSinceEpoch);

      // Set timer for animation
      _frameTimer = Timer(Duration(milliseconds: delay), () {
        _animate();
      });
    } else {
      _angle = 0;
    }

    _lastFrameTime = frameTime;

    setState(() {});
  }

  // Method to play metronome sound on tick or cancel timer when stop is pressed
  void _onTick(Timer t) {
    // Tracking length since tick passed every other tick
    _lastTickWasEven = t.tick % 2 == 0;
    if (_lastTickWasEven) _lastEvenTick = DateTime.now().millisecondsSinceEpoch;

    // Playing sound
    if (_metronomeIs == MetronomeIs.playing) {
      player.pause();
      player.seek(Duration.zero);
      player.play();

      // Restting metronome to bring it to a stop
    } else if (_metronomeIs == MetronomeIs.stopping) {
      _timer.cancel();
      _frameTimer.cancel();
      _resetAnimation();
      _isLocked = false;
      _metronomeIs = MetronomeIs.stopped;
      setState(() {});
    }
  }

  // Method to signal _onTick to stop
  void _stop() {
    if (_metronomeIs == MetronomeIs.playing) {
      _metronomeIs = MetronomeIs.stopping;
    }
    player.stop();

    setState(() {});
  }

  // Method to reset animation values
  void _resetAnimation() {
    _metronomeIs = MetronomeIs.stopped;
    _lastFrameTime = 0;
    _lastEvenTick = 0;
    _lastTickWasEven = true;
  }

  // Method to get rotation angle of the pendulum
  double _getAngle() {
    double angle = 0.0;
    double segmentPercent;
    double begin;
    double end;
    Curve curve;

    int now = DateTime.now().millisecondsSinceEpoch;
    double rotatePercent = 0;

    if (_metronomeIs == MetronomeIs.playing ||
        _metronomeIs == MetronomeIs.stopping) {
      int timePassed = now - _lastEvenTick;

      // Reset time interval if tick animation is delayed
      if (timePassed > _interval * 2) {
        timePassed -= (_interval * 2);
      }

      rotatePercent = (timePassed).toDouble() / (_interval * 2);

      // Restricting rotation in case of extreme intervals
      if (rotatePercent < 0 || rotatePercent > 1) {
        rotatePercent = min(1, max(0, rotatePercent));
      }
    }

    // Customize curve and angles depending on the rotation needed
    if (rotatePercent < 0.25) {
      segmentPercent = rotatePercent * 4;
      begin = 0;
      end = _maxAngle;
      curve = Curves.easeOut;
    } else if (rotatePercent < 0.75) {
      segmentPercent = (rotatePercent - 0.25) * 2;
      begin = _maxAngle;
      end = -_maxAngle;
      curve = Curves.easeInOut;
    } else {
      segmentPercent = (rotatePercent - 0.75) * 4;
      begin = -_maxAngle;
      end = 0;
      curve = Curves.easeIn;
    }

    // The Curve Tween is used to create the pendulum-swinging curve
    CurveTween curveTween = CurveTween(curve: curve);
    double easedPercent = curveTween.transform(segmentPercent);

    Tween<double> tween = Tween<double>(begin: begin, end: end);
    angle = tween.transform(easedPercent);

    return angle;
  }

  // Handle Text Field input submissions
  void _submitted(String value) {
    try {
      int number = int.parse(value);

      // Ensure BPM is within acceptable range
      if (number < 20 || number > 240) {
        throw Error();
      }

      _bpm = number;
      setState(() {});

      // For invalid BPM inputs
    } catch (e) {
      ErrorPopup.show(context, "The BPM you entered is invalid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _angle = _getAngle();

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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(alignment: Alignment.center, children: <Widget>[
                Image.asset(
                  'assets/images/metronome.png',
                  fit: BoxFit.fill,
                  width: 800,
                  height: 1000,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: 60.0,
                    height: 30.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      enabled: !_isLocked,
                      style: TextStyle(
                        color: blueGreen,
                        fontSize: 24.0,
                      ),
                      decoration: InputDecoration(
                          hintText: _bpm.toString(),
                          hintStyle: TextStyle(color: blueGreen, fontSize: 24),
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
                        _submitted(value);
                      },
                    ),
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    return _stick(context, 400, 750);
                  }),
                ]),
              ]),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(blueGreen),
                  overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 47, 147, 122)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(30)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: _metronomeIs == MetronomeIs.stopping
                    ? null
                    : () {
                        _metronomeIs == MetronomeIs.stopped
                            ? _start()
                            : _stop();
                      },
                child: Text(
                  _metronomeIs == MetronomeIs.stopped ? 'Play' : 'Stop',
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to draw the metronome stick
  Widget _stick(BuildContext context, width, double height) {
    return SizedBox(
      width: width,
      height: height,

      // Gesture Detector to detect panning on the weight
      child: GestureDetector(
        // When weight is clicked or tapped, enable movement
        onPanDown: (dragDownDetails) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset localPosition =
              box.globalToLocal(dragDownDetails.globalPosition);
          if (_weightTapTest(width, height, localPosition)) _bobPanning = true;
        },

        // When weight is moved
        onPanUpdate: (dragUpdateDetails) {
          if (_bobPanning) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset localPosition =
                box.globalToLocal(dragUpdateDetails.globalPosition);

            // Update bpm value
            _weightDragged(width, height, localPosition);
          }
        },
        onPanEnd: (dragEndDetails) {
          _bobPanning = false;
        },
        onPanCancel: () {
          _bobPanning = false;
        },

        // Draw metronome
        child: CustomPaint(
          foregroundPainter: MetronomePainter(
              width: width,
              height: height,
              bpm: _bpm,
              minTempo: _minTempo,
              maxTempo: _maxTempo,
              angle: _angle),
          child: const InkWell(),
        ),
      ),
    );
  }

  // Method to test if the weight has been tapped
  bool _weightTapTest(double width, double height, Offset localPosition) {
    if (_metronomeIs != MetronomeIs.stopped) return false;

    // Compare local position to the previous stored weight coordinates
    Offset translatedLocalPos =
        localPosition.translate(-width / 2, -height * 0.75);
    PendulumCoords pendulumCoords =
        PendulumCoords(width, height, _bpm, _minTempo, _maxTempo);

    return ((translatedLocalPos.dy - pendulumCoords.bobCenter.dy).abs() <
        height / 20);
  }

  // Method to track the movement of the weight and update the bpm value
  void _weightDragged(double width, double height, Offset localPosition) {
    Offset translatedLocalPos =
        localPosition.translate(-width / 2, -height * 0.75);
    PendulumCoords pendulumCoords =
        PendulumCoords(width, height, _bpm, _minTempo, _maxTempo);

    double weightPos = (translatedLocalPos.dy - pendulumCoords.bobMinY) /
        pendulumCoords.bobTravel;

    // Determine new bpm based on relative weight position
    _bpm = min(
        _maxTempo,
        max(_minTempo,
            _minTempo + (weightPos * (_maxTempo - _minTempo)).toInt()));

    _interval = 1000 ~/ (_bpm / 60);
    setState(() {});
  }
}

// A class to store the coordinates of each element of the metronome stick based on bpm and size
class PendulumCoords {
  late Offset bobCenter;
  late Offset counterWeightCenter;
  late double counterWeightRadius;
  late Offset stickTop;
  late Offset stickBottom;
  late Offset rotationCenter;
  late double rotationCenterRadius;
  late double bobMinY;
  late double bobMaxY;
  late double bobTravel;

  PendulumCoords(
      double width, double height, int bpm, int minTempo, int maxTempo) {
    rotationCenter = Offset(0, 0);
    rotationCenterRadius = width / 45;

    counterWeightCenter = Offset(0, height * 0.175);
    counterWeightRadius = width / 20;

    stickTop = Offset(0, -height * 0.68);
    stickBottom = Offset(0, height * 0.175);

    double bobHeight = height / 15;
    bobMinY = stickTop.dy;
    bobMaxY = rotationCenter.dy - rotationCenterRadius - bobHeight / 2 - 2;
    bobTravel = bobMaxY - bobMinY;
    double bobPercent = (bpm - minTempo) / (maxTempo - minTempo);
    bobCenter = Offset(0, bobMinY + (bobTravel * bobPercent));
  }
}

// Class to paint the metronome using Canvas and Pictures
class MetronomePainter extends CustomPainter {
  late double width;
  late double height;
  late int bpm;
  late int minTempo;
  late int maxTempo;
  late double angle;

  static late ui.Picture stickPicture;

  late Map<String, Paint> paints;

  MetronomePainter({
    required double width,
    required double height,
    required int bpm,
    required int minTempo,
    required int maxTempo,
    required double angle,
  }) {
    this.width = width;
    this.height = height;
    this.bpm = bpm;
    this.minTempo = minTempo;
    this.maxTempo = maxTempo;
    this.angle = angle;

    // Initialize paints
    paints = {
      "stickColor": Paint()
        ..color = const Color.fromARGB(255, 211, 211, 211)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.02,
      "outlineColor": Paint()
        ..color = blueGreen
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.02,
      "fillWeight": Paint()
        ..color = blueGreen
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill,
      "fillRotationCenter": Paint()
        ..color = Colors.grey
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill,
      "fillBob": Paint()
        ..color = blueGreen
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill,
    };

    // Draw unrotated stick to a picture canvas
    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas pictureCanvas = Canvas(pictureRecorder);

    _drawStick(pictureCanvas);
    stickPicture = pictureRecorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(width / 2, height * .75);
    canvas.rotate(angle);
    canvas.drawPicture(stickPicture);
  }

  // Method to draw the stick
  _drawStick(Canvas canvas) {
    PendulumCoords pendulumCoords =
        PendulumCoords(width, height, bpm, minTempo, maxTempo);

    // Coordinates for drawing the trapezoid
    List<Offset> bobPoints = List<Offset>.from([
      Offset(pendulumCoords.bobCenter.dx + width / 20,
          pendulumCoords.bobCenter.dy + height / 40),
      Offset(pendulumCoords.bobCenter.dx - width / 20,
          pendulumCoords.bobCenter.dy + height / 40),
      Offset(pendulumCoords.bobCenter.dx - width / 12,
          pendulumCoords.bobCenter.dy - height / 40),
      Offset(pendulumCoords.bobCenter.dx + width / 12,
          pendulumCoords.bobCenter.dy - height / 40),
    ]);

    Path bobPath = Path()..addPolygon(bobPoints, true);

    // Draw the metronome
    canvas.drawLine(pendulumCoords.stickTop, pendulumCoords.stickBottom,
        paints["stickColor"]!);
    canvas.drawCircle(pendulumCoords.rotationCenter,
        pendulumCoords.rotationCenterRadius, paints["fillRotationCenter"]!);
    canvas.drawCircle(pendulumCoords.counterWeightCenter,
        pendulumCoords.counterWeightRadius, paints["fillWeight"]!);
    canvas.drawCircle(pendulumCoords.counterWeightCenter,
        pendulumCoords.counterWeightRadius, paints["outlineColor"]!);
    canvas.drawPath(bobPath, paints["fillBob"]!);
    canvas.drawPath(bobPath, paints["outlineColor"]!);
  }

  @override
  bool shouldRepaint(MetronomePainter oldDelegate) {
    // Repaint if rotation angle or bpm changes
    return (oldDelegate.angle != angle || oldDelegate.bpm != bpm);
  }
}

// Overlay Popup to display in case of errors
class ErrorPopup {
  static void show(BuildContext context, String message) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: 1.0,
              child: Center(
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: blueGreen.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      overlayEntry.remove();
    });
  }
}
