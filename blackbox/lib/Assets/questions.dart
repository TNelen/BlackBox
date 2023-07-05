import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Constants.dart';

class Category {
  String categoryName;
  String description;
  List<String> questions;
  bool isNew;
  IconData icon;
  Color color;
  Color titleColor;

  Category({required this.categoryName, required this.description, required this.questions, this.isNew = false, required this.icon, required this.color, this.titleColor = Colors.white});

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

        Question returning = Question(questionString, questionsList[questionString]!);
        questionsList.remove(questionString);

        return returning;
      } else {
        var questions = questionsList.keys.toList()..shuffle();
        var questionString = questions[0];
        var question = Question(questionString, questionsList[questionString]!);
        //remove from list
        questionsList.remove(questionString);
        return question;
      }
    } else {
      var questions = questionsList.keys.toList()..shuffle();
      var questionString = questions[0];
      var question = Question(questionString, questionsList[questionString]!);
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
  "Who has kissed the most different people?",
  "Who's most into one night stands?",
  "Who is the biggest hoe?",
  "Who would be a sugar daddy/mommy?",
  "If you have to kiss someone of the same sex, who would it be?",
  "Who has the most attractive booty?",
  "Who has had the most bed partners?",
  "Who dresses most seductive?",
  "Who would you like to see naked?",
  "Who is most likely to have sex in public?",
  "Who is most active on Tinder",
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
  "Who is most resistant to alcohol?",
  "Who is least resistant to alcohol?",
  "Who will be the first to have a hangover?",
  "Who cannot admit that he/she is drunk?",
  "Who is most likely to get kicked out of a bar?",
  "Who is the biggest party animal?",
  "Who can drink the most beer in an hour?",
  "Who tried the most different beers?",
  "Who is most likely to drink him/herself unconscious?",
  "Who is the first to go all-out at a party?",
  "Who is most likely to end up in a fight?",
];

List<String> CharacterTraits = [
  "Who is best at nagging?",
  "Who is most romantic?",
  "Who is the biggest cry baby?",
  "Who is most patient?",
  "Who is the prettiest?",
  "Who has the most secrets?",
  "Who is most trustworthy?",
  "Who is most talkative?",
  "Who behaves most grown up?",
  "Who is most ambitious?",
  "Who is most likely to lie in this game?",
  "Who is the clumsiest?",
  "Who is always late?",
  "Who is the biggest workaholic?",
  "Who would die saving someone?",
  "Who is the sweetest?",
  "Who is most honest?",
  "Who is most religious?",
  "Whose eyes are the prettiest?",
  "Who is most stress resistant?",
  "Who is most likely to be a gang member?",
  "Who cares most about what people think of him/her?",
  "Who is most impatient?",
  "Who is the loudest snorer?",
  "Who is netflix addicted?",
  "Who is the funniest?",
  "Who is Instagram addicted?",
];

List<String> SuperStar = [
  "Who is most likely to break a world record?",
  "Who knows the most songs by title?",
  "Who is the sportiest?"
      "With who do you want to change lives for a day?",
  "Who will be the first at the cover of a magazine?",
  "Who will get married first?",
  "Who is best at karaoke?",
  "Who was always the teacher's favorite?",
  "Who would be a good TV personality?",
  "Who is most likely to become president?",
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
  "Who do you look up to?"
];

List<String> Casual = [
  "Who is wearing the nicest outfit right now?",
  "Who would die first in a horror movie?",
  "Who is most likely to never have kids?",
  "Who is most likely to have visited the largest number of countries?",
  "Who is most likely to live abroad?",
  "Who is most likely to spend a whole day watching netflix?",
  "Who needs most sleep?",
  "Who is most addicted to gaming?",
  "Who will live in the biggest house?",
  "Who drives like a maniac?",
  "Who will become a drug addicated?",
  "Who looks like a gang member?",
  "Who is most likely to give his/her money to charity?",
  "Who do you know best?",
  "Who is most likely to survive if war breaks out?",
  "With whom would you rather live on a deserted island?",
  "Who will get the most children?",
  "Who spends the most amount of money on useless things?",
  "Who is the biggest Game Of Thrones fan?",
  "Who is the best discussion partner for an evening of philosophizing at the bar, with who can you have endless conversations?",
  "Who cannot be left alone in a kitchen?",
  "Who is the biggest wuss?",
  "Who will end up broke?",
  "Who is most into politics?",
  "Who is most likely to run a marathon?",
  "Who is most likely to call in sick at work but really be at the beach?",
  "Who is most likely to become a CEO at a top company?",
  "Who is most organised?",
  "Who is a mom's baby?",
  "Who is most into tech?",
  "Who is most skilled in shooter games?",
  "Which person is most likely to get a speeding ticket?",
  "Who did you know first?",
  "Who would be most fun on a road trip?",
  "Who would win a free-for-all fight in this group?",
  "Who is going to become famous?",
  "Who is most likely to lead a protest?",
  "Who is most likely to get the most tattoos?",
  "Who is most likely to not forget your birthday?",
  "Who is most likely to know exactly what to say when you're feeling sad?",
  "Who is most likely to win a game show?",
  "Who is most likely to forget to text back?",
  "Who is the first to break New Year's resolutions?",
];

List<String> FriendshipKillers = [
  "Who would you not take to a deserted island?",
  "Who has the hottest boy/girlfriend?",
  "Who is most likely to get punched at a party?",
  "Who is most likely to cheat on someone?",
  "For who are you ashamed?",
  "Who is the first to be cheated upon?",
  "If you have to kill one person, who would it be?",
  "Who is the least successful in life?",
  "Who pretends to be living a perfect life?",
  "Who makes his/her life look better on Instagram?",
  "Who would you kiss?",
  "Who cannot live without social media attention?",
  "Who would you couple up with?",
  "Who is most aggressive?",
  "Who is going to die alone?",
  "Who can be the most annoying?",
  "Who is the fattest?",
  "Who is least intelligent?",
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

List<String> Family = [
  "Who does the least amount of chores in the house?",
  "Who decides what to watch on TV?",
  "Who makes the most mess in the house?",
  "Who is the most handy of the family?",
  "Who sleeps the longest on a free day?",
  "Who is home most often?",
  "Who can cook best?",
  "Who should do the dishes more often?",
  "Who makes the most noise?",
  "Who invites the most friends?",
  "Who has the prettiest room?",
  "Who has the best spot in the sofa?",
  "Who complains most about dinner?",
  "Who stays up longest?",
  "Who is most picky about what they like to eat?",
  "Who drinks the most beer?",
  "Who drinks the most coffee?",
  "Who skips breakfast the most?",
  "Who spends the most time in the garden?",
];

List<String> SummerThrowback = [
  "Who's vacation are you jealous of?",
  "Who is most tanned?",
  "Who had the most active vacation?",
  "Who traveled the furthest?",
  "Who visited the coolest place?",
  "Whose vacation was the most boring?",
  "Who found a summer romance?",
  "Who was away from home the longest?",
  "Who visited the most different countries?",
  "Who spend the most expensive holiday?",
  "Who had the most adventurous holiday?",
  "Who cannot disconnect from work during holidays?",
  "Who drove the furthest by car?",
  "Who took the most plane flights?",
];

List<String> Christmas = [
  "Who is most into Christmas?",
  "Who has the most beautiful Christmas decoration at home?",
  "Who gets the most Christmas presents?",
  "Who is most likely to sneak a peek at their Christmas presents before the big day?",
  "Who is best at ice skating?",
  "Who can cook the best Christmas meal?",
  "who has the most end of year parties?",
  "Who is most likely to start a Christmas movie marathon and watch them all back-to-back?",
  "Who is most likely to donate toys to less fortunate children?",
  "Who is most into Christmas movies?",
  "Who is most likely to send out the most Christmas cards to friends and family?",
  "Who is most likely to attend a Christmas Eve church service?",
  "Who is most likely to build a snow man in their front yard?",
  "Who has the most ideas on their wish list?",
  "Who is most likely to listen to sing along with Christmas music?",
  "Who has the most beautiful Christmas sweater?",
  "Who has the biggest Christmas tree at home?",
];

List<Category> categories = [
  Category(
    categoryName: "Family",
    description: "Have fun with your household",
    questions: Family,
    icon: FontAwesomeIcons.home,
    color: Constants.categoryColors[0],
  ),
  Category(
    categoryName: "Holiday Season",
    description: "Enjoy these Christmas themed questions",
    questions: Christmas,
    icon: FontAwesomeIcons.candyCane,
    color: Constants.categoryColors[7],
    titleColor: Color.fromARGB(255, 54, 158, 13),
    isNew: true,
  ),
  Category(
    categoryName: "Casual",
    description: "General black box questions. Great to get started",
    questions: Casual,
    icon: FontAwesomeIcons.hatCowboy,
    color: Constants.categoryColors[1],
  ),
  Category(
    categoryName: "Superstar",
    description: "Admire your friends’ actions or abilities",
    questions: SuperStar,
    icon: FontAwesomeIcons.trophy,
    color: Constants.categoryColors[2],
  ),
  Category(
    categoryName: "Summer throwback",
    description: "Relive the summer",
    questions: SummerThrowback,
    icon: FontAwesomeIcons.umbrellaBeach,
    color: Constants.categoryColors[5],
  ),
  Category(
      categoryName: "Character traits",
      description: "Questions about your friends’ character traits",
      questions: CharacterTraits,
      icon: FontAwesomeIcons.userSecret,
      color: Constants.categoryColors[3]),
  Category(categoryName: "Friendship killers", description: "The biggest friendship test!", questions: FriendshipKillers, icon: FontAwesomeIcons.heartBroken, color: Constants.categoryColors[4]),
  Category(
      categoryName: "Beer o'clock",
      description: "Questions related to drinking, partying and nightlife",
      questions: BeerOClock,
      icon: FontAwesomeIcons.glassCheers,
      color: Constants.categoryColors[5]),
  Category(categoryName: "+18", description: "Spicy questions, aimed at adults", questions: EighteenPlus, icon: FontAwesomeIcons.kissWinkHeart, color: Constants.categoryColors[6]),
];
