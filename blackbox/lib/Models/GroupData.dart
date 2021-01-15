import 'dart:io';

import 'package:blackbox/Models/QuestionCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackbox/Constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../Models/UserData.dart';
import '../Models/Question.dart';
import 'dart:math';

import 'UserRankData.dart';

class GroupData {
  static final UserData blankUser = UserData("blank_vote", "Blank vote");

  /// ---------------- \\\
  /// GroupData Fields \\\
  /// ---------------- \\\

  /// Game setting: whether users can choose to not vote on another user
  final bool canVoteBlank;

  /// Game setting: whether users can cast a vote on themselves
  final bool canVoteOnSelf;

  /// Name of the group
  String _groupName;

  /// Description of the group
  String _groupDescription;

  /// The unique ID of this group
  String _groupID;

  /// The unique ID of the admin
  String _adminID;

  /// A bool indicating the game state
  bool _isPlaying;

  /// An int indicating when the admin has last voted (milliseconds). Will be null if the admin has not voted yet this round
  int _adminVoteTimestamp;

  /// A list of unique IDs of all members in this group
  Map<String, String> _members = Map<String, String>();

  /// A list of available question id's
  List<String> _questionlist;

  /// Data container for the current/next question
  Question _nextQuestion = Question.empty();

  /// Data container for the previous question
  Question _lastQuestion = Question.empty();

  /// Mapping the voter to the votee (previous round)
  Map<String, String> _lastVotes;

  /// Mapping the voter to the votee (current round)
  Map<String, String> _newVotes;

  /// Mapping unique IDs to the total amount of votes for that user
  Map<String, int> _totalVotes;

  /// A list of all IDs of members that are currently playing
  List<String> _playing;

  /// A map that combines each question (not ID) with another Map that links each username to amount of votes
  Map<String, Map<String, int>> _history;

  /// ---------------------- \\\
  /// GroupData constructors \\\
  /// ---------------------- \\\

  /// Create a group with the given data fields
  GroupData(
      this._groupName,
      this._groupDescription,
      this.canVoteBlank,
      this.canVoteOnSelf,
      this._groupID,
      this._adminID,
      this._members,
      this._questionlist) {
    _isPlaying = true;
    _nextQuestion = Question.empty();
    _lastVotes = Map<String, String>();
    _newVotes = Map<String, String>();
    _totalVotes = Map<String, int>();
    _playing = List<String>();
    _history = Map<String, Map<String, int>>();
    _adminVoteTimestamp = DateTime.now().millisecondsSinceEpoch;
  }

  /// Create a group with the given data fields AND status fields
  GroupData.extended(
      this._groupName,
      this._groupDescription,
      this.canVoteBlank,
      this.canVoteOnSelf,
      this._groupID,
      this._adminID,
      this._isPlaying,
      this._members,
      this._nextQuestion,
      this._lastVotes,
      this._newVotes,
      this._totalVotes,
      this._playing,
      this._questionlist,
      this._adminVoteTimestamp,
      this._history);

  /// ---------------- \\\
  /// Firebase Utility \\\
  /// ---------------- \\\

  /// Create a group from a DocumentSnapshot (Firebase)
  GroupData.fromDocumentSnapshot(DocumentSnapshot snap)
      :

        /// Get basic data
        _groupName = snap.data()['name'] as String ?? "Nameless group",
        _groupDescription =
            snap.data()['description'] as String ?? "No description",
        _groupID = snap.id.toString(),
        _adminID = snap.data()['admin'] as String,
        _isPlaying = snap.data()['isPlaying'] as bool,
        canVoteBlank = snap.data()['canVoteBlank'] as bool,
        canVoteOnSelf = snap.data()['canVoteOnSelf'] as bool,
        _adminVoteTimestamp = snap.data()['adminVoteTimestamp'] as int,

        /// Get status data
        _nextQuestion = Question(
                snap.data()['nextQuestionID'] as String,
                snap.data()['nextQuestion'] as String,
                QuestionCategory(
                    snap.data()['nextQuestionCategory'] as String, '', ['']),
                snap.data()['nextQuestionCreatorID'] as String,
                snap.data()['nextQuestionCreatorName'] as String) ??
            Question.addDefault(snap.data()['nextQuestion'] as String) ??
            Question.empty(),
        _lastQuestion = Question(
                snap.data()['lastQuestionID'] as String,
                snap.data()['lastQuestion'] as String,
                QuestionCategory(
                    snap.data()['lastQuestionCategory'] as String, '', ['']),
                snap.data()['lastQuestionCreatorID'] as String,
                snap.data()['lastQuestionCreatorName'] as String) ??
            Question.addDefault(snap.data()['nextQuestion'] as String) ??
            Question.empty(),
        _members = _convertFirebaseMapString(snap.data()['members']),
        _lastVotes = _convertFirebaseMapString(snap.data()['lastVotes']),
        _newVotes = _convertFirebaseMapString(snap.data()['newVotes']),
        _totalVotes = _convertFirebaseMapInt(snap.data()['totalVotes']),
        _playing = _convertFirebaseList(snap.data()['playing']),
        _questionlist = _convertFirebaseList(snap.data()['questionlist']),
        _history = _convertFirebaseHistory(snap.data()['history']);

  /// Convert a list from a DocumentSnapshot to a List<String>
  /// NO checks are done! Provided parameter MUST be correct
  static List<String> _convertFirebaseList(dynamic data) {
    List<String> list = List<String>();

    for (dynamic element in data) {
      list.add(element as String);
    }

    return list;
  }

  /// Convert a Map from a DocumentSnapshot to a Map<String, int>
  /// NO checks are done! Provided parameter MUST be correct
  static Map<String, int> _convertFirebaseMapInt(dynamic data) {
    /// Initialize lists
    Map<dynamic, dynamic> dbData = data as Map<dynamic, dynamic>;
    Map<String, int> convertedData = Map<String, int>();

    /// Loop the database Map and add values as Strings to the data Map
    dbData.forEach((key, value) {
      convertedData[key.toString()] = value as int;
    });

    return convertedData;
  }

  /// Convert a Map from a DocumentSnapshot to a Map<String, int>
  /// NO checks are done! Provided parameter MUST be correct
  static Map<String, String> _convertFirebaseMapString(dynamic data) {
    /// Initialize lists
    Map<dynamic, dynamic> dbData = data as Map<dynamic, dynamic>;
    Map<String, String> convertedData = Map<String, String>();

    /// Loop the database Map and add values as Strings to the data Map
    dbData.forEach((key, value) {
      convertedData[key.toString()] = value.toString();
    });

    return convertedData;
  }

  /// Convert the history field from a DocumentSnapshot to a Map<String, Map<String, int>>
  /// NO checks are done! Provided parameter MUST be correct
  static Map<String, Map<String, int>> _convertFirebaseHistory(dynamic data) {
    /// Initialize lists
    Map<dynamic, dynamic> dbData = data as Map<dynamic, dynamic>;
    Map<String, Map<String, int>> convertedData =
        Map<String, Map<String, int>>();

    // Loop all earlier questions
    if (dbData != null) {
      dbData.forEach((key, value) {
        Map<String, int> votes = Map<String, int>();
        Map<dynamic, dynamic> dbVotes = value as Map<dynamic, dynamic>;

        // Loop each user with their votes for this question and save them under the question
        dbVotes.forEach((username, numVotes) {
          votes[username.toString()] = numVotes as int;
        });

        convertedData[key.toString()] = votes;
      });
    }

    if (convertedData.length > 0) {
      return convertedData;
    } else {
      return null;
    }
  }

  /// --------------------- \\\
  /// GroupData Information \\\
  /// --------------------- \\\

  /// Set whether or not this group is still active
  /// This action will silently fail for non-admins
  void setIsPlaying(bool playing) {
    if (_adminID == Constants.getUserID()) {
      _isPlaying = playing;
    }
  }

  /// Returns whether the group is still in progress
  /// True when still playing
  /// False when the game is over
  bool getIsPlaying() {
    return _isPlaying;
  }

  ///Get all availbalbe question
  List<String> getQuestionList() {
    return _questionlist;
  }

  void addQuestionToList(String id) {
    Random random = Random(1);
    int min = _questionlist.length - 3;
    int max = _questionlist.length;
    int randomNumber = min + (random.nextInt(max - min));
    _questionlist.insert(randomNumber, id);
  }

  ///Set available questions
  void setQuestionList(List<String> newQuestionsList) {
    _questionlist = newQuestionsList;
  }

  /// Gets the ID of the admin of this group
  String getAdminID() {
    return _adminID;
  }

  /// Get the unique code of this group
  String getGroupCode() {
    return _groupID;
  }

  /// Get the description of this group
  String getDescription() {
    return _groupDescription;
  }

  /// Set the description of this group
  void setDescription(String newDescription) {
    _groupDescription = newDescription;
  }

  /// Get the username of the member with the provided ID
  /// Will return 'User left' when no user is found
  /// will return 'Blank User' when ID =blank_vote
  String getUserName(String ID) {
    String name = _members[ID];
    return name != null
        ? name
        : ID == "blank_vote" ? "Blank User" : "User left";
  }

  /// Get the UserData of all users in this group
  List<UserData> getMembers() {
    List<UserData> users = List<UserData>();

    _members.forEach((id, username) {
      users.add(UserData(id, username));
    });

    return users;
  }

  /// Get all members in this group as a Map
  /// Their IDs will serve as key while their usernames will be the values
  Map<String, String> getMembersAsMap() {
    return _members;
  }

  /// Adds a user to this group if he isn't included yet
  void addMember(UserData user) {
    if (_members.containsKey(user.getUserID())) return;

    _members[user.getUserID()] = user.getUsername();
  }

  /// Removes a user from this group
  /// User will be removed from all lists (all vote lists + playing lists)
  /// If the user that leaves is an admin, a new one will be assigned automatically
  /// If the last user leaves, this group will be deleted from the database!
  void removeMember(UserData user) {
    bool findNewAdmin;

    /// If the leaving user is admin
    if (_adminID == Constants.getUserID()) {
      findNewAdmin = true;
    } else {
      findNewAdmin = false;
    }

    _members.remove(user.getUserID());
    removePlayingUser(user);

    /// Assign a new admin, if necessary
    if (findNewAdmin) {
      if (_members.length > 0) {
        _adminID = _members.keys.first;
      }
    }

    _lastVotes.remove(user.getUserID());
    _newVotes.remove(user.getUserID());
    _totalVotes.remove(user.getUserID());

    if (_members.length == 0) {
      Constants.database.deleteGroup(this);
    }
  }

  /// Returns the history of all questions
  /// The first String contains the question itself (not its ID)
  /// The inner Map links each user to the amount of votes they each got
  Map<String, Map<String, int>> getHistory() {
    if (_history != null) {
      return _history;
    } else {
      return Map<String, Map<String, int>>();
    }
  }

  /// Get the name of this group
  String getName() {
    return _groupName;
  }

  /// Set the name of this group
  void setName(String newName) {
    _groupName = newName;
  }

  /// ---------------- \\\
  /// GroupData Status \\\
  /// ---------------- \\\

  /// Set a new question
  /// Last question will be replaced by the current question automatically
  /// Admin account must be provided for authentication
  /// Non-admins will cause this function to fail silently
  /// The admin's vote timestamp will be reset to null
  /// The database is updated automatically if doDatabaseUpdate is not provided or is set to true
  Future<void> setNextQuestion(Question newQuestion, UserData admin,
      {bool doDatabaseUpdate: true}) async {
    if (admin.getUserID() == _adminID) {
      await FirebaseAnalytics()
          .logEvent(name: 'next_question', parameters: {'id': _groupID});

      /// Move the questions
      _lastQuestion = Question(
          _nextQuestion.getQuestionID(),
          _nextQuestion.getQuestion(),
          _nextQuestion.getCategoryAsCategory(),
          _nextQuestion.getCreatorID(),
          _nextQuestion.getCreatorName());

      _nextQuestion = newQuestion;

      /// Move the votes
      _transferVotes(admin);

      _adminVoteTimestamp = null;

      if (doDatabaseUpdate) await Constants.database.updateGroup(this);
    }
  }

  /// Get the question currently in this group
  Question getQuestion() {
    return _nextQuestion;
  }

  String getQuestionID() {
    return _nextQuestion.getQuestionID();
  }

  /// Get the previous question of this group
  Question getLastQuestion() {
    return _lastQuestion;
  }

  String getLastQuestionID() {
    return _lastQuestion.getQuestionID();
  }

  String getLastQuestionString() {
    return _lastQuestion.getQuestion();
  }

  String getNextQuestionString() {
    return _nextQuestion.getQuestion();
  }

  /// Check wheter or not a user is playing
  bool isUserPlaying(UserData user) {
    return _playing.contains(user.getUserID());
  }

  /// Add a user to the playing list
  /// Does not affect the member list
  void setPlayingUser(UserData user) {
    if (!_playing.contains(user.getUserID())) {
      _playing.add(user.getUserID());
    }
  }

  /// Remove a user from the playing list
  /// Player will also be removed from vote lists
  /// Does not affect the member list
  void removePlayingUser(UserData user) {
    String id = user.getUserID();

    _playing.remove(id);
    _lastVotes.remove(id);
    _newVotes.remove(id);
    _totalVotes.remove(id);

    /// If the user is admin, set a new admin
    if (_adminID == id) {
      if (_playing.length > 0) {
        _adminID = _playing.first;
      }
    }
  }

  /// Get the current list of playing members (their IDs)
  List<String> getPlaying() {
    return _playing;
  }

  /// Get the current list of playing members (their IDs)
  List<UserData> getPlayingUserdata() {
    List<UserData> users = List<UserData>();

    _playing.forEach((ID) {
      users.add(UserData(ID, getUserName(ID)));
    });

    return users;
  }

  /// Get the amount of playing users
  int getNumPlaying() {
    return _playing.length;
  }

  /// Get the time when the admin has voted in milliseconds
  /// Will be null if the admin has not voted yet this round
  int getAdminVoteTimestamp() {
    return _adminVoteTimestamp;
  }

  /// Get the amount of members in this group
  int getNumMembers() {
    return _members.length;
  }

  ///returns the number of votes submitted this round
  int getNumVotes() {
    return _newVotes.length;
  }

  String getWinner() {
    String winner = '';
    int winnervotes = 0;
    _getLastVoteCounts().forEach((userID, numVotes) {
      if (numVotes > winnervotes) {
        winner = getUserName(userID).split(' ')[0];
        winnervotes = numVotes;
      } else if (numVotes == winnervotes) {
        winner = winner + " + " + getUserName(userID).split(' ')[0];
      }
    });
    return winner;
  }

  /// The parameter should be 'previous' or 'alltime' to indicate the wanted top three
  /// Get the IDs of the three winners alltime OR last round (UNORDERED as this is a map!)
  /// The number of votes each of them got will be their value
  Map<String, int> getTopThreeIDs(String kind) {
    Map<String, int> voteCounts;

    switch (kind) {
      case 'previous':
        voteCounts = _getLastVoteCounts();
        break;

      /// Get the vote counts of last round
      case 'alltime':
        voteCounts = getTotalVotes();
        break;

      /// Get the all time vote counts
      default:
        voteCounts = Map<String, int>();
        break;

      /// Invalid parameter: empty map to prevent nullpointer exceptions
    }

    Map<String, int> topThree = Map<String, int>();

    /// List to store the user IDs

    voteCounts.forEach((userID, numVotes) {
      /// Always add the user if the top three isn't full yet
      if (topThree.length < 3) {
        topThree[userID] = numVotes;
      } else {
        /// Find the lowest scoring user
        int lowestVotes = numVotes;
        String lowestID = userID;
        topThree.forEach((topID, topVotes) {
          if (topVotes < lowestVotes) {
            lowestVotes = topVotes;
            lowestID = topID;
          }
        });

        /// Update the top three accordingly
        if (topThree.containsKey(lowestID)) {
          topThree.remove(lowestID);
          topThree[userID] = numVotes;
        }
      }
    });

    return topThree;
  }

  /// Returns a list of UserRankData
  ///   - previous : The votees and their # votes of last round
  ///   - alltime  : The votees and their # votes of all rounds combined
  ///   - Any other input: previous votes will be used
  List<UserRankData> getUserRankingList(String kind, Map<String, int> input) {
    /// Get the right vote list
    Map<String, int> voteCounts;
    switch (kind) {
      case 'previous':
        voteCounts = _getLastVoteCounts();
        break;

      /// Get the vote counts of last round
      case 'alltime':
        voteCounts = getTotalVotes();
        break;

      /// Get the all time vote counts
      case 'overview':
        voteCounts = input;
        break;
      default:
        voteCounts = _getLastVoteCounts();
        break;

      /// Invalid parameter: just use the last round votes
    }

    /// Convert the vote map to a list
    List<UserRankData> userRanking = List<UserRankData>();
    voteCounts.forEach((id, numVotes) {
      userRanking.add(UserRankData(id, getUserName(id), numVotes));
    });

    /// Sort the list in descending order (highest # votes first)
    userRanking.sort((a, b) => b.getNumVotes().compareTo(a.getNumVotes()));

    return userRanking;
  }

  /// Get the top three of 'previous' or 'alltime' round
  /// One of the Strings above should be passed as parameter
  /// The winner will be in 0th position while the third place will occupy the second position in the list
  /// The List contains 6 Strings: 3x winning player name [0-2], and then 3x their respective vote count[3-5]
  List<String> getTopThree(String kind) {
    /// Gets the right top three IDs (alltime or previous) -> See method above this one
    Map<String, int> topThree = getTopThreeIDs(kind);

    ///first three elements return the player name, last three return the number of votes
    List<String> top = List(6);
    top[0] = '';
    top[1] = '';
    top[2] = '';
    top[3] = '';
    top[4] = '';
    top[5] = '';

    /// Get the top three in # votes and sort them
    List<int> currentTop = List(3);

    /// Initialize list
    currentTop[0] = 0;
    currentTop[1] = 0;
    currentTop[2] = 0;
    int numElements = 0;
    topThree.forEach((id, votes) {
      /// Loop the top three
      currentTop[numElements] = votes;

      /// Add the votes of each user
      numElements++;
    });
    currentTop.sort((b, a) => a.compareTo(b));

    /// Sort the top in reverse order (biggest first)

    /// Fill the list that will indicate the winners
    List<String> currentTopIDs = List(3);
    for (int i = 0; i < 3; i++) {
      int topVotes = currentTop[i];
      Map<String, int> topThreeCopy = Map<String, int>.from(topThree);
      for (String id in topThreeCopy.keys) {
        if (topVotes == topThreeCopy[id])

          /// Match {
          currentTopIDs[i] = id;

        /// Set the winner's ID
        topThree.remove(id);

        /// Prevent duplicate IDs
        break;
      }
    }

    /// Update the top values
    for (int i = 0; i < 3; i++) {
      top[i] =
          currentTop[i] > 0 ? getUserName(currentTopIDs[i]).split(' ')[0] : ' ';

      /// Add each user's name
      top[i + 3] = currentTop[i] > 0 ? currentTop[i].toString() : ' ';

      /// Add each user's score
    }

    /// Return the result
    return top;
  }

  /// Add a vote to this member's record
  /// Will be added to the newVotes list
  /// If the admin is voting, a timestamp will be set
  void addVote(String voteeID) {
    /// Update the timestamp if the admin is voting
    if (_adminID == Constants.getUserID()) {
      _adminVoteTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    /// Make change in database
    _performAsyncVote(voteeID);

    /// Make change locally
    offlineVote(voteeID);
  }

  /// Perform a vote in the database
  /// Automatically retries after a random amount of time
  void _performAsyncVote(String voteeID) async {
    int retryLimit = 10, i = 0; // Limit the retries
    bool isSuccess = await Constants.database
        .voteOnUser(this, voteeID); // Perform the database update

    while (!(isSuccess) &&
        i < retryLimit) // While the transaction fails and the retry limit has NOT been reached
    {
      Random rand = Random();
      int ms = 1 + rand.nextInt(26);
      Duration delay = Duration(milliseconds: ms); // Create a random delay

      try {
        sleep(delay); // Try to sleep for the random delay
      } catch (e) {
        print("Something went wrong while awaiting the next vote retry!");
        print(e);
      }

      isSuccess = await Constants.database
          .voteOnUser(this, voteeID); // Retry the database update and wait

      i++;
    }
  }

  /// This vote will not be officially registered!
  /// This is only for local votes
  void offlineVote(String voteeID) {
    _newVotes[Constants.getUserID()] = voteeID;
  }

  //oflineVote for party mode
  void offlineVoteParty(String voteeID) {
    String randomID = Random().nextInt(500).toString();
    while (_newVotes.containsKey(randomID)) {
      randomID = Random().nextInt(500).toString();
    }
    _newVotes[randomID] = voteeID;
    print(_newVotes);
  }

  /// Get the amount of votes each user has gotten in the previous round
  /// Members without votes will also be added to this map (with 0 votes)
  Map<String, int> _getLastVoteCounts() {
    Map<String, int> voteCount = Map<String, int>();

    _lastVotes.forEach((voter, votee) {
      if (voteCount.containsKey(votee)) {
        voteCount[votee] += 1;
      } else {
        voteCount[votee] = 1;
      }
    });

    // Add users that did not get any votes
    _playing.forEach((id) {
      if (!voteCount.containsKey(id)) {
        voteCount[id] = 0;
      }
    });

    return voteCount;
  }

  /// Get the amount of votes each user has gotten in the current round
  /// Users without votes will not be in this list
  Map<String, int> _getNewVoteCounts() {
    Map<String, int> voteCount = Map<String, int>();

    _newVotes.forEach((voter, votee) {
      if (voteCount.containsKey(votee)) {
        voteCount[votee] += 1;
      } else {
        voteCount[votee] = 1;
      }
    });

    return voteCount;
  }

  /// Prepare this group for the next question
  /// Adds newVotes to totalVotes
  /// Copies newVotes to lastVotes
  /// Requires admin authentication, otherwise this action will be canceled
  void _transferVotes(UserData admin) {
    /// Admin authentication
    if (admin.getUserID() == _adminID) {
      /// Add the votes to the history list
      String currentQuestion;
      if (_lastQuestion != null) {
        currentQuestion = _lastQuestion.getQuestion();
      }
      Map<String, int> currentVotes = Map<String, int>();

      /// Add votes to total count
      _getNewVoteCounts().forEach((userID, numVotes) {
        currentVotes[getUserName(userID)] = numVotes;

        if (_totalVotes.containsKey(userID))
          _totalVotes[userID] += numVotes;
        else
          _totalVotes[userID] = numVotes;
      });

      if (currentQuestion != null && currentQuestion != "") {
        if (_history == null) {
          _history = Map<String, Map<String, int>>();
        }
        _history[currentQuestion] = currentVotes;
      }

      /// Copy new votes to the old list
      _lastVotes = _newVotes;

      /// Reset new votes
      _newVotes = Map<String, String>();
    }
  }

  /// Get the new votes, from this round
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getNewVotes() {
    return _getNewVoteCounts();
  }

  /// Get the votes from last round
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getLastVotes() {
    return _getLastVoteCounts();
  }

  /// Get the votes mapped to voters from the current round
  Map<String, String> getNewVoteData() {
    return _newVotes;
  }

  /// Get the votes mapped to voters from last round
  Map<String, String> getLastVoteData() {
    return _lastVotes;
  }

  /// Get the votes of all rounds combined
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getTotalVotes() {
    Map<String, int> votes = _totalVotes;

    _playing.forEach((userID) {
      if (!votes.containsKey(userID)) {
        votes[userID] = 0;
      }
    });

    return votes;
  }

  /// A method for testing by printing the contents of this group
  void printData() {
    String membersString = "";
    _members.forEach((key, member) {
      membersString += member + ", ";
    });

    String playingString = "";
    _playing.forEach((player) {
      playingString += player + ", ";
    });

    print("-----");
    print("GroupTileData debug message");
    print("Name: " +
        _groupName +
        "\nGroupID: " +
        _groupID +
        "\nadminID: " +
        _adminID +
        "\nmembers:" +
        membersString +
        "\nPlaying:" +
        playingString);
    print("Question: " +
        _nextQuestion.getQuestionID() +
        "\nNext Question: " +
        _lastQuestion.getQuestionID());
    _totalVotes.forEach((key, value) {
      print("ID: " + key);
      print("Votes: " + value.toString());
    });
    print("-----");
  }
}