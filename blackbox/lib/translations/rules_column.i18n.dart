import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en") +
      {
        "en": "Party Mode",
        "nl": "Party Mode",
      } +
      {
        "en": "Create Game",
        "nl": "Maak een spel",
      } +
      {
        "en": "Join Game",
        "nl": "Meespelen",
      } +
      {
        "en": "Game settings",
        "nl": "Spel instellingen",
      } +
      {
        "en": "Create a local game.",
        "nl": "Maak een lokaal spel",
      } +
      {
        "en": "All players vote one by one. After you have voted, pass the phone to the next player",
        "nl": "Alle spelers stemmen om de beurt. Nadat je gestemd heb, geef je de gsm door aan de volgende speler",
      } +
      {
        "en": "After everyone has voted, go to the results, and a new round starts.",
        "nl": "Als iedereen gestemd heeft, ga naar de resultaten en een nieuwe ronde kan gestart worden.",
      } +
      {
        "en": "Create a new game and invite your friends by sharing the group code",
        "nl": "Maak een neiuw spel, en nodig je vrienden uit door de group code te delen",
      } +
      {
        "en": "Join a game with the 5 character group code",
        "nl": "Speel mee met een spel door de groupcode van 5 karakters in te vullen",
      }
      + {
        "en": "The game creator can enable or disable 'blanco vote'. This is ability for the player to vote blanco",
        "nl": "De spel starter kan blanco voten aan of uit zetten. Dit zorgt ervoor dat je al dan niet een blanco stem kan uitbrengen.",
      } +
      {
        "en": "The game creator can enable or disable 'vote on self'. This controls whether the player is able to cast a vote on himself",
        "nl": "De spel starter kan instellen of je al dan niet op jezelf kan stemmen",
      } +
      {
        "en": "These settings are set in the beginning of the game and cannot be changed during the game",
        "nl": "Deze instellingen worden ingesteld bij het begin van het spel en kunnen niet meer veranderd worden tijdens het spel.",
      } +
      {
        "en": "",
        "nl": "",
      }



  ;

  String get i18n => localize(this, _t);
}