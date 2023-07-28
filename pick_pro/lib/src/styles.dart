import 'package:flutter/material.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);
const Color titleColour = Color.fromARGB(255, 31, 64, 121);

// Class to manage sizes of widgets based on screen dimensions
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
      titlePadding = width / 10.55;
      iconSize = (width / 16.44).floorToDouble();
      barFont = width / 15;
      titleFont = width / 6.42;

      buttonFont = width / 29.36;
      bpmFont = width / 25;
      bpmWidth = width / 11;
      bpmHeight = height / 35;
      bpmPaddingT = height / 14.14;
      bpmPaddingB = height / 7.07;
      metronomePadding = height / 40;
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

      imageSize = width / 1.30;
      playButtonSize = (width / 15).floorToDouble();
      songSize = width / 25;
      artistSize = width / 28;
      sliderPadding = width / 26.55;

      smallBox = height / 70.7;
      largeBox = height / 23.57;
    } else {
      // Landscape Mode
      titlePadding = height / 10.55;
      iconSize = (height / 15).floorToDouble();

      barFont = height / 16;
      titleFont = height / 8;

      buttonFont = height / 40;
      bpmFont = width / 75;
      bpmHeight = height / 20;
      bpmWidth = bpmHeight * 1.5;
      bpmPaddingT = height / 23;
      bpmPaddingB = height / 9;
      metronomePadding = 0;
      metronomeHeight = height / 1.5;
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

      imageSize = height / 2;
      playButtonSize = (height / 18).floorToDouble();
      songSize = height / 25;
      artistSize = height / 28;
      sliderPadding = height / 15.55;

      smallBox = height / 100;
      largeBox = height / 25;
    }
  }

  // Different sizes used in the app
  late double barFont;
  late double iconSize;
  late double titleFont;
  late double titlePadding;

  late double buttonFont;
  late double bpmFont;
  late double bpmWidth;
  late double bpmHeight;
  late double bpmPaddingT;
  late double bpmPaddingB;
  late double metronomePadding;
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
  late double playButtonSize;
  late double songSize;
  late double artistSize;
  late double sliderPadding;

  late double smallBox;
  late double largeBox;
}

// Preset Styles
TextStyle titleText(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      color: titleColour,
      fontFamily: 'Eina01-Regular',
      fontWeight: FontWeight.bold);
}

TextStyle bpmText(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'Eina01-Regular',
      fontWeight: FontWeight.bold);
}

TextStyle songText(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'Eina01-Regular',
      fontWeight: FontWeight.bold);
}

TextStyle artistText(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      color: titleColour,
      fontFamily: 'Eina01-Regular',
      fontWeight: FontWeight.normal);
}

TextStyle timeText(double fontSize) {
  return TextStyle(
      fontSize: fontSize,
      color: Colors.white,
      fontFamily: 'Eina01-Regular',
      fontWeight: FontWeight.normal);
}
