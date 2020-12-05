import 'package:vibration/vibration.dart';

class VibrationHandler {
  static const List<int> defaultPattern = [0, 500];

  /// Vibrate the phone for a given amount of milliseconds if the phone supports it
  static vibrate({List<int> vibratePattern = defaultPattern}) async {
    if (await Vibration.hasVibrator() as bool) {
      /// Check for vibration support
      await Vibration.vibrate(pattern: vibratePattern);
    }
  }
}
