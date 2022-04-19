import 'package:example/speech/core_speech.dart';

class TextConstructor1 {
  int textNumber = 0;

  static const mc = "MC";
  static const severin = "Captain severin";
  static const catallia = "Admiral Venesca Catallia";
  static const razim = "Major Razim";
  static const tre = "Commodore Trevaux";
  static const t = "Side Character";
  static const ambience = "...";

  List<Speech> textBank = [
    // Name, Speech, Voice, Image
    Speech(
      characterName: severin,
      characterText: "...",
    ),
    Speech(
        characterName: severin,
        characterText: "Admiral! This is madness!",
        voice: "silence"),
    Speech(
      characterName: severin,
      characterText:
          "Entering realspace so close to a planet? You'll doom us all!",
      voice: "silence",
    ),

    Speech(
        characterName: catallia,
        characterText: "A good officer commands without doubt…"),
    Speech(
      characterName: catallia,
      characterText: "…and obeys without question.",
    ),
    Speech(
      characterName: razim,
      characterText: "Entering realspace in 3,2,1",
    ),
    Speech(
      characterName: severin,
      characterText: "Blessed Emperor! We're in the heart of the fight!",
    ),
    Speech(
      characterName: catallia,
      characterText: "This is Admiral Catallia to battlegroup Silver Dawn!",
    ),
    Speech(
      characterName: catallia,
      characterText: "Form up!",
    ),

    Speech(
      characterName: severin,
      characterText: "Incoming enemy squadrons!",
    ),
    Speech(
      characterName: catallia,
      characterText: "Brace for impact!",
    ),
    Speech(
      characterName: severin,
      characterText: "We've lost the Purity Blade!",
    ),
    Speech(
      characterName: catallia,
      characterText:
          "Silver Dawn to Cadian High Command. Where do you need us?",
    ),
    Speech(
      characterName: severin,
      characterText: "This battle is lost! We must disengage!",
    ),
    Speech(
      characterName: catallia,
      characterText: "Coward!",
    ),
    Speech(
      characterName: catallia,
      characterText: "Commissar! Do your duty!",
    ),
    Speech(
      characterName: "Commisar",
      characterText: "As the Emperor wills!",
    ),
    Speech(
        characterName: tre,
        characterText: "Phalanx to Silver Dawn. This is Commodore Trevaux."),
    Speech(
      characterName: tre,
      characterText: "Situation critical.",
    ),
    Speech(
      characterName: tre,
      characterText: "Chaos forces have launched a full-scale planetstrike.",
    ),
    Speech(
      characterName: tre,
      characterText: "They aim to destroy the pylons of the Elysion Fields.",
    ),
    Speech(
      characterName: tre,
      characterText: "They must not succeed.",
    ),
    Speech(
      characterName: tre,
      characterText:
          "Reinforce the position, the Phalanx will cover your back.",
    ),
    Speech(
      characterName: tre,
      characterText:
          "Remain vigilant. We have reports that the Despoiler leads the assault.",
    ),
    Speech(
      characterName: tre,
      characterText:
          "Tremble before the majesty of the Emperor! For we all walk in His immortal shadow!",
    ),
    Speech(
      characterName: tre,
      characterText: "The Emperor Protects!",
    ),
    Speech(
      characterName: catallia,
      characterText: "The Emperor Protects!",
    ),
    Speech(
      characterName: catallia,
      characterText: "Silver Dawn! This is the Admiral. All ahead full!",
    ),
  ];

  void nextQuestion() {
    if (textNumber < textBank.length - 1) {
      textNumber++;
    }
  }

  String? getCharacterText() {
    return textBank[textNumber].characterText;
  }

  String? getCharacterName() {
    return textBank[textNumber].characterName;
  }

  bool isFinished() {
    if (textNumber >= textBank.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  getNumber() {
    return textNumber;
  }

  void reset() {
    textNumber = 0;
  }
}
