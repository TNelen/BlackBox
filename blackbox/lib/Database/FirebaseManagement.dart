import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManagement {
  /// Remove groups where the last activity was a given number of days ago
  /// Will not accept input under 7 days
  /// Timestamps are based on local time so they may only be accurate up to 27 hours
  void removeOldGroups(int days) async {
    if (days < 7) {
      print(
          'You tried to delete recent groups. Now only deleting groups older than 7 days');
      days = 7;
    }

    int now = DateTime.now().millisecondsSinceEpoch;
    int threshold = now -
        (days *
            86400000); // x days * 86400000 milliseconds / day -> x*86400000 milliseconds

    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('groups')
        .where('lastUpdate', isLessThan: threshold)
        .getDocuments();
    print('Deleting ' + snap.docs.length.toString() + ' documents');
    for (DocumentSnapshot doc in snap.docs) {
      await FirebaseFirestore.instance.doc(doc.id).delete();
    }
    print(
        'Deleting of old groups ($days+ days of inactivity) has been completed');
  }

  /// Add a list of question to an existing category
  void addQuestions(String category, List<String> newQuestions) async {
    print('Adding new questions...');

    // Check if category exists in questionList
    List<String> categoryContent = List<String>();
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('questionsv2')
        .doc('questionList')
        .get();
    if (snap == null) return;

    if (!snap.data().containsKey(category)) {
      print(
          'The category $category does not exist yet! Please add it manually or pick a different category');
      return;
    }

    print('Category \'$category\' was found');

    categoryContent =
        (snap.data()[category] as List)?.map((e) => e as String)?.toList();
    List<String> nonDupes = List<String>();

    // Get only the non-dupes
    int i = 0;
    for (String question in newQuestions) {
      print('Checking question  $i');
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('questionsv2')
          .where('question', isEqualTo: question)
          .get();
      if (snap.docs.length != 0)
        print('Found a duplicate. Skipping: $question');
      else
        nonDupes.add(question);

      i++;
    }

    print('Found ' + nonDupes.length.toString() + ' non duplicates!');

    // Add non-existing questions and add their IDs to categoryContent
    for (String question in nonDupes) {
      var data = Map<String, dynamic>();
      data['question'] = question;
      data['category'] = category;
      DocumentReference ref =
          await FirebaseFirestore.instance.collection('questionsv2').add(data);
      categoryContent.add(ref.id);
    }

    print('Updating question list...');

    // Update questionList
    await FirebaseFirestore.instance
        .collection('questionsv2')
        .doc('questionList')
        .update({category: categoryContent});

    print('Adding questions complete!');
  }
}
