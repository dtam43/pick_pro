import 'package:flutter/material.dart';
import 'package:pick_pro/main.dart';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

// Tracking the chords to show on the screen
final showChords = <String>['c', 'd', 'e', 'f', 'g', 'a', 'b'];
final tune = <String>['b', '', '#'];
int chordsIndex = -1;
int tuneIndex = 1;

class Chords extends StatefulWidget {
  @override
  ChordState createState() => ChordState();
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
          child: ListView(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          tuneIndex = 0;
                          setState(() {});
                        },
                        child: Text(
                          "Flat",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          tuneIndex = 1;
                          setState(() {});
                        },
                        child: Text(
                          "Neutral",
                          style: buttonText(),
                        ),
                      ),
                      TextButton(
                        style: buttonStyle(),
                        onPressed: () {
                          tuneIndex = 2;
                          setState(() {});
                        },
                        child: Text(
                          "Sharp",
                          style: buttonText(),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            Builder(
              builder: (context) {
                double screenWidth = MediaQuery.of(context).size.width;
                int itemsPerRow = (screenWidth / 400).floor();

                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: 0,
                        height: 50,
                      ),
                      Flexible(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount:
                              itemsPerRow, // Number of items per row based on screenWidth
                          children:
                              chordsIndex < 0 ? getAllChords() : getOneLetter(),
                        ),
                      ),
                      const SizedBox(
                        width: 0,
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

// Widget list for all chords of one note
List<Widget> getOneLetter() {
  // Set Equivalent note names (i.e. B# to C)
  if (chordsIndex == 0 && tuneIndex == 0) {
    chordsIndex = 1;
    tuneIndex = 1;
  } else if (chordsIndex == 2 && tuneIndex == 2) {
    chordsIndex = 3;
    tuneIndex = 1;
  } else if (chordsIndex == 3 && tuneIndex == 0) {
    chordsIndex = 2;
    tuneIndex = 1;
  } else if (chordsIndex == 6 && tuneIndex == 2) {
    chordsIndex = 0;
    tuneIndex = 1;
  }

  return [
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_minor.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_7.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_5.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_dim.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_dim7.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_aug.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_sus2.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_sus4.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_maj7.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_m7.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/${showChords[chordsIndex]}${tune[tuneIndex]}_7sus4.png',
      fit: BoxFit.fitHeight,
    ),
  ];
}

// Widget list for all chords
List<Widget> getAllChords() {
  return [
    // TODO: Add every guitar chord
    Image.asset(
      'assets/images/chords/c_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/d_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/e_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/f_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/g_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/a_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/b_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/bb_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/db_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/eb_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/gb_major.png',
      fit: BoxFit.fitHeight,
    ),
    Image.asset(
      'assets/images/chords/ab_major.png',
      fit: BoxFit.fitHeight,
    ),
  ];
}
