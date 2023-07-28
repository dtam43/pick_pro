import 'package:flutter/material.dart';
import '/src/styles.dart';
import '/src/navigation.dart';
import '/src/error_popup.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui' as ui;

import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);
const Color bobColor = Color.fromARGB(255, 12, 69, 134);

// Tracking the condition of the metronome for animation
enum MetronomeIs { playing, stopped, stopping }

final TextEditingController _controller = TextEditingController();

// Singleton to retain metronome information after leaving page
class MetronomePlayer {
  MetronomeIs metronomeIs = MetronomeIs.stopped;

  // Audio player and timers for animation and sounds
  AudioPlayer player = AudioPlayer();
  Timer timer = Timer.periodic(const Duration(milliseconds: 0), (Timer t) {});
  Timer frameTimer =
      Timer.periodic(const Duration(milliseconds: 0), (Timer t) {});
  int bpm = 100;

  // Variables for animation
  int lastFrameTime = 0;
  int lastEvenTick = 0;
  bool lastTickWasEven = true;
  int interval = 0;

  double angle = 0;

  MetronomePlayer._internal();
  static final MetronomePlayer _instance = MetronomePlayer._internal();
}

class Metronome extends StatefulWidget {
  @override
  MetronomeState createState() => MetronomeState();
}

class MetronomeState extends State<Metronome> {
  // Constraints on metronome speed and rotation
  final _maxAngle = 0.26;
  final _minTempo = 20;
  final _maxTempo = 240;

  // Singleton to hold metronome-related variables
  final _metronomePlayer = MetronomePlayer._instance;

  // Cancel timers when leaving page
  @override
  void dispose() {
    _metronomePlayer.frameTimer.cancel();
    super.dispose();
  }

  // Initialize audio player
  @override
  void initState() {
    super.initState();

    // If metronome is previously playing, restart animation
    if (_metronomePlayer.metronomeIs == MetronomeIs.playing) {
      _metronomePlayer.lastEvenTick = DateTime.now().millisecondsSinceEpoch;
      _animate();
    }

    _metronomePlayer.player.setAsset('assets/sounds/metronome.mp3');
  }

  // Method to start the metronome animation
  void _start() {
    _metronomePlayer.metronomeIs = MetronomeIs.playing;
    _metronomePlayer.interval = 1000 ~/ (_metronomePlayer.bpm / 60);

    _metronomePlayer.lastEvenTick = DateTime.now().millisecondsSinceEpoch;

    _metronomePlayer.timer = Timer.periodic(
        Duration(milliseconds: _metronomePlayer.interval), _onTick);
    _animate();

    // Play first metronome sound
    _metronomePlayer.player.pause();
    _metronomePlayer.player.seek(Duration.zero);
    _metronomePlayer.player.play();

    setState(() {});
  }

  // Method to create the animation delay and timer
  void _animate() {
    _metronomePlayer.frameTimer.cancel();

    int frameTime = DateTime.now().millisecondsSinceEpoch;

    if (_metronomePlayer.metronomeIs == MetronomeIs.playing ||
        _metronomePlayer.metronomeIs == MetronomeIs.stopping) {
      int delay = max(
          0,
          _metronomePlayer.lastFrameTime +
              17 -
              DateTime.now().millisecondsSinceEpoch);

      // Set timer for animation
      _metronomePlayer.frameTimer = Timer(Duration(milliseconds: delay), () {
        _animate();
      });
    } else {
      _metronomePlayer.angle = 0;
    }

    _metronomePlayer.lastFrameTime = frameTime;

    setState(() {});
  }

  // Method to play metronome sound on tick or cancel timer when stop is pressed
  void _onTick(Timer t) {
    // Tracking length since tick passed every other tick
    _metronomePlayer.lastTickWasEven = t.tick % 2 == 0;
    if (_metronomePlayer.lastTickWasEven) {
      _metronomePlayer.lastEvenTick = DateTime.now().millisecondsSinceEpoch;
    }
    // Playing sound
    if (_metronomePlayer.metronomeIs == MetronomeIs.playing) {
      _metronomePlayer.player.pause();
      _metronomePlayer.player.seek(Duration.zero);
      _metronomePlayer.player.play();

      // Restting metronome to bring it to a stop
    } else if (_metronomePlayer.metronomeIs == MetronomeIs.stopping) {
      _metronomePlayer.timer.cancel();
      _metronomePlayer.frameTimer.cancel();
      _resetAnimation();
      _metronomePlayer.metronomeIs = MetronomeIs.stopped;
      setState(() {});
    }
  }

  // Method to signal _onTick to stop
  void _stop() {
    if (_metronomePlayer.metronomeIs == MetronomeIs.playing) {
      _metronomePlayer.metronomeIs = MetronomeIs.stopping;
    }
    _metronomePlayer.player.stop();

    setState(() {});
  }

  // Method to reset animation values
  void _resetAnimation() {
    _metronomePlayer.metronomeIs = MetronomeIs.stopped;
    _metronomePlayer.lastFrameTime = 0;
    _metronomePlayer.lastEvenTick = 0;
    _metronomePlayer.lastTickWasEven = true;
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

    if (_metronomePlayer.metronomeIs == MetronomeIs.playing ||
        _metronomePlayer.metronomeIs == MetronomeIs.stopping) {
      int timePassed = now - _metronomePlayer.lastEvenTick;

      // Reset time interval if tick animation is delayed
      if (timePassed > _metronomePlayer.interval * 2) {
        timePassed -= (_metronomePlayer.interval * 2);
      }

      rotatePercent = (timePassed).toDouble() / (_metronomePlayer.interval * 2);

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

      _metronomePlayer.bpm = number;
      setState(() {});

      // For invalid BPM inputs
    } catch (e) {
      ErrorPopup.show(context, "The BPM you entered is invalid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _metronomePlayer.angle = _getAngle();
    SizeManager size = SizeManager(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.titlePadding, top: size.titlePadding),
                      child: Text(
                        'Metronome',
                        style: titleText(size.titleFont),
                      ),
                    ),
                    const SizedBox(width: 0, height: 0),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.titlePadding, right: size.titlePadding),
                      child: IconButton(
                        icon: Icon(
                            _metronomePlayer.metronomeIs == MetronomeIs.playing
                                ? LucideIcons.pause
                                : LucideIcons.play,
                            color: foreground),
                        iconSize: size.playButtonSize,
                        onPressed:
                            _metronomePlayer.metronomeIs == MetronomeIs.stopping
                                ? null
                                : () {
                                    _metronomePlayer.metronomeIs ==
                                            MetronomeIs.stopped
                                        ? _start()
                                        : _stop();
                                  },
                      ),
                    ),
                  ],
                ),
                Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: size.metronomePadding),
                        child: Image.asset(
                          size.width < size.height
                              ? 'assets/images/metronome.png'
                              : 'assets/images/metronome_l.png',
                          fit: BoxFit.fitHeight,
                          width: size.metronomeWidth,
                          height: size.metronomeHeight,
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.bpmPaddingT,
                                  bottom: size.bpmPaddingB),
                              child: SizedBox(
                                width: size.bpmWidth,
                                height: size.bpmHeight,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  enabled: _metronomePlayer.metronomeIs ==
                                      MetronomeIs.stopped,
                                  style: bpmText(size.bpmFont),
                                  decoration: InputDecoration(
                                      hintText: _metronomePlayer.bpm.toString(),
                                      hintStyle: bpmText(size.bpmFont),
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
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              return _stick(
                                  context, size.stickWidth, size.stickHeight);
                            }),
                          ]),
                    ]),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyNavBar(index: 0),
    );
  }

  // Widget to draw the metronome stick
  Widget _stick(BuildContext context, double width, double height) {
    // Gesture detector to recognize tapping the weight
    return GestureDetector(
      // When weight is moved
      onPanUpdate: (dragUpdateDetails) {
        // Only allow adjustment when metronome is off
        if (_metronomePlayer.metronomeIs == MetronomeIs.stopped) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset localPosition =
              box.globalToLocal(dragUpdateDetails.globalPosition);

          // Update bpm value
          _weightDragged(width, height, localPosition);
        }
      },

      // Draw metronome
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          foregroundPainter: MetronomePainter(
              width: width,
              height: height,
              bpm: _metronomePlayer.bpm,
              minTempo: _minTempo,
              maxTempo: _maxTempo,
              angle: _metronomePlayer.angle),
          child: const InkWell(),
        ),
      ),
    );
  }

  // Method to track the movement of the weight and update the bpm value
  void _weightDragged(double width, double height, Offset localPosition) {
    Offset translatedLocalPos =
        localPosition.translate(-width / 2, -height * 0.75);
    PendulumCoords pendulumCoords = PendulumCoords(
        width, height, _metronomePlayer.bpm, _minTempo, _maxTempo);

    double weightPos = (translatedLocalPos.dy - pendulumCoords.bobMinY) /
        pendulumCoords.bobTravel;

    // Determine new bpm based on relative weight position
    _metronomePlayer.bpm = min(
        _maxTempo,
        max(_minTempo,
            _minTempo + (weightPos * (_maxTempo - _minTempo)).toInt()));

    _metronomePlayer.interval = 1000 ~/ (_metronomePlayer.bpm / 60);
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
    rotationCenter = const Offset(0, 0);
    rotationCenterRadius = width / 45;

    counterWeightCenter = Offset(0, height * 0.1);
    counterWeightRadius = width / 15;

    stickTop = Offset(0, -height * 0.9);
    stickBottom = Offset(0, height * 0.1);

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
        ..color = background
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.07,
      "stickOutline": Paint()
        ..color = foreground
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.08,
      "outlineColor": Paint()
        ..color = foreground
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.005,
      "fillWeight": Paint()
        ..color = background
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill,
      "fillBob": Paint()
        ..color = background
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
      Offset(pendulumCoords.bobCenter.dx + width / 15,
          pendulumCoords.bobCenter.dy + height / 30),
      Offset(pendulumCoords.bobCenter.dx - width / 15,
          pendulumCoords.bobCenter.dy + height / 30),
      Offset(pendulumCoords.bobCenter.dx - width / 9,
          pendulumCoords.bobCenter.dy - height / 30),
      Offset(pendulumCoords.bobCenter.dx + width / 9,
          pendulumCoords.bobCenter.dy - height / 30),
    ]);

    Path bobPath = Path()..addPolygon(bobPoints, true);

    // Draw the metronome
    canvas.drawLine(pendulumCoords.stickTop, pendulumCoords.stickBottom,
        paints["stickOutline"]!);
    canvas.drawLine(pendulumCoords.stickTop, pendulumCoords.stickBottom,
        paints["stickColor"]!);
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
