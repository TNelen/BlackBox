class Question {

  String _questionID  = "";
  String _question    = "";
  String _category    = "";
  String _creatorID   = "";
  String _creatorName = "";

  /// ------------ \\\
  /// Constructors \\\
  /// ------------ \\\


  /// Create a Question by providing all data
  Question(this._questionID, this._question, this._category, this._creatorID, this._creatorName);


  /// Create a basic question
  /// Category will be set to: Default
  /// CreatorID and name will be set to an empty String
  Question.basic(this._questionID, this._question) {
    _category = "Default";
  }


  /// Create an empty question
  /// All fields will be set to an empty String
  Question.empty();


  /// ------- \\\
  /// Getters \\\
  /// ------- \\\
  
  /// Get the ID of the current question
  String getQuestionID()
  {
    return _questionID;
  }

  /// Get the question
  String getQuestion()
  {
    return _question;
  }
  
  /// Get the category of this question
  String getCategory()
  {
    return _category;
  }

  /// Get the unique internal ID of the creator
  /// Returns an empty String if not applicable
  String getCreatorID()
  {
    return _creatorID;
  }

  /// Get the name of the creator
  /// Returns an empty String if not applicable
  String getCreatorName()
  {
    return _creatorName;
  }
}