import 'package:blackbox/Assets/questions.dart';

class OfflineGroupData {
  QuestionList questionList;

  List<String> players;

  Map<String, int> totalVotes = Map();

  Map<String, int> currentVotes = Map();

  Question currentQuestion;

  bool canVoteBlank;

  bool ended = false;

  OfflineGroupData(
      List<String> players, QuestionList questionList, bool canVoteBlank) {
    this.questionList = questionList;
    this.players = players;
    this.canVoteBlank = canVoteBlank;

    //initialize current and totalVotes map
    for (String player in players) {
      totalVotes.putIfAbsent(player, () => 0);
      currentVotes.putIfAbsent(player, () => 0);
    }

    currentQuestion = questionList.getRandomNextQuestion();
  }

  //clear current votes
  void nextRound() {
    currentVotes.forEach((name, votes) {
      currentVotes[name] = 0;
    });

    currentQuestion = questionList.getRandomNextQuestion();

    if (questionList.getRemainingQuestions() == 0) {
      ended = true;
    }
  }

  bool isGameEnded() {
    return ended;
  }

  Map<String, int> getCurrentVotes() {
    return currentVotes;
  }

  Map<String, int> getTotalVotes() {
    return totalVotes;
  }

  List<String> getCurrentRanking() {
    List<String> playerList = currentVotes.keys.toList();
    playerList.sort((
      a,
      b,
    ) =>
        currentVotes[b].compareTo(currentVotes[a]));
    return playerList;
  }

  List<String> getAlltimeRanking() {
    List<String> playerList = totalVotes.keys.toList();
    playerList.sort((
      a,
      b,
    ) =>
        totalVotes[b].compareTo(totalVotes[a]));

    return playerList;
  }

  Question getCurrentQuestion() {
    return currentQuestion;
  }

  QuestionList getQuestionList() {
    return questionList;
  }

  void vote(String playerName) {
    currentVotes[playerName]++;
    totalVotes[playerName]++;
  }

  List<String> getPlayers() {
    return players;
  }

  int getAmountOfCurrentVotes() {
    int amount = 0;
    currentVotes.forEach((name, votes) {
      amount += votes;
    });
    return amount;
  }

  int questionsLeft() {
    return questionList.getRemainingQuestions();
  }
}
