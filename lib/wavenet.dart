library text_to_speech_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const BASE_URL = 'https://texttospeech.googleapis.com/v1/';

class FileService {
  static Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future<File> createAndWriteFile(String filePath, content) async {
    final path = await _localPath;
    final file = File('$path/$filePath');
    await file.writeAsBytes(content);
    return file;
  }
}

class AudioResponse {
  final String? audioContent;

  AudioResponse(this.audioContent);

  AudioResponse.fromJson(Map<String, dynamic> json)
      : audioContent = json['audioContent'];
}

class TextToSpeechService {
  String? _apiKey;

  TextToSpeechService([this._apiKey]);

  Future<File> _createMp3File(AudioResponse response) async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = '$id.mp3';

    // Decode audio content to binary format and create mp3 file
    var bytes = base64.decode(response.audioContent!);
    return FileService.createAndWriteFile(fileName, bytes);
  }

  _getApiUrl(String endpoint) {
    return Uri.parse('$BASE_URL$endpoint?key=$_apiKey');
  }

  _getResponse(Future<http.Response> request) {
    return request.then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw (jsonDecode(response.body));
    });
  }

  Future availableVoices() async {
    const endpoint = 'voices';
    Future request = http.get(_getApiUrl(endpoint));
    try {
      await _getResponse(request.then((value) => value as http.Response));
    } catch (e) {
      throw (e);
    }
  }

  Future<File> textToSpeech({
    required String text,
    String voiceName = 'de-DE-Wavenet-D',
    String audioEncoding = 'MP3',
    String languageCode = 'de-DE',
    double pitch = 0.00,
    double speakingRate = 1.00,
  }) async {
    const endpoint = 'text:synthesize';
    final bodyMap = <String, dynamic>{
      "input": {
        "text": text,
      },
      "voice": {
        "languageCode": languageCode,
        "name": voiceName,
      },
      "audioConfig": {
        "audioEncoding": audioEncoding,
        "pitch": pitch,
        "speakingRate": speakingRate,
      },
    };

    String body = jsonEncode(bodyMap);
    Future request = http.post(_getApiUrl(endpoint), body: body);

    try {
      var response =
          await _getResponse(request.then((value) => value as http.Response));
      AudioResponse audioResponse = AudioResponse.fromJson(response);
      return _createMp3File(audioResponse);
    } catch (e) {
      throw (e);
    }
  }
}
