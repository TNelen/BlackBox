import 'dart:math';

class Category {
  String categoryName;
  String description;
  List<String> questions;

  Category(this.categoryName, this.description, this.questions);

  String getDescription() {
    return description;
  }

  String getCategoryName() {
    return categoryName;
  }

  List<String> getQuestions() {
    return questions;
  }
}

class Question {
  String question;
  String categoryName;

  Question(this.question, this.categoryName);

  String getQuestion() {
    return question;
  }

  String getCategory() {
    return categoryName;
  }

}


class QuestionList {

  //Categoryname, question
  Map<String, String> questionsList = Map();

  QuestionList(List<Category> categories) {
    for (Category cat in categories) {
      for (String question in cat.getQuestions()) {
        questionsList.putIfAbsent(question, () => cat.getCategoryName());
      }
    }
  }

  ///returns a random next question qnd removes it from the list of questions
  /// Have 1/2 chance that it is a user submitted question if there are any.
  Question getRandomNextQuestion() {
    bool playerQuestionPresent = questionsList.containsValue("A player's question");
    //1/2  chance that the player's question is returned
    if (playerQuestionPresent) {
      var takePlayerQuest = Random().nextBool();
      if (takePlayerQuest) {
        print('taking player question');
        var questionString = questionsList.keys.firstWhere((element) => questionsList[element] == "A player's question");
        //remove from list
        print(questionString);
        print(questionsList[questionString]);

        Question returning = Question(questionString, questionsList[questionString]);
        questionsList.remove(questionString);

        return returning;
      }
      else {
        var questions = questionsList.keys.toList()
          ..shuffle;
        var questionString = questions[0];
        var question = Question(questionString, questionsList[questionString]);
        //remove from list
        questionsList.remove(questionString);
        return question;
      }
    }
    else {
      var questions = questionsList.keys.toList()
        ..shuffle;
      var questionString = questions[0];
      var question = Question(questionString, questionsList[questionString]);
      //remove from list
      questionsList.remove(questionString);
      return question;
    }
  }

  void addQuestion(String question) {
    questionsList.putIfAbsent(question, () => "A player's question");
  }

  int getRemainingQuestions() {
    return questionsList.length;
  }
}

List<String> EighteenPlus = [
  "Who will be/was a virgin the longest?",
  "Who is the next person to fuck someone?",
  "Who is the next person to visit a strip club?",
  "Who is the horniest?",
  "Who cares most about being attractive to the other sex?",
  "Who has the most exes?",
  "Who would send nudes?",
  "Who is the first to get kids?",
  "Who is most likely to get an accidental kid?",
  "Who needs the most abortion pills?",
  "Who is most likely to be gay?",
  "Who has kissed the most different people?",
  "Who's most into one night stands?",
  "Who is the biggest hoe?",
  "Who would be a sugar daddy/mommy?",
  "If you have to kiss someone of the same sex, who would it be?",
  "Who has the most attractive booty?",
  "Who has had the most bed partners?",
  "Who dresses most seductive?",
  "Who would you like to see naked?",
];

List<String> BeerOClock = [
  "Who does the most embarrassing things when drunk?",
  "Who would pass out first when drinking tequila?",
  "You need to empty 3 bottles of tequila, who's definitely in your squad?",
  "Who is most likely to kiss someone on a drunk night?",
  "Who is going to get wasted tonight?",
  "Who would drink any cocktail?",
  "Who is the biggest beer fan?",
  "Who would kiss someone of the same sex on a drunk night?",
  "Who would go home with a random person after a party?",
  "Who can twerk best when drunk?",
  "Who is most resistant to alcohol?",
  "Who is least resistant to alcohol?",
  "Who will be the first to have a hangover?",
  "Who cannot admit that he/she is drunk?",
  "Who is most likely to get kicked out of a bar?",
  "Who is the biggest party animal?",
  "Who can drink the most beer in an hour?",
  "Who wants to fly like a bird when drunk?",
  "Who tried the most different beers?",
  "Who is most likely to drink him/herself unconscious?",
  "Who would have sex in public",
];

List<String> CharacterTraits = [
  "Who is best at nagging?",
  "Who is the most romantic?",
  "Who is the biggest cry baby?",
  "Who is the prettiest?",
  "Who has the most secrets?",
  "Who has to be taken down a notch?",
  "Who is most trustworthy?",
  "Who is most talkative?",
  "Who behaves most grown up?",
  "Who is most likely to lie in this game?",
  "Who is the clumsiest?",
  "Who is always late?",
  "Who would die saving someone?",
  "Who is the sweetest?",
  "Who is the most honest?",
  "Who is most religious?",
  "Whose eyes are the prettiest?",
  "Who is the most stress resistant?",
  "Who is most likely to be a gang member?",
  "Who cares most about what people think of him/her?",
  "Who is most impatient?",
  "Who is the loudest snorer?",
  "Who is netflix addicted?",
  "Who is the funniest?",
  "who is most resistant to stress?",
];

List<String> SuperStar = [
  "Who knows the most songs by title?",
  "Who will get married first?",
  "Who is best at karaoke?",
  "Who was always the teacher's favorite?",
  "Who would be a good TV personality?",
  "Who has the best taste in fashion?",
  "Who would be a good politician?",
  "Who would be a good king?",
  "Who will become the richest?",
  "Who smells best?",
  "Who will get famous?",
  "Who is best at sports?",
  "Who has the most luck in games?",
  "Who has the best dance moves?",
  "Who do you consider smartest?",
  "Who is most likely accomplish great things for humanity?",
  "Who is most likely to get tiktokfamous?",
  "Who is the happiest?",
  "Who do you look up to the most?",
  "Who is best in solving disputes?",
];

List<String> Casual = [
  "Who would die first in a horror movie?",
  "Who has never peed in a pool?",
  "Who sucks at skiing?",
  "Someone farted, who would never confess?",
  "Who would love to take a dump on someones head?",
  "Who is most likely to live abroad?",
  "Who is most likely to spend a whole day watching netflix?",
  "Who needs most sleep?",
  "Who is most addicted to gaming?",
  "Who will live in the biggest house?",
  "Who drives like a maniac?",
  "Who will become a junkie?",
  "Who looks like a gang member?",
  "Who is most likely to give his/her money to a good cause?",
  "Who do you know best?",
  "Who is most likely to survive if war breaks out?",
  "With whom would you rather live on a deserted island?",
  "Who will get the most children?",
  "Who can best sing along with Old Town Road by Lil Nas X?",
  "Who spends the most amount of money on useless things?",
  "Who is the biggest Game Of Thrones fan?",
  "Who is the best discussion partner for an evening of philosophizing at the bar, with who can you have endless conversations?",
  "Who cannot be left alone in a kitchen?",
  "Who is the biggest wuss?",
  "Who will end up broke?",
  "Who is most interested in politics?",
  "Who is most organised?",
  "Who is a mom's baby?",
  "Who is most into tech?",
  "Who is most skilled in shooter games?",
  "Which person is most likely to get a speeding ticket?",
  "Who did you know first?",
  "Who would be most fun on a road trip?",
  "Who would win a free-for-all fight in this group?",
  "Who is going to become famous?",
];

List<String> FriendshipKillers = [
  "Who would you not take to a deserted island?",
  "Who has the hottest boy/girlfriend?",
  "Who is most likely to get punched at a party?",
  "Who is most likely to cheat on someone?",
  "Who acts most gay?",
  "For who are you ashamed?",
  "Who is the first to be cheated upon?",
  "If you have to kill one person, who would it be?",
  "Who is the least successful in life?",
  "Who pretends to be living a perfect life?",
  "Who makes hir/her life look better on Instagram?",
  "Who would you kiss?",
  "Who cannot live without social media attention?",
  "Who would you couple up with?",
  "Who is most aggressive?",
  "Who is going to die alone?",
  "Who can be the most annoying?",
  "Who is the fattest?",
  "Who is least intelligent?",
  "Who lovest drugs more than family?",
  "Who is the biggest show off?",
  "Who is a terrible wing (wo)man?",
  "Who would you definitely not couple up with?",
  "Who is a complete jackass?",
  "Who has the saddest future?",
  "Who has the highest chance of falling into a depression?",
  "Who has the most chance of becoming an alcohol addict?",
  "Who has the ugliest nose?",
  "Who's the first to become incontinent?",
  "Who is the last person you miss at an event?",
  "Who has the ugliest girlfriend/boyfriend",
];


List<Category> categories = [
  Category("Casual", "General black box questions, a rather soft category. Great to get started", Casual),
  Category("Character traits", "Questions about your friends’ character traits", CharacterTraits),
  Category("Superstar", "Admire your friends’ actions or abilities", SuperStar),
  Category("Friendship killers", "The biggest friendship test, your friendship can handle everything if it survives this category", FriendshipKillers),
  Category("Beer o'clock", "Questions related to drinking, partying and nightlife", BeerOClock),
  Category("+18", "Spicy questions, aimed at adults", EighteenPlus),
];
