import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackbox/Constants.dart';
import '../DataContainers/UserData.dart';
import '../DataContainers/Question.dart';

class GroupData {
    

  /// ---------------- \\\
  /// GroupData Fields \\\
  /// ---------------- \\\


  /// Basic data about this group
  String _groupName;         /// Name of the group
  String _groupDescription;  /// Description of the group
  String _groupID;           /// The unique ID of this group
  String _adminID;           /// The unique ID of the admin
  Map<String, String> _members = new Map<String, String>(); /// A list of unique IDs of all members in this group

  /// Status information about this group
  Question _nextQuestion = new Question.empty();  /// Data container for the current/next question
  Question _lastQuestion = new Question.empty();  /// Data container for the previous question
  Map<String, int> _lastVotes;  /// Mapping unique IDs to the number of last votes a member had
  Map<String, int> _newVotes;   /// Mapping unique IDs to the new number of votes a member had
  Map<String, int> _totalVotes; /// Mapping unique IDs to the total amount of votes for that user
  List<String> _playing;        /// A list of all IDs of members that are currently playing 
  

  /// ---------------------- \\\
  /// GroupData constructors \\\
  /// ---------------------- \\\


  /// Create a group with the given data fields
  GroupData(this._groupName, this._groupDescription, this._groupID, this._adminID, this._members) {
    _nextQuestion = new Question.empty();
    _lastVotes = new Map<String, int>();
    _newVotes = new Map<String, int>();
    _totalVotes = new Map<String, int>();
    _playing = new List<String>();
  }

  /// Create a group with the given data fields AND status fields
  GroupData.extended(this._groupName, this._groupDescription, this._groupID, this._adminID, this._members, 
                     this._nextQuestion, this._lastVotes, this._newVotes, this._totalVotes, this._playing);


  /// ---------------- \\\
  /// Firebase Utility \\\
  /// ---------------- \\\


  /// Create a group from a DocumentSnapshot (Firebase)
  GroupData.fromDocumentSnapshot ( DocumentSnapshot snap ) :
    /// Get basic data
    _groupName = snap.data['name'] ?? "Nameless group",
    _groupDescription = snap.data['description'] ?? "No description",
    _groupID = snap.documentID.toString(),
    _adminID = snap.data['admin'],
    /// Get status data
    _nextQuestion = new Question( snap.data['nextQuestionID'], snap.data['nextQuestion'], Question.getCategoryFromString(snap.data['nextQuestionCategory']), snap.data['nextQuestionCreatorID'], snap.data['nextQuestionCreatorName']) ?? new Question.addDefault( snap.data['nextQuestion'] ) ?? new Question.empty(),
    _lastQuestion = new Question( snap.data['lastQuestionID'], snap.data['lastQuestion'], Question.getCategoryFromString(snap.data['lastQuestionCategory']), snap.data['lastQuestionCreatorID'], snap.data['lastQuestionCreatorName']) ?? new Question.addDefault( snap.data['nextQuestion'] ) ?? new Question.empty(),
    _members = _convertFirebaseMapString( snap.data['members'] ),
    _lastVotes = _convertFirebaseMapInt( snap.data['lastVotes'] ),
    _newVotes = _convertFirebaseMapInt( snap.data['newVotes'] ),
    _totalVotes = _convertFirebaseMapInt( snap.data['totalVotes'] ),
    _playing = _convertFirebaseList( snap.data['playing'] );


  /// Convert a list from a DocumentSnapshot to a List<String>
  /// NO checks are done! Provided parameter MUST be correct
  static List<String> _convertFirebaseList( dynamic data )
  {
    List<String> list = new List<String>();

    for (dynamic element in data)
    {
        list.add( element );
    }

    return list;
  }


  /// Convert a Map from a DocumentSnapshot to a Map<String, int>
  /// NO checks are done! Provided parameter MUST be correct
  static Map<String, int> _convertFirebaseMapInt( dynamic data )
  {
    /// Initialize lists
    Map<dynamic, dynamic> dbData = data;
    Map<String, int> convertedData = new Map<String, int>();

    /// Loop the database Map and add values as Strings to the data Map
    dbData.forEach( (key, value) {
      convertedData[key.toString()] = value;
    } );

    return convertedData;
  }


  /// Convert a Map from a DocumentSnapshot to a Map<String, int>
  /// NO checks are done! Provided parameter MUST be correct
  static Map<String, String> _convertFirebaseMapString( dynamic data )
  {
    /// Initialize lists
    Map<dynamic, dynamic> DBData = data;
    Map<String, String> convertedData = new Map<String, String>();

    /// Loop the database Map and add values as Strings to the data Map
    DBData.forEach( (key, value) {
      convertedData[key.toString()] = value.toString();
    } );

    return convertedData;
  }


  /// --------------------- \\\
  /// GroupData Information \\\
  /// --------------------- \\\


  /// Gets the ID of the admin of this group
  String getAdminID()
  {
    return _adminID;
  }


  /// Get the unique code of this group
  String getGroupCode()
  {
    return _groupID;
  }


  /// Get the description of this group
  String getDescription()
  {
    return _groupDescription;
  }


  /// Set the description of this group
  void setDescription(String newDescription)
  {
      _groupDescription = newDescription;
  }


  /// Get the username of the member with the provided ID
  /// Might return null if the ID is unknown
  String getUserName( String ID )
  {
    return _members[ID];
  }


  /// Get the UserData of all users in this group
  List< UserData > getMembers()
  {
    List< UserData > users = new List<UserData>();

    _members.forEach(
      (id, username) {
        users.add( new UserData(id, username) );
      }
    );

    return users;
  }


  /// Get all members in this group as a Map
  /// Their IDs will serve as key while their usernames will be the values
  Map< String, String > getMembersAsMap()
  {
    return _members;
  }

  /// Adds a user to this group if he isn't included yet
  void addMember( UserData user )
  {
    if ( _members.containsKey(user.getUserID()) )
      return;

    _members[ user.getUserID() ] = user.getUsername();
  }


  /// Removes a user from this group
  /// User will be removed from all lists (all vote lists + playing lists)
  /// If the last user leaves, this group will be deleted from the database!
  void removeMember( UserData user )
  {
    _members.remove( user.getUserID() );
    removePlayingUser(user);

    _lastVotes.remove( user.getUserID() );
    _newVotes.remove( user.getUserID() );
    _totalVotes.remove( user.getUserID() );

    if ( _members.length == 0 )
    {
      Constants.database.deleteGroup( this );
    }

  }


  /// Get the name of this group
  String getName()
  {
    return _groupName;
  }


  /// Set the name of this group
  void setName(String newName)
  {
    _groupName = newName;
  }


  /// ---------------- \\\
  /// GroupData Status \\\
  /// ---------------- \\\
  

  /// Set a new question
  /// Last question will be replaced by the current question automatically
  /// Admin account must be provided for authentication
  /// Non-admins will cause this function to fail silently
  void setNextQuestion(Question nextQuestion, UserData admin)
  {
    if (admin.getUserID() != _adminID)
      return;

    /// Move the questions
    _lastQuestion = _nextQuestion;
    _nextQuestion = nextQuestion;

    /// Move the votes
    _transferVotes( admin );
  }


  /// Get the question currently in this group
  Question getQuestion()
  {
    return _nextQuestion;
  }

  String getQuestionID(){
    return _nextQuestion.getQuestionID();
  }

  /// Get the previous question of this group
  Question getLastQuestion()
  {
    return _lastQuestion;
  }

  String getLastQuestionString()
  {
    return _lastQuestion.getQuestion();
  }

  String getNextQuestionString()
  {
    return _nextQuestion.getQuestion();
  }


  /// Check wheter or not a user is playing
  bool isUserPlaying( UserData user )
  {
    return _playing.contains( user.getUserID() );
  }


  /// Add a user to the playing list
  /// Does not affect the member list
  void setPlayingUser( UserData user )
  {
    if (  !_playing.contains(user.getUserID()) ) {
      _playing.add( user.getUserID() );
    }
  }


  /// Remove a user from the playing list
  /// Player will also be removed from vote lists
  /// Does not affect the member list
  void removePlayingUser( UserData user )
  {
    String id = user.getUserID();

    _playing    .remove( id );
    _lastVotes  .remove( id );
    _newVotes   .remove( id );
    _totalVotes .remove( id );
  }


  /// Get the current list of playing members (their IDs)
  List<String> getPlaying()
  {
    return _playing;
  }


  /// Get the amount of playing users
  int getNumPlaying()
  {
    return _playing.length;
  }

  ///returns the number of votes submitted this round
  int getNumVotes(){
    int totalvotes = 0;
    _newVotes.forEach((userID, numVotes){
      totalvotes = totalvotes +  numVotes;
    });
    return totalvotes;
  }

  String getWinner(){
    String winner = null;
    int winnervotes = 0;
    _newVotes.forEach((userID, numVotes){
      if (numVotes > winnervotes){
        winner = getUserName(userID);
        winnervotes = numVotes;
      }
      else if (numVotes == winnervotes){
        winner = winner + " + " + getUserName(userID);
    }});
    return winner;

  }

  List<String> getTopThree(){
    List<String> top = new List(3); top[0] = '';top[1] = '';top[2] = '';
    int oneVotes =0;
    int twoVotes = 0;
    int threeVotes = 0;
    _newVotes.forEach((userID, numVotes){
      if (numVotes > oneVotes){
        top[1] = top[0];
        top[2]= top[1];
        top[0] = getUserName(userID);
        oneVotes = numVotes;
      }
      else if (numVotes >= twoVotes && numVotes <oneVotes){
        top[2]=top[1];
       top[1] = getUserName(userID);
       twoVotes = numVotes;
      }
      else if (numVotes >= threeVotes && numVotes <twoVotes)
        top[2] = getUserName(userID);
        threeVotes = numVotes;
    });
    return top;

  }


  /// Add a vote to this member's record
  /// Will be added to the newVotes list
  void addVote(String voteeID)
  {
    /// Make change in database
    Constants.database.voteOnUser(this, voteeID);

    /// Make change locally
    _offlineVote(voteeID);
  }


  /// This vote will not be officially registered!
  /// This is only for local votes
  void _offlineVote(String voteeID)
  {
    if ( _newVotes.containsKey(voteeID) )
      _newVotes[voteeID] = _newVotes[voteeID] + 1;
    else
      _newVotes[voteeID] = 1;
  }


  /// Prepare this group for the next question
  /// Adds newVotes to totalVotes
  /// Copies newVotes to lastVotes
  /// Requires admin authentication, otherwise this action will be canceled
  void _transferVotes(UserData admin)
  {
    /// Admin authentication
    if ( admin.getUserID() != _adminID )
      return;

    /// Add votes to total count
    _newVotes.forEach( (userID, numVotes) {
        if (_totalVotes.containsKey(userID))
          _totalVotes[userID] += numVotes;
        else
          _totalVotes[userID] = numVotes;
    });

    /// Copy new votes to the old list 
    _lastVotes = _newVotes;

    /// Reset new votes
    _newVotes = new Map<String, int>();

  }


  /// Get the new votes, from this round
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getNewVotes()
  {
    return _newVotes;
  }


  /// Get the votes from last round
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getLastVotes()
  {
    return _lastVotes;
  }


  /// Get the votes of all rounds combined
  /// Unique user IDs are mapped to the amount of votes
  /// Get the name of a user with: GroupData#getUserName( String ID )
  Map<String, int> getTotalVotes()
  {
    return _totalVotes;
  }


  /// A temporary method for testing by printing the contents of this group
  @Deprecated('Will be deleted before release!')
  void printData()
  {
    String membersString = "";
    _members.forEach( (key, member)
      {
          membersString += member + ", ";
      });

    print("-----");
    print("GroupTileData debug message");
    print("Name: " + _groupName + "\nGroupID: " + _groupID + "\nadminID: " + _adminID + "\nmembers:" + membersString);
    _totalVotes.forEach( (key, value) { print("ID: " + key); print("Votes: " + value.toString()); } );
    print("-----");
  }

}