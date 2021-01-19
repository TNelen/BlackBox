import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en") +
      {
        "en": "Rules",
        "nl": "Spelregels",
      } +
      {
        "en": "Back",
        "nl": "Terug",
      }
  ;

  String get i18n => localize(this, _t);
}