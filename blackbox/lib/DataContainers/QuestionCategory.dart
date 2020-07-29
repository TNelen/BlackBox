class QuestionCategory {

  final String name;
  final String description;
  final List<String> _questionIDs;
  final int amount;

  QuestionCategory(this.name, this.description, this._questionIDs) : amount = _questionIDs.length;
  QuestionCategory.community(): name='Community', description='A category for user created questions', _questionIDs = List<String>(), amount=0;

  List<String> getQuestionIDs() {
    return _questionIDs;
  }

}