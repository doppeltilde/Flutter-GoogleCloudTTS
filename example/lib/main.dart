import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:example/speech/speechText.dart';
import 'package:flutter/material.dart';
import 'package:wavenet/wavenet.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:dart_vlc/dart_vlc.dart';

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
  Player? player;
  TextToSpeechService _service =
      TextToSpeechService('AIzaSyBR0FzxZuCpSRT7TVembrDSdyiy8wzYniU');
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void didChangeDependencies() {
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
      super.didChangeDependencies();
      player = Player(
        id: 0,
      );
    }
  }

  /// https://cloud.google.com/text-to-speech/docs/voices

  _playDemo() async {
    setState(() {
      if (textConstructor.isFinished() != true) {
        textConstructor.nextQuestion();
      }
    });
    print(textConstructor.getCharacterName());
    if (textConstructor.getCharacterName()!.contains("Catallia")) {
      File file = await _service.textToSpeech(
        text: textConstructor.getCharacterText().toString(),
        voiceName: "en-US-Wavenet-C",
        languageCode: "en-EN",
      );
      if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
        print(file.path);
        await player?.open(
          await Media.file(File(file.path)),
        );
      } else {
        _audioPlayer.play(file.path, isLocal: true);
      }
    } else if (textConstructor.getCharacterName()!.contains("Razim")) {
      File file = await _service.textToSpeech(
        text: textConstructor.getCharacterText().toString(),
        voiceName: "en-US-Wavenet-J",
        languageCode: "en-EN",
      );
      if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
        print(file.path);
        await player?.open(
          await Media.file(File(file.path)),
        );
      } else {
        _audioPlayer.play(file.path, isLocal: true);
      }
    } else if (textConstructor.getCharacterName()!.contains("Trevaux")) {
      File file = await _service.textToSpeech(
        text: textConstructor.getCharacterText().toString(),
        voiceName: "en-GB-Wavenet-D",
        languageCode: "en-GB",
      );
      if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
        print(file.path);
        await player?.open(
          await Media.file(File(file.path)),
        );
      } else {
        _audioPlayer.play(file.path, isLocal: true);
      }
    } else {
      File file = await _service.textToSpeech(
        text: textConstructor.getCharacterText().toString(),
        voiceName: "en-US-Wavenet-I",
        languageCode: "en-EN",
      );
      if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
        print(file.path);
        await player?.open(
          await Media.file(File(file.path)),
        );
      } else {
        _audioPlayer.play(file.path, isLocal: true);
      }
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
            Text(
              'Press the play button to speak a demo text.',
            ),
            Text(
              'Hi',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playDemo,
        tooltip: 'Play Demo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
