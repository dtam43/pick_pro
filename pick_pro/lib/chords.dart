import 'package:flutter/material.dart';
import 'package:pick_pro/main.dart';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

// Tracking the chords to show on the screen
final showChords = <String>['c', 'd', 'e', 'f', 'g', 'a', 'b'];
int chordsIndex = -1;

class Chords extends StatefulWidget {
  @override
  ChordState createState() => ChordState();
}

// Widget list for all chords
List<Widget> getAllChords() {
  return [
    // TODO: Add every guitar chord
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
    Image.asset(
      'assets/images/home.png',
      width: 100,
      height: 100,
    ),
  ];
}

// Widget list for all chords of one note
List<Widget> getOneLetter() {
  // TODO: add images using a naming system that replaces a
  // letter with the showChords value i.e. showChords[0] = 'c'
  return [
    Text('hi', style: buttonText()),
  ];
}

class ChordState extends State<Chords> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Chords List',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Caveat',
                    fontSize: 64,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  style: buttonStyle(),
                  onPressed: () {
                    chordsIndex = -1;
                    setState(() {});
                  },
                  child: Text(
                    "Reveal All",
                    style: buttonText(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 0;
                          setState(() {});
                        },
                        child: Text(
                          "C",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 1;
                          setState(() {});
                        },
                        child: Text(
                          "D",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 2;
                          setState(() {});
                        },
                        child: Text(
                          "E",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 3;
                          setState(() {});
                        },
                        child: Text(
                          "F",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 4;
                          setState(() {});
                        },
                        child: Text(
                          "G",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 5;
                          setState(() {});
                        },
                        child: Text(
                          "A",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          chordsIndex = 6;
                          setState(() {});
                        },
                        child: Text(
                          "B",
                          style: buttonText(),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 50,
                ),
                Builder(
                  builder: (context) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    int itemsPerRow = (screenWidth / 100).floor();

                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            width: 50,
                            height: 50,
                          ),
                          Flexible(
                            child: GridView.count(
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount:
                                  itemsPerRow, // Number of items per row based on screenWidth
                              children: chordsIndex < 0
                                  ? getAllChords()
                                  : getOneLetter(),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                            height: 50,
                          ),
                        ]);
                  },
                ),
              ]),
        ),
      ),
      drawer: MyDrawer(index: 2),
    );
  }
}
