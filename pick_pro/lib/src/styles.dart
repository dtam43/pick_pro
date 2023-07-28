import 'package:flutter/material.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);
const Color titleColour = Color.fromARGB(255, 37, 75, 142);

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

      bpmWidth = width / 11;
      bpmHeight = height / 35;
      bpmPaddingT = height / 14.14;
      bpmPaddingB = height / 7.07;
      metronomePadding = height / 40;
      metronomeWidth = width / 1;
      metronomeHeight = metronomeWidth * 1.2;
      stickWidth = width / 2.16;
      stickHeight = stickWidth * 1.775;

      dropWidth = width / 2.74;
      dropHeight = height / 14.14;
      chordWidth = width / 2.055;

      imageSize = width / 1.30;
      playButtonSize = (width / 15).floorToDouble();
      sliderPadding = width / 26.55;

      titleFont = width / 15;
      bpmFont = width / 25;
      chordFont = width / 35;
      headerFont = width / 25;
      bodyFont = width / 28;
      smallFont = height / 35;

      smallBox = height / 70.7;
      largeBox = height / 23.57;

      errorWidth = width / 2.055;
      errorHeight = height / 7.07;
      errorFont = width / 25.69;
    } else {
      // Landscape Mode
      titlePadding = height / 10.55;
      iconSize = (height / 18).floorToDouble();

      bpmHeight = height / 20;
      bpmWidth = bpmHeight * 1.5;
      bpmPaddingT = height / 23;
      bpmPaddingB = height / 9;
      metronomePadding = 0;
      metronomeHeight = height / 1.4;
      metronomeWidth = metronomeHeight / 1.2;
      stickHeight = height / 2;
      stickWidth = stickHeight / 1.875;

      dropWidth = width / 2.74;
      dropHeight = height / 14.14;
      chordWidth = width / 4;

      imageSize = height / 1.5;
      playButtonSize = (height / 18).floorToDouble();
      sliderPadding = height / 5;
      columnWidth = height / 1.8;
      timePadding = columnWidth / 15;

      titleFont = height / 16;
      bpmFont = height / 35;
      chordFont = height / 30;
      headerFont = height / 25;
      bodyFont = height / 33;
      smallFont = height / 37;

      smallBox = height / 100;
      largeBox = height / 25;

      errorWidth = width / 3;
      errorHeight = height / 10;
      errorFont = height / 35;
    }
  }

  // Different sizes used in the app
  late double iconSize;
  late double titlePadding;

  late double bpmWidth;
  late double bpmHeight;
  late double bpmPaddingT;
  late double bpmPaddingB;
  late double metronomePadding;
  late double metronomeWidth;
  late double metronomeHeight;
  late double stickWidth;
  late double stickHeight;

  late double dropWidth;
  late double dropHeight;
  late double chordWidth;

  late double imageSize;
  late double playButtonSize;
  late double sliderPadding;
  late double columnWidth = 0;
  late double timePadding = 0;

  late double titleFont;
  late double bpmFont;
  late double chordFont;
  late double headerFont;
  late double bodyFont;
  late double smallFont;

  late double smallBox;
  late double largeBox;

  late double errorWidth;
  late double errorHeight;
  late double errorFont;
}

// Preset Text Styles
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
