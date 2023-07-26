import 'package:flutter/material.dart';
import '/src/drawer.dart';
import '/src/styles.dart';

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
    SizeManager size = SizeManager(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PickPro',
          style: TextStyle(
            fontSize: size.barFont,
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
                SizedBox(
                  height: size.mediumBox,
                ),
                Text(
                  'Chords List',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Caveat',
                    fontSize: size.chordFont,
                  ),
                ),
                SizedBox(
                  height: size.smallBox,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: size.dropWidth,
                        height: size.dropHeight,
                        child: Center(
                          child: DropdownButton<int>(
                            hint: Text(
                              chordsIndex == -1
                                  ? 'All Chords'
                                  : showChords[chordsIndex].toUpperCase(),
                              style: TextStyle(
                                fontSize: size.buttonFont,
                                color: Colors.white,
                              ),
                            ),
                            onChanged: (int? value) {
                              chordsIndex = value!;
                              setState(() {});
                            },
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem<int>(
                                value: -1,
                                child: Text('All',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Text('C',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Text('D',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 2,
                                child: Text('E',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 3,
                                child: Text('F',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 4,
                                child: Text('G',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 5,
                                child: Text('A',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                              DropdownMenuItem<int>(
                                value: 6,
                                child: Text('B',
                                    style:
                                        TextStyle(fontSize: size.buttonFont)),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            padding: EdgeInsets.zero,
                            dropdownColor:
                                const Color.fromARGB(255, 228, 228, 228),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.dropWidth,
                        height: size.dropHeight,
                        child: Center(
                          child: DropdownButton<int>(
                            hint: Text(
                              tuneIndex == 2
                                  ? 'Sharp'
                                  : tuneIndex == 0
                                      ? 'Flat'
                                      : 'Normal',
                              style: TextStyle(
                                fontSize: size.buttonFont,
                                color: Colors.white,
                              ),
                            ),
                            onChanged: (int? value) {
                              tuneIndex = value!;
                              setState(() {});
                            },
                            elevation: 16,
                            items: <DropdownMenuItem<int>>[
                              DropdownMenuItem<int>(
                                value: 0,
                                child: Text(
                                  'Flat',
                                  style: TextStyle(fontSize: size.buttonFont),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 1,
                                child: Text(
                                  'Normal',
                                  style: TextStyle(fontSize: size.buttonFont),
                                ),
                              ),
                              DropdownMenuItem<int>(
                                value: 2,
                                child: Text(
                                  'Sharp',
                                  style: TextStyle(fontSize: size.buttonFont),
                                ),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            padding: EdgeInsets.zero,
                            dropdownColor:
                                const Color.fromARGB(255, 228, 228, 228),
                          ),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: size.largeBox,
                ),
              ],
            ),
            Builder(
              builder: (context) {
                double screenWidth = MediaQuery.of(context).size.width;
                int itemsPerRow = (screenWidth / size.chordWidth).floor();

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
    chordsIndex = 6;
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
  List<Widget> allChords = [];

  // Add all chords to list
  for (String chord in showChords) {
    for (String t in tune) {
      // Cancel add if chord doesn't exist (i.e. Cb or E#)
      if ((chord == 'c' && t == 'b') ||
          (chord == 'e' && t == '#') ||
          (chord == 'f' && t == 'b') ||
          (chord == 'b' && t == '#')) {
        continue;
      }

      // Add all chords of one note
      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_major.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_minor.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_7.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_5.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_dim.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_dim7.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_aug.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_sus2.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_sus4.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_maj7.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_m7.png',
        fit: BoxFit.fitHeight,
      ));

      allChords.add(Image.asset(
        'assets/images/chords/$chord${t}_7sus4.png',
        fit: BoxFit.fitHeight,
      ));
    }
  }

  return allChords;
}
