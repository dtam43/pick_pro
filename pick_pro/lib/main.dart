import 'package:flutter/material.dart';
import '/src/styles.dart';
import '/src/navigation.dart';
import 'metronome.dart';
import 'chords.dart';
import 'player.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);

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
          '/': (context) => Home(),
          '/metronome': (context) => Metronome(),
          '/chords': (context) => Chords(),
          '/player': (context) => Playback(),
        }));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Declare size manager to resize widgets according to screen dimensions
    SizeManager size = SizeManager(context);

    return Scaffold(
      body: Container(
        color: background,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/guitar.png',
                width: size.logoWidth,
                height: size.logoHeight,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 220.0, 0, 0),
                padding: const EdgeInsets.all(8),
                child: Text(
                  'PickPro',
                  style: TextStyle(
                      fontSize: size.titleFont,
                      fontFamily: 'Caveat',
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0,
                          color: Colors.grey,
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyNavBar(index: 0),
    );
  }
}
