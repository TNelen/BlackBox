import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// This class handles files at a low level
class FileHandler {
  String filePath;
  File file;

  bool isReady;

  /// Open a file with the given name
  /// The correct directory will automagically be chosen
  FileHandler(String fileName) {
    isReady = false;

    /// Start in a non-ready state
    filePath = fileName;

    /// Temporarily use the filename as path. In case an exception occurs and extra info must be provided
    setFile(fileName);

    /// Fetch the file if it exists. Otherwise create the file
  }

  /// Read all contents of the selected file and return them as a List of type String
  /// Will throw an exception if the file has not been fetched yet
  Future<List<String>> readFile() async {
    if (!isReady) {
      throw Exception("The file " + filePath + " is not ready yet! Please try again later!");
    }

    try {
      return await file.readAsLines(encoding: utf8);
    } catch (e) {
      return new List<String>();

      /// If an error occurs: return an empty list
    }
  }

  /// Write a given list of lines to the file
  /// Will throw an exception if the file has not been fetched yet
  /// Will return true upon completion
  Future<bool> write(List<String> lines) async {
    if (!isReady) {
      throw Exception("The file " + filePath + " is not ready yet! Please try again later!");
    }

    if (lines.length == 0) return true;

    // Write the strings to the file
    bool isFirst = true;
    for (String line in lines) {
      if (isFirst) {
        isFirst = false;

        file.writeAsString(line);

        /// Truncate the file and write the first String

      } else {
        file.writeAsString(line, mode: APPEND);

        /// Add the line after the existing lines

      }
    }

    return true;
  }

  /// Choose the file to create/read/write (to)
  /// The filename will automagically be converted to the full path for internal use
  /// Note that you must include an extension like '.txt'!
  void setFile(String filename) async {
    final path = await _getFilePath;

    file = File('$path/' + filename);
    filePath = path;

    isReady = true;
  }

  /// Get the path to the app directory on this OS
  Future<String> get _getFilePath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
