import 'package:flutter/material.dart';
import 'metronome.dart';
import 'chords.dart';
import 'player.dart';

void main() => runApp(MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder()
            },
          ),
        ),
        routes: {
          '/': (context) => Metronome(),
          '/chords': (context) => Chords(),
          '/player': (context) => Playback(),
        }));
