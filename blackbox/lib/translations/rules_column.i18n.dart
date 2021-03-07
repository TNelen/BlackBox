import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations("en") +
      {
        "en": "Settings",
        "nl": "Instellingen",
      } +
    
      {
        "en": "Game ",
        "nl": "Spel",
      } +
      {
        "en": "You can select one or more categories when creating a game.",
        "nl": "Je kan een of meerdere categorieen selecteren wanneer je een spel maakt.",
      } +
      {
        "en":
            "All players vote one by one. After you have voted, pass the phone to the next player",
        "nl":
            "Alle spelers stemmen om de beurt. Nadat je gestemd heb, geef je de gsm door aan de volgende speler",
      } +
      {
        "en":
            "After everyone has voted, go to the results, and a new round starts.",
        "nl":
            "Als iedereen gestemd heeft, ga naar de resultaten en een nieuwe ronde kan gestart worden.",
      } +
     
      {
        "en":
            "The game creator can enable or disable 'blanco vote'. This is ability for the player to vote blanco",
        "nl":
            "De spel starter kan blanco voten aan of uit zetten. Dit zorgt ervoor dat je al dan niet een blanco stem kan uitbrengen.",
      } +
      
      {
        "en": "",
        "nl": "",
      };

  String get i18n => localize(this, _t);
}
