import 'dart:math';
import 'package:blackbox/translations/questions.i18n.dart';

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
  "Who will be/was a virgin the longest?".i18n,
  "Who is the next person to fuck someone?".i18n,
  "Who is the next person to visit a strip club?".i18n,
  "Who is the horniest?".i18n,
  "Who cares most about being attractive to the other sex?".i18n,
  "Who has the most exes?".i18n,
  "Who would send nudes?".i18n,
  "Who is the first to get kids?".i18n,
  "Who is most likely to get an accidental kid?".i18n,
  "Who needs the most abortion pills?".i18n,
  "Who is most likely to be gay?".i18n,
  "Who has kissed the most different people?".i18n,
  "Who's most into one night stands?".i18n,
  "Who is the biggest hoe?".i18n,
  "Who would be a sugar daddy/mommy?".i18n,
  "If you have to kiss someone of the same sex, who would it be?".i18n,
  "Who has the most attractive booty?".i18n,
  "Who has had the most bed partners?".i18n,
  "Who dresses most seductive?".i18n,
  "Who would you like to see naked?".i18n,
  "Who would have sex in public?".i18n,
];

List<String> BeerOClock = [
  "Who does the most embarrassing things when drunk?".i18n,
  "Who would pass out first when drinking tequila?".i18n,
  "You need to empty 3 bottles of tequila, who's definitely in your squad?".i18n,
  "Who is most likely to kiss someone on a drunk night?".i18n,
  "Who is going to get wasted tonight?".i18n,
  "Who would drink any cocktail?".i18n,
  "Who is the biggest beer fan?".i18n,
  "Who would kiss someone of the same sex on a drunk night?".i18n,
  "Who would go home with a random person after a party?".i18n,
  "Who can twerk best when drunk?".i18n,
  "Who is most resistant to alcohol?".i18n,
  "Who is least resistant to alcohol?".i18n,
  "Who will be the first to have a hangover?".i18n,
  "Who cannot admit that he/she is drunk?".i18n,
  "Who is most likely to get kicked out of a bar?".i18n,
  "Who is the biggest party animal?".i18n,
  "Who can drink the most beer in an hour?".i18n,
  "Who tried the most different beers?".i18n,
  "Who is most likely to drink him/herself unconscious?".i18n,
  "Who is the first to go all-out at a party?".i18n

];

List<String> CharacterTraits = [
  "Who is best at nagging?".i18n,
  "Who is the most romantic?".i18n,
  "Who is the biggest cry baby?".i18n,
  "Who is most patient?".i18n,
  "Who is the prettiest?".i18n,
  "Who has the most secrets?".i18n,
  "Who has to be taken down a notch?".i18n,
  "Who is most trustworthy?".i18n,
  "Who is most talkative?".i18n,
  "Who behaves most grown up?".i18n,
  "Who is most likely to lie in this game?".i18n,
  "Who is the clumsiest?".i18n,
  "Who is always late?".i18n,
  "Who would die saving someone?".i18n,
  "Who is the sweetest?".i18n,
  "Who is the most honest?".i18n,
  "Who is most religious?".i18n,
  "Whose eyes are the prettiest?".i18n,
  "Who is the most stress resistant?".i18n,
  "Who is most likely to be a gang member?".i18n,
  "Who cares most about what people think of him/her?".i18n,
  "Who is most impatient?".i18n,
  "Who is the loudest snorer?".i18n,
  "Who is netflix addicted?".i18n,
  "Who is the funniest?".i18n,
];

List<String> SuperStar = [
  "Who knows the most songs by title?".i18n,
  "With who do you want to change lives for a day?".i18n,
  "Who will be the first at the cover of a magazine?".i18n,
  "Who will get married first?".i18n,
  "Who is best at karaoke?".i18n,
  "Who was always the teacher's favorite?".i18n,
  "Who would be a good TV personality?".i18n,
  "Who has the best taste in fashion?".i18n,
  "Who would be a good politician?".i18n,
  "Who would be a good king?".i18n,
  "Who will become the richest?".i18n,
  "Who smells best?".i18n,
  "Who will get famous?".i18n,
  "Who is best at sports?".i18n,
  "Who has the most luck in games?".i18n,
  "Who has the best dance moves?".i18n,
  "Who do you consider smartest?".i18n,
  "Who is most likely accomplish great things for humanity?".i18n,
  "Who is most likely to get tiktokfamous?".i18n,
  "Who is the happiest?".i18n,
  "Who do you look up to the most?".i18n,
  "Who is best in solving disputes?".i18n,
];

List<String> Casual = [
  "Who would die first in a horror movie?".i18n,
  "Who has never peed in a pool?".i18n,
  "Who sucks at skiing?".i18n,
  "Who is most likely to live abroad?".i18n,
  "Who is most likely to spend a whole day watching netflix?".i18n,
  "Who needs most sleep?".i18n,
  "Who is most addicted to gaming?".i18n,
  "Who will live in the biggest house?".i18n,
  "Who drives like a maniac?".i18n,
  "Who will become a junkie?".i18n,
  "Who looks like a gang member?".i18n,
  "Who is most likely to give his/her money to a good cause?".i18n,
  "Who do you know best?".i18n,
  "Who is most likely to survive if war breaks out?".i18n,
  "With whom would you rather live on a deserted island?".i18n,
  "Who will get the most children?".i18n,
  "Who can best sing along with Old Town Road by Lil Nas X?".i18n,
  "Who spends the most amount of money on useless things?".i18n,
  "Who is the biggest Game Of Thrones fan?".i18n,
  "Who is the best discussion partner for an evening of philosophizing at the bar, with who can you have endless conversations?".i18n,
  "Who cannot be left alone in a kitchen?".i18n,
  "Who is the biggest wuss?".i18n,
  "Who will end up broke?".i18n,
  "Who is most interested in politics?".i18n,
  "Who is most organised?".i18n,
  "Who is a mom's baby?".i18n,
  "Who is most into tech?".i18n,
  "Who is most skilled in shooter games?".i18n,
  "Which person is most likely to get a speeding ticket?".i18n,
  "Who did you know first?".i18n,
  "Who would be most fun on a road trip?".i18n,
  "Who would win a free-for-all fight in this group?".i18n,
  "Who is going to become famous?".i18n,
];

List<String> FriendshipKillers = [
  "Who would you not take to a deserted island?".i18n,
  "Who has the hottest boy/girlfriend?".i18n,
  "Who is most likely to get punched at a party?".i18n,
  "Who is most likely to cheat on someone?".i18n,
  "Who acts most gay?".i18n,
  "For who are you ashamed?".i18n,
  "Who is the first to be cheated upon?".i18n,
  "If you have to kill one person, who would it be?".i18n,
  "Who is the least successful in life?".i18n,
  "Who pretends to be living a perfect life?".i18n,
  "Who makes hir/her life look better on Instagram?".i18n,
  "Who would you kiss?".i18n,
  "Who cannot live without social media attention?".i18n,
  "Who would you couple up with?".i18n,
  "Who is most aggressive?".i18n,
  "Who is going to die alone?".i18n,
  "Who can be the most annoying?".i18n,
  "Who is the fattest?".i18n,
  "Who is least intelligent?".i18n,
  "Who lovest drugs more than family?".i18n,
  "Who is the biggest show off?".i18n,
  "Who is a terrible wing (wo)man?".i18n,
  "Who would you definitely not couple up with?".i18n,
  "Who is a complete jackass?".i18n,
  "Who has the saddest future?".i18n,
  "Who has the highest chance of falling into a depression?".i18n,
  "Who has the most chance of becoming an alcohol addict?".i18n,
  "Who has the ugliest nose?".i18n,
  "Who's the first to become incontinent?".i18n,
  "Who is the last person you miss at an event?".i18n,
  "Who has the ugliest girlfriend/boyfriend".i18n,
];


List<Category> categories = [
  Category("Casual".i18n, "General black box questions, a rather soft category. Great to get started".i18n, Casual),
  Category("Character traits".i18n, "Questions about your friends’ character traits".i18n, CharacterTraits),
  Category("Superstar".i18n, "Admire your friends’ actions or abilities".i18n, SuperStar),
  Category("Friendship killers".i18n, "The biggest friendship test, your friendship can handle everything if it survives this category".i18n, FriendshipKillers),
  Category("Beer o'clock".i18n, "Questions related to drinking, partying and nightlife".i18n, BeerOClock),
  Category("+18".i18n, "Spicy questions, aimed at adults".i18n, EighteenPlus),
];
