library text_to_speech_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const BASE_URL = 'https://texttospeech.googleapis.com/v1/';
var client = HttpClient();

class FileService {
  static Future<String> get _localPath async {
    // Returns the path to the system's temporary directory
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future<File> createAndWriteFile(String filePath, content) async {
    // Creates a new file in the temporary directory and writes the given content to it
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
    // Creates an MP3 file from the given audio response
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = '$id.mp3';

    // Decodes the audio content to binary format and creates an MP3 file
    var bytes = base64.decode(response.audioContent!);
    return FileService.createAndWriteFile(fileName, bytes);
  }

  _getApiUrl(String endpoint) {
    // Returns the API URL for the given endpoint
    return Uri.parse('$BASE_URL$endpoint?key=$_apiKey');
  }

  Future<Map<String, dynamic>> _getResponse(
      Future<HttpClientRequest> request) async {
    // Sends the given request and returns the response body if the status code is 200, otherwise throws an error
    final req = await request;
    final res = await req.close();
    if (res.statusCode == 200) {
      return jsonDecode(await res.transform(utf8.decoder).join());
    }
    throw (jsonDecode(await res.transform(utf8.decoder).join()));
  }

  Future availableVoices() async {
    // Gets a list of available voices
    const endpoint = 'voices';
    final request = client.getUrl(_getApiUrl(endpoint));
    try {
      // Sends the request and returns the response body
      await _getResponse(request.then((value) => value));
    } catch (e) {
      throw (e);
    }
  }

  Future<File> textToSpeech({
    required String text,

    /// Voice name.
    ///
    /// See https://cloud.google.com/text-to-speech/docs/voices for more info.
    String voiceName = 'de-DE-Wavenet-D',

    /// Country language code.
    ///
    /// See https://cloud.google.com/text-to-speech/docs/voices for more info.
    String audioEncoding = 'MP3',

    /// Country language code.
    ///
    /// See https://cloud.google.com/text-to-speech/docs/voices for more info.
    String languageCode = 'de-DE',

    /// Pitch the voice.
    ///
    /// Ranges from -20 to 20.
    double pitch = 0.0,
    double speakingRate = 1.0,
  }) async {
    // Converts text to speech
    const endpoint = 'text:synthesize';

    // Constructs the request body
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

    final request = await client.postUrl(_getApiUrl(endpoint))
      // Set the content type to JSON
      ..headers.contentType = ContentType.json
      // Write the request body to the request
      ..write(jsonEncode(bodyMap));

    try {
      // Send the request and get the response
      final response = await request.close();
      if (response.statusCode == 200) {
        // If the status code is 200, process the response
        final audioResponse = AudioResponse.fromJson(
            jsonDecode(await response.transform(utf8.decoder).join()));
        return _createMp3File(audioResponse);
      }
      // If the status code is not 200, throw an error
      throw (jsonDecode(await response.transform(utf8.decoder).join()));
    } catch (e) {
      // Catch any errors that occur while sending the request or processing the response
      throw (e);
    } finally {
      // Close the client when we are done
      client.close();
    }
  }
}
