
import 'package:shared_preferences/shared_preferences.dart';

enum configType {
  INT,
  DOUBLE,
  BOOL,
  STRING
}

/// Only a limited amount of data should be stored!
/// Only some primitive types are supported (see below) 
/// int, double, bool, string, (and stringList). Note that the last option is not available in this implementation
class ConfigHandler {


  /// Save a key-value pair to the config file
  /// Returns true upon completion
  static Future< bool > saveData( String key, dynamic value ) async
  {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    if (value is int)
    {
      prefs.setInt(key, value);

    } 
    else if (value is double)
    {
      prefs.setDouble(key, value);

    } 
    else if (value is bool)
    {
      prefs.setBool(key, value);

    } 
    else if (value is String)
    {
      prefs.setString(key, value);

    }

    return true;
  }


  /// Get the value of the given key
  static Future< dynamic > getData( String key, configType type ) async
  {
    final prefs = await SharedPreferences.getInstance();
    
    switch (type)
    {
      
      case configType.INT:
        return prefs.getInt( key )          ?? 0;

      case configType.DOUBLE:
        return prefs.getDouble( key )       ?? 0;

      case configType.BOOL:
        return prefs.getBool( key )         ?? 0;

      case configType.STRING:
        return prefs.getString( key )       ?? 0;

    }
  }



  /// Delete a chosen setting from the file
  /// Returns true upon completion
  static Future< bool > deleteData( String key ) async
  {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove( key );

    return true;
  }


}