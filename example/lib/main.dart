import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/key.dart';
import 'package:example/speech/speech_text.dart';
import 'package:flutter/material.dart';
import 'package:wavenet/wavenet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Text To Speech Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textConstructor = TextConstructor1();
  TextToSpeechService _service = TextToSpeechService(apiKey);
  AudioPlayer _audioPlayer = AudioPlayer();

  /// https://cloud.google.com/text-to-speech/docs/voices

  _playDemo() async {
    setState(() {
      if (textConstructor.isFinished() != true) {
        textConstructor.nextQuestion();
      }
    });
    print(textConstructor.getCharacterName());
    switch (textConstructor.getCharacterName()) {
      case "Admiral Venesca Catallia":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-US-Wavenet-C",
          languageCode: "en-EN",
        );

        _audioPlayer.play(file.path, isLocal: true);
        break;
      case "Major Razim":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-AU-Wavenet-D",
          languageCode: "en-AU",
        );
        _audioPlayer.play(file.path, isLocal: true);
        break;
      case "Captain severin":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-US-Wavenet-J",
          languageCode: "en-EN",
        );

        _audioPlayer.play(file.path, isLocal: true);
        break;
      case "Commodore Trevaux":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-GB-Wavenet-D",
          languageCode: "en-GB",
        );

        _audioPlayer.play(file.path, isLocal: true);
        break;
      default:
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-AU-Wavenet-D",
          languageCode: "en-AU",
        );

        _audioPlayer.play(file.path, isLocal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                textConstructor.getCharacterText()!,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playDemo,
        tooltip: 'Play Demo',
        child: Icon(Icons.arrow_right_alt_outlined),
      ),
    );
  }
}
