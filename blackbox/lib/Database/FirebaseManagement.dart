import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManagement {
  
  void addQuestions(String category, List<String> newQuestions) async
  {
    print( 'Adding new questions...' );

    // Check if category exists in questionList
    List<String> categoryContent = List<String>();
    DocumentSnapshot snap = await Firestore.instance.collection( 'questionsv2' ).document( 'questionList' ).get();
    if (snap == null)
      return;

    if ( ! snap.data.containsKey( category ))
    {
      print('The category $category does not exist yet! Please add it manually or pick a different category');
      return;
    }

    print( 'Category \'$category\' was found' );

    categoryContent = (snap.data[ category ] as List)?.map((e) => e as String)?.toList();
    List<String> nonDupes = List<String>();

    // Get only the non-dupes
    for (String question in newQuestions)
    {
      QuerySnapshot snap = await Firestore.instance.collection( 'questionsv2' ).where( 'question', isEqualTo: question ).getDocuments();
      if (snap.documents.length != 0)
        print( "'$question' is a duplicate! Skipping this one.." );
      else
        nonDupes.add( question );
    }

     print( 'Found ' + nonDupes.length.toString() + ' non duplicates!' );

    // Add non-existing questions and add their IDs to categoryContent
    for (String question in nonDupes)
    {
      var data = Map<String, dynamic>();
      data['question'] = question;
      data['category'] = category;
      DocumentReference ref = await Firestore.instance.collection( 'questionsv2' ).add(data);
      categoryContent.add( ref.documentID );
    }

    print('Updating question list...');

    // Update questionList
    await Firestore.instance.collection( 'questionsv2' ).document('questionList').updateData( {category: categoryContent} );

    print( 'Adding questions complete!' );
  }

}