import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en") +
      {
        "en": "Settings",
        "nl": "Instellingen",
      } +
      {
        "en": "Change username",
        "nl": "Gebruiksernaam",
      } +
      {
        "en": "Notifications",
        "nl": "Meldingen",
      } +
      {
        "en": "Sounds and vibration",
        "nl": "Geluid en trillen",
      } +
      {
        "en": "Sounds",
        "nl": "Geluid",
      } +
      {
        "en": "Vibration",
        "nl": "Trillen",
      } +
      {
        "en": "Personalization",
        "nl": "Personalisatie",
      } +
      {
        "en": "Choose your accent color...",
        "nl": "Kies je accentkleur",
      } +
      {
        "en": "Blue",
        "nl": "Blauw",
      } +
      {
        "en": "Yellow",
        "nl": "Geel",
      } +
      {
        "en": "Red",
        "nl": "Rood",
      } +
      {
        "en": "Green",
        "nl": "Groen",
      } +
      {
        "en": "Back",
        "nl": "Terug",
      }




  ;

  String get i18n => localize(this, _t);
}