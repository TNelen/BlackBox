import 'package:blackbox/DataContainers/QuestionCategory.dart';
import 'package:blackbox/Database/FirebaseGetters.dart';

class QuestionListGetter {

  List<QuestionCategory> categories;  // Holds all categories with all info
  Map<String, List<String>> mappings = Map<String, List<String>>(); // Maps category name to question IDs

  /// Gets all categories with description and all question IDs
  /// Will cache the result to minimise database reads
  Future<List<QuestionCategory>> getCategories() async
  {
    if (categories == null)
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