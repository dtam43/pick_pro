import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PickPro',
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'Caveat',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: const Center(
          child: Text(
            'hello world',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.0,
              color: Colors.grey,
              fontFamily: 'Caveat',
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text("click"),
        ),
      ),
    ));
