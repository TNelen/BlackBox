import 'package:blackbox/DataContainers/QuestionCategory.dart';
import 'package:blackbox/Database/FirebaseGetters.dart';

class QuestionListGetter {

  List<QuestionCategory> categories;  // Holds all categories with all info
  Map<String, List<String>> mappings = Map<String, List<String>>(); // Maps category name to question IDs

  static final QuestionListGetter _buffer = QuestionListGetter._internal();

  QuestionListGetter._internal() : categories = List<QuestionCategory>();

  factory QuestionListGetter()
  {
    return QuestionListGetter._internal();
  }

  Future<List<String>> getCategoryNames() async
  {
    List<String> names = List<String>();
    List<QuestionCategory> categories = await getCategories();
    for (QuestionCategory cat in categories)
      names.add( cat.name );

    return names;
  }

  QuestionCategory getCategoryByName(String name)
  {
    for (QuestionCategory cat in categories)
      if (name == cat.name)
        return cat;
      
    return QuestionCategory.community();
  }

  /// Gets all categories with description and all question IDs
  /// Will cache the result to minimise database reads
  Future<List<QuestionCategory>> getCategories() async
  {
    if (categories == null || categories.length == 0)
    {
      categories = await FirebaseGetters.getQuestionCategories();

      mappings = Map<String, List<String>>();
      for (QuestionCategory category in categories)
      {
        mappings[category.name] = category.getQuestionIDs();
      }
    }
    
    return categories;
  }

}