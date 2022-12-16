import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/speech/speech_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wavenet/wavenet.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

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
      TextToSpeechService(dotenv.get("GOOGLE_CLOUD_API_KEY"));
  final audioPlayer = AudioPlayer();

  /// https://cloud.google.com/text-to-speech/docs/voices

  getAudioPlayer(file) {
    audioPlayer.play(DeviceFileSource(file));
  }

  List<Map<String, dynamic>> voices = [
    {
      "name": "Admiral Venesca Catallia",
      "voiceName": "en-US-Wavenet-C",
      "languageCode": "en-EN",
      "pitch": -2.0,
      "speakingRate": 1.25,
      "audioEncoding": "LINEAR16"
    },
    {
      "name": "Major Razim",
      "voiceName": "en-AU-Wavenet-D",
      "languageCode": "en-AU",
      "audioEncoding": "LINEAR16"
    },
    {
      "name": "Captain Severin",
      "voiceName": "en-AU-Wavenet-J",
      "languageCode": "en-EN",
      "pitch": 8.0,
      "speakingRate": 1.4,
      "audioEncoding": "LINEAR16",
    },
    {
      "name": "Commodore Trevaux",
      "voiceName": "en-AU-Wavenet-J",
      "languageCode": "en-EN",
      "pitch": -7.0,
      "speakingRate": 1.2,
      "audioEncoding": "LINEAR16",
    },
  ];

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
    Map<String, dynamic> voiceOptions = voices.firstWhere(
      (voice) => voice["name"] == textConstructor.getCharacterName(),
      orElse: () => voices.first,
    );

    File file = await _service.textToSpeech(
      text: textConstructor.getCharacterText().toString(),
      voiceName: voiceOptions["voiceName"],
      languageCode: voiceOptions["languageCode"],
      pitch: voiceOptions["pitch"],
      speakingRate: voiceOptions["speakingRate"],
      audioEncoding: voiceOptions["audioEncoding"],
    );

    getAudioPlayer(file.path);
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
