class QuestionCategory {

  final String name;
  final String description;
  final List<String> _questionIDs;
  final int amount;

  QuestionCategory(this.name, this.description, this._questionIDs) : amount = _questionIDs.length;

  List<String> getQuestionIDs() {
    return _questionIDs;
  }

}