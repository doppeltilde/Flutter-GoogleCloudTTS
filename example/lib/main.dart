import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/speech/speech_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wavenet/wavenet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Text To Speech Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textConstructor = TextConstructor1();
  final TextToSpeechService _service =
      TextToSpeechService("AIzaSyA1h7D3WEoCiAnqrN0BWX2mkyFcC1rO3tM");
  final audioPlayer = AudioPlayer();

  /// https://cloud.google.com/text-to-speech/docs/voices

  getAudioPlayer(file) {
    audioPlayer.play(DeviceFileSource(file));
  }

  _playDemo() async {
    setState(() {
      if (textConstructor.isFinished() != true) {
        textConstructor.nextQuestion();
      } else {
        textConstructor.reset();
      }
    });
    if (kDebugMode) {
      print(textConstructor.getCharacterName());
    }
    switch (textConstructor.getCharacterName()) {
      case "Admiral Venesca Catallia":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-US-Wavenet-C",
          languageCode: "en-EN",
          pitch: -2,
          speakingRate: 1.25,
          audioEncoding: "LINEAR16",
        );

        getAudioPlayer(file.path);
        break;
      case "Major Razim":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-AU-Wavenet-D",
          languageCode: "en-AU",
          audioEncoding: "LINEAR16",
        );
        getAudioPlayer(file.path);
        break;
      case "Captain severin":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-US-Wavenet-J",
          languageCode: "en-EN",
          pitch: 10,
          speakingRate: 1.4,
          audioEncoding: "ALAW",
        );

        getAudioPlayer(file.path);
        break;
      case "Commodore Trevaux":
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-GB-Wavenet-D",
          languageCode: "en-GB",
          audioEncoding: "LINEAR16",
          pitch: -7,
          speakingRate: 1.2,
        );

        getAudioPlayer(file.path);
        break;
      default:
        File file = await _service.textToSpeech(
          text: textConstructor.getCharacterText().toString(),
          voiceName: "en-AU-Wavenet-D",
          languageCode: "en-AU",
          audioEncoding: "MP3",
          pitch: -7,
        );

        getAudioPlayer(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              textConstructor.getCharacterName()!.toUpperCase(),
              style: const TextStyle(
                  fontSize: 17.5,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              textConstructor.getCharacterText()!,
              style: const TextStyle(
                fontSize: 17.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playDemo,
        tooltip: 'Play Demo',
        child: const Icon(Icons.arrow_right_alt_outlined),
      ),
    );
  }
}
