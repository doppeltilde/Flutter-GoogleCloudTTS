# wavenet

[![pub package](https://img.shields.io/pub/v/wavenet.svg)](https://pub.dartlang.org/packages/wavenet)

A simple wrapper for Google's
[Text-To-Speech API](https://cloud.google.com/text-to-speech). Simply list the
available voices and convert your text to a mp3 by providing your API key,
language code and voicename.

## Usage

- add the package as a dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  wavenet: ^2.0.5
```

- Initialize the TextToSpeechService:

```dart
TextToSpeechService service = TextToSpeechService('sample api key');
```

- List the available voices:

```dart
await service.availableVoices();
```

They can also be found here: https://cloud.google.com/text-to-speech/docs/voices

- Convert your text to a File object (**api key required**):

```dart
File mp3 = await service.textToSpeech(
  text: 'Hello World',
  voiceName: 'en-GB-Wavenet-F',
  audioEncoding: 'MP3',
  languageCode: 'en-GB'
  pitch: 0.0,
  speakingRate: 1.0,
);
```

## Credits

This is a fork of https://pub.dartlang.org/packages/text_to_speech_api.
