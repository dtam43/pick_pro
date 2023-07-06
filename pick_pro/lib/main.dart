import 'package:flutter/material.dart';

const Color darkBlue = Color(0xFF000c24);
const Color blueGreen = Color.fromARGB(255, 121, 207, 175);

void main() => runApp(MaterialApp(
      home: Home(),
    ));

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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(blueGreen),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 47, 147, 122)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(30)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Metronome',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(blueGreen),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 47, 147, 122)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(30)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Custom Playback',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ]),
        ),
      ),
    );
  }
}
