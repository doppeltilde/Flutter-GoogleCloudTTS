import 'package:test/test.dart';
import 'package:wavenet/wavenet.dart';

void main() {
  group('TextToSpeechService', () {
    late TextToSpeechService textToSpeechService;

    setUp(() {
      // Initialize the TextToSpeechService instance before each test
      textToSpeechService = TextToSpeechService();
    });

    test('availableVoices() returns a list of available voices', () async {
      final voices = await textToSpeechService.availableVoices();
      expect(voices, isList);
    });

    test('textToSpeech() creates an MP3 file from text', () async {
      final file =
          await textToSpeechService.textToSpeech(text: 'Hello, world!');
      expect(file, isNotNull);
      expect(file.path.endsWith('.mp3'), isTrue);
    });
  });
}
