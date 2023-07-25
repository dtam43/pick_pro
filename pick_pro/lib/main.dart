import 'package:flutter/material.dart';
import 'metronome.dart';
import 'chords.dart';
import 'player.dart';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

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

// Preset Styles
ButtonStyle buttonStyle() {
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    backgroundColor: MaterialStateProperty.all<Color>(blueGreen),
    overlayColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 47, 147, 122)),
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

TextStyle buttonText() {
  return const TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );
}

// SideBar for Navigating between pages
class MyDrawer extends StatelessWidget {
  // Tracking the current page
  final int index;
  MyDrawer({required this.index});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 89, 152, 129),
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 0 ? 1 : 0.6,
                child: Image.asset(
                  'assets/images/home.png',
                  width: 50,
                  height: 50,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 1 ? 1 : 0.6,
                child: Image.asset(
                  'assets/images/metronome_icon.png',
                  width: 40,
                  height: 50,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/metronome');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 2 ? 1 : 0.6,
                child: Image.asset(
                  'assets/images/chords.png',
                  width: 30,
                  height: 50,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chords');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 3 ? 1 : 0.6,
                child: Image.asset(
                  'assets/images/player.png',
                  width: 30,
                  height: 50,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/player');
            },
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/guitar.png',
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 220.0, 0, 0),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'PickPro',
                  style: TextStyle(
                      fontSize: 100.0,
                      fontFamily: 'Caveat',
                      color: Colors.white,
                      shadows: [
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
      drawer: MyDrawer(index: 0),
    );
  }
}
