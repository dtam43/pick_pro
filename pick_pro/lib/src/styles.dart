import 'package:flutter/material.dart';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

class SizeManager {
  double width = 411;
  double height = 707;

  SizeManager(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    setVariables(width, height);
  }

  // Set font sizes and dimensions based on screen size
  setVariables(double width, double height) {
    // Portrait Mode
    if (width < height) {
      barFont = width / 12.8;
      titleFont = width / 6.42;
      logoHeight = height / 1.18;
      logoWidth = logoHeight * 0.417;

      buttonFont = width / 29.36;
      bpmWidth = width / 11;
      bpmHeight = height / 40;
      metronomeWidth = width / 1;
      metronomeHeight = metronomeWidth * 1.2;
      stickWidth = width / 2.16;
      stickHeight = stickWidth * 1.775;

      errorWidth = width / 2.055;
      errorHeight = height / 7.07;
      errorFont = width / 25.69;

      chordFont = width / 8.56;
      dropWidth = width / 2.74;
      dropHeight = height / 14.14;
      chordWidth = width / 2.055;

      imageSize = width / 1.60;
      iconSize = (width / 11.28).floorToDouble();

      smallBox = height / 70.7;
      mediumBox = height / 47.13;
      largeBox = height / 23.57;
      landscapeBox = 0;
    } else {
      // Landscape Mode
      barFont = height / 16;
      titleFont = height / 8;
      logoHeight = height / 1.18;
      logoWidth = logoHeight * 0.417;

      buttonFont = height / 40;
      bpmHeight = height / 20;
      bpmWidth = bpmHeight * 1.5;
      metronomeHeight = height / 1.57;
      metronomeWidth = metronomeHeight / 1.2;
      stickHeight = height / 2.5;
      stickWidth = stickHeight / 1.875;

      errorWidth = width / 3;
      errorHeight = height / 10;
      errorFont = height / 35;

      chordFont = height / 10;
      dropWidth = width / 2.74;
      dropHeight = height / 14.14;
      chordWidth = width / 4;

      imageSize = height / 2.5;
      iconSize = (height / 15).floorToDouble();

      smallBox = height / 100;
      mediumBox = height / 75;
      largeBox = height / 25;
      landscapeBox = 20;
    }
  }

  // Different sizes used in the app
  late double barFont;
  late double titleFont;
  late double logoWidth;
  late double logoHeight;

  late double buttonFont;
  late double bpmWidth;
  late double bpmHeight;
  late double metronomeWidth;
  late double metronomeHeight;
  late double stickWidth;
  late double stickHeight;

  late double errorWidth;
  late double errorHeight;
  late double errorFont;

  late int buttonsPerRow;
  late double chordFont;
  late double dropWidth;
  late double dropHeight;
  late double chordWidth;
  late double chordRow;

  late double imageSize;
  late double iconSize;

  late double smallBox;
  late double mediumBox;
  late double largeBox;
  late double landscapeBox;
}

// Preset Styles
ButtonStyle buttonStyle() {
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color>(blueGreen),
    overlayColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 47, 147, 122)),
    padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

TextStyle buttonText(double fontSize) {
  return TextStyle(
    fontSize: fontSize,
    color: Colors.white,
  );
}
