class GroupNotFoundException implements Exception{
  
  String _cause;
  GroupNotFoundException(String groupCode)
  {
    _cause = "The group with code \"" + groupCode + "\" does not exist!";
    print( _cause );
  }

  String getCause()
  {
    return _cause;
  }

}