import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piano/piano.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Piano Demo',
        home: Center(
          child: InteractivePiano(
            highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              // Use an audio library like flutter_midi to play the sound
            },
          ),
        )
        
        );
  }
}
