import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterMidi = FlutterMidi();

  @override
  initState() {
    _flutterMidi.unmute();
    rootBundle.load("assets/Piano.sf2").then((sf2) {
      _flutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
    });
    super.initState();
  }

  double get keyWidth => 80 + (80 * _widthRatio);
  double _widthRatio = 0.0;
  bool _showLabels = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(title: Text("Flutter Piano")),
          drawer: Drawer(
              child: SafeArea(
                  child: ListView(children: <Widget>[
            Container(height: 20.0),
            ListTile(title: Text("Change Width")),
            Slider(
                activeColor: Colors.redAccent,
                inactiveColor: Colors.white,
                min: 0.0,
                max: 1.0,
                value: _widthRatio,
                onChanged: (double value) =>
                    setState(() => _widthRatio = value)),
            Divider(),
            ListTile(
                title: Text("Show Labels"),
                trailing: Switch(
                    value: _showLabels,
                    onChanged: (bool value) =>
                        setState(() => _showLabels = value))),
            Divider(),
          ]))),
          body: ListView.builder(
            itemCount: 7,
            scrollDirection: Axis.horizontal,
            controller: ScrollController(initialScrollOffset: 1500.0),
            itemBuilder: (BuildContext context, int index) {
              final int i = index * 12;
              return SafeArea(
                child: Stack(children: <Widget>[
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    _buildKey(24 + i, false),
                    _buildKey(26 + i, false),
                    _buildKey(28 + i, false),
                    _buildKey(29 + i, false),
                    _buildKey(31 + i, false),
                    _buildKey(33 + i, false),
                    _buildKey(35 + i, false),
                  ]),
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 100,
                      top: 0.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(width: keyWidth * .5),
                            _buildKey(25 + i, true),
                            _buildKey(27 + i, true),
                            Container(width: keyWidth),
                            _buildKey(30 + i, true),
                            _buildKey(32 + i, true),
                            _buildKey(34 + i, true),
                            Container(width: keyWidth * .5),
                          ])),
                ]),
              );
            },
          )),
    );
  }

  Widget _buildKey(int midi, bool accidental) {
    final pitchName = Pitch.fromMidiNumber(midi).toString();
    final pianoKey = Stack(
      children: <Widget>[
        Semantics(
            button: true,
            hint: pitchName,
            child: Material(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                color: accidental ? Colors.black : Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  highlightColor: Colors.grey,
                  onTap: () {},
                  onTapDown: (_) => _flutterMidi.playMidiNote(midi: midi),
                ))),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: _showLabels
                ? Text(pitchName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: !accidental ? Colors.black : Colors.white))
                : Container()),
      ],
    );
    if (accidental) {
      return Container(
          width: keyWidth,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),
          child: Material(
              elevation: 6.0,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              shadowColor: Color(0x802196F3),
              child: pianoKey));
    }
    return Container(
        width: keyWidth,
        child: pianoKey,
        margin: EdgeInsets.symmetric(horizontal: 2.0));
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_midi/flutter_midi.dart';
// import 'package:flutter/foundation.dart';
// import 'package:piano/piano.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _flutterMidi = FlutterMidi();
//   @override
//   void initState() {
//     if (!kIsWeb) {
//       load(_value);
//     } else {
//       _flutterMidi.prepare(sf2: null);
//     }
//     super.initState();
//   }

//   void load(String asset) async {
//     print('Loading File...');
//     _flutterMidi.unmute();
//     ByteData _byte = await rootBundle.load(asset);
//     //assets/sf2/SmallTimGM6mb.sf2
//     //assets/sf2/Piano.SF2
//     _flutterMidi.prepare(sf2: _byte, name: _value.replaceAll('assets/', ''));
//   }

//   String _value = 'assets/Piano.sf2';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: Center(
//             child: InteractivePiano(
//               highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
//               naturalColor: Colors.white,
//               accidentalColor: Colors.black,
//               keyWidth: 60,
//               noteRange: NoteRange.forClefs([
//                 Clef.Treble,
//               ]),
//               onNotePositionTapped: (position) {
//                 print(position);
//                 // Use an audio library like flutter_midi to play the sound
//               },
//             ),
//           )

//           // Center(
//           //     child: Column(
//           //   crossAxisAlignment: CrossAxisAlignment.center,
//           //   mainAxisSize: MainAxisSize.min,
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: <Widget>[
//           //     // DropdownButton<String>(
//           //     //   value: _value,
//           //     //   items: [
//           //     //     DropdownMenuItem(
//           //     //       child: Text("Soft Piano"),
//           //     //       value: "assets/sf2/SmallTimGM6mb.sf2",
//           //     //     ),
//           //     //     DropdownMenuItem(
//           //     //       child: Text("Loud Piano"),
//           //     //       value: "assets/sf2/Piano.SF2",
//           //     //     ),
//           //     //   ],
//           //     //   onChanged: (String value) {
//           //     //     setState(() {
//           //     //       _value = value;
//           //     //     });
//           //     //     load(_value);
//           //     //   },
//           //     // ),
//           //     Center(
//           //       child: InteractivePiano(
//           //         highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
//           //         naturalColor: Colors.white,
//           //         accidentalColor: Colors.black,
//           //         keyWidth: 60,
//           //         noteRange: NoteRange.forClefs([
//           //           Clef.Treble,
//           //         ]),
//           //         onNotePositionTapped: (position) {
//           //           // Use an audio library like flutter_midi to play the sound
//           //         },
//           //       ),
//           //     ),
//           //     ElevatedButton(
//           //       child: Text('Play C'),
//           //       onPressed: () {
//           //         _play(60);
//           //       },
//           //     ),
//           //     ElevatedButton(
//           //       child: Text('Play C'),
//           //       onPressed: () {
//           //         _play(65);
//           //       },
//           //     ),
//           //   ],
//           // )),

//           ),
//     );
//   }

//   void _play(int midi) {
//     if (kIsWeb) {
//       // WebMidi.play(midi);
//     } else {
//       _flutterMidi.playMidiNote(midi: midi);
//     }
//   }
// }
