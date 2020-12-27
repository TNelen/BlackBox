import 'package:blackbox/Models/QuestionCategory.dart';

import '../Constants.dart';

import 'UserData.dart';

class Question {
  String _questionID = "";
  String _question = "";
  QuestionCategory _category = QuestionCategory.community();
  String _creatorID = "";
  String _creatorName = "";

  /// ------------ \\\
  /// Constructors \\\
  /// ------------ \\\

  /// ---
  /// Questions when retreived from the database
  /// ---

  /// Create a Question by providing all data
  Question(this._questionID, this._question, this._category, this._creatorID,
      this._creatorName) {
    if (_questionID == null) _questionID = "";
    if (_question == null) _question = "";
    if (_category == null) _category = QuestionCategory.community();
    if (_creatorID == null) _creatorID = "";
    if (_creatorName == null) _creatorName = "";
  }

  /// Create a basic question
  /// Category will be set to: Default
  /// CreatorID and name will be set to an empty String
  Question.basic(this._questionID, this._question);

  /// ---
  /// Questions when empty -> can be used while waiting for Question data
  /// ---
  ///

  /// Create an empty question
  /// All fields will be set to an empty String
  Question.empty();

  /// ---
  /// Questions when creating new questions
  /// ---

  /// Create a question which can be used locally or added to the database
  /// Note that a unique ID must NOT be provided, the database should take care of this
  /// Category will be set to default
  /// User data will be left empty
  Question.addDefault(this._question);

  /// Create a question which can be used locally or added to the database
  /// Note that a unique ID must NOT be provided, the database should take care of this
  /// User data will be left empty
  Question.add(this._question, this._category);

  /// Create a question which can be used locally or added to the database
  /// Note that a unique ID must NOT be provided, the database should take care of this
  /// Category will be set to Category.Community
  /// User data will be those of the provided UserData
  Question.addFromUser(this._question, UserData user) {
    _category = QuestionCategory.community();
    _creatorID = user.getUserID();
    _creatorName = user.getUsername();
  }

  /// ------- \\\
  /// Getters \\\
  /// ------- \\\

  /// Get the ID of the current question
  String getQuestionID() {
    return _questionID;
  }

  /// Get the question
  String getQuestion() {
    return _question;
  }

  /// Get the category of this question as a String
  String getCategory() {
    return _category.name;
  }

  /// Get the instance of the QuestionCategory of this question
  QuestionCategory getCategoryAsCategory() {
    return _category;
  }

  /// Get the unique internal ID of the creator
  /// Returns an empty String if not applicable
  String getCreatorID() {
    return _creatorID;
  }

  /// Get the name of the creator
  /// Returns an empty String if not applicable
  String getCreatorName() {
    return _creatorName;
  }

  /// ------- \\\
  /// Setters \\\
  /// ------- \\\

  /// Set the unique ID of this question
  void setQuestionID(String newID) {
    _questionID = newID;
  }

  /// ------------------ \\\
  /// Database functions \\\
  /// ------------------ \\\

  /// Cast a vote on this question
  Future<bool> castVoteOnQuestion() async {
    return Constants.database.voteOnQuestion(this);
  }
}
