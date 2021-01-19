import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations("en") +
      {
        "en": "Rate this app",
        "nl": "Beoordeel deze app",
      } +
      {
        "en": "If you like the app, please consider giving it a rating in the play store. ",
        "nl": "Vind je dit een tof spel, geef ons een beoordeling in de play store aub",
      } +
      {
        "en": "Hi there!",
        "nl": "Hey daar!",
      } +
      {
        "en": "We would like to hear how we can improve the app for you! Do not hesitate to contact us! We will do our best to provide the best possible experience for all players. ",
        "nl": "We willen graag horen hoe we onze app kunnen verbeteren voor jou!  Aarzel niet om contact met ons op te nemen.",
      } +
      {
        "en": "We are very sorry to hear that you are not satisfied with our app. Please contact us with your issue and we will do our best to improve your experience",
        "nl": "We vinden het spijtig dat je onze app niet leuk vind. Neem aub contact met ons op om je probleem te tonen, we doen ons best om voor iedereen een zo goed mogelijke app te maken",
      } +
      {
        "en": "Close",
        "nl": "Sluit",
      } +
      {
        "en": "Contact us!",
        "nl": "Contacteer ons!",
      } +
      {
        "en": "Change username",
        "nl": "Verander gebruikersnaam",
      } +
      {
        "en": "This name will be shown in the game, make sure others recognise you!",
        "nl": "Deze naam wordt getoond in het spel, zorg ervoor dat anderen je herkennen",
      } +
      {
        "en": "Please enter more then 3 characters",
        "nl": "Gebruik meer dan 3 karakers aub",
      } +
      {
        "en": "Start typing here...",
        "nl": "Begin hier met typen...",
      } +
      {
        "en": "Ask a question...",
        "nl": "Stel een vraag",
      } +
      {
        "en": "Submit",
        "nl": "Bevestig",
      } +
      {
        "en": "You cannot submit an empty question",
        "nl": "Je kan geen lege vraag insturen",
      } +
      {
        "en": "You cannot submit a question shorter than 5 characters",
        "nl": "Je kan geen vraag korter dan 5 karakters insturen",
      } +
      {
        "en": "Cancel",
        "nl": "Annuleer",
      } +
      {
        "en": "End game?",
        "nl": "Stop spel?",
      } +
      {
        "en": "Are you sure to end the game? \nThe game will end for all users.",
        "nl": "Ben je zeker dat je het spel wil eindigen? \nHet spel eindigt voor alle spelers.",
      } +
      {
        "en": "Yes I'm sure",
        "nl": "Ja ik ben zeker",
      } +
      {
        "en": "No members selected",
        "nl": "Geen speler geselecteerd",
      } +
      {
        "en": "No member selected",
        "nl": "Geen speler geselecteerd",
      } +
      {
        "en": "Please make a valid choice",
        "nl": "Maak een geldige keuze aub",
      } +
      {
        "en": "Close",
        "nl": "Sluit",
      } +
      {
        "en": "Group Code",
        "nl": "Groep code",
      } +
      {
        "en": "Join a game with this code:\n\n",
        "nl": "Speel mee met een spel met deze code:\n\n",
      } +
      {
        "en": "",
        "nl": "",
      } +
      {
        "en": "",
        "nl": "",
      };

  String get i18n => localize(this, _t);
}
