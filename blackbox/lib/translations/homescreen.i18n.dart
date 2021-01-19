import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en") +
      {
        "en": "Welcome to BlackBox!",
        "nl": "Welkom bij BlackBox",
      } +
      {
        "en": "Start playing...",
        "nl": "Begin een spel...",
      } +
      {
        "en": "Play with all your friends on one single device",
        "nl": "Speel met iedereen op hetzelfde toestel",
      } +
      {
        "en": "Create Game",
        "nl": "Maak een spel",
      } +
      {
        "en": "Invite friends to a new game",
        "nl": "Nodig vrienden uit voor een nieuw spel",
      } +
      {
        "en": "Join Game",
        "nl": "Meespelen",
      } +
      {
        "en": "Join with the group code",
        "nl": "Zoek spel met de groep code",
      } +
      {
        "en": "Login  ",
        "nl": "Login   ",
      }
     ;

  String get i18n => localize(this, _t);
}