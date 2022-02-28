import 'package:flutter/material.dart';

void main() => runApp(ClassicalMusicPuzzle());

class ClassicalMusicPuzzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classical Music Puzzle',
      home: Scaffold(
        appBar: AppBar(title: Text("Classical Music Puzzle")),
        body: Center(
          child: Container(
            child: Text('Hello World')
          )
        )
      )
    );
  }
}