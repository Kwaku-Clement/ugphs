import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolerance/repository/questions.dart';

class DataRepository {
  final CollectionReference questionsCollection =
      FirebaseFirestore.instance.collection('Forums');

  Stream<QuerySnapshot> getStream() {
    return questionsCollection.snapshots();
  }

  Future<DocumentReference> addForum(Question question) {
    return questionsCollection.add(question.toJson());
  }

  updatePet(Question question) async {
    await questionsCollection
        .doc(question.reference.id)
        .update(question.toJson());
  }

//schedule repository
  final CollectionReference scheduleCollection =
      FirebaseFirestore.instance.collection('Schedule');

  Future<DocumentReference> addSchedule(Question question) {
    return scheduleCollection.add(question.toJson());
  }

  Stream<QuerySnapshot> getScheduleStream() {
    return scheduleCollection.snapshots();
  }

  //Announcement Repository
  final CollectionReference announcementCollection =
      FirebaseFirestore.instance.collection('Announcement');

  Future<DocumentReference> addAnnouncement(Question question) {
    return announcementCollection.add(question.toJson());
  }

  Stream<QuerySnapshot> getAnnouncementStream() {
    return announcementCollection.snapshots();
  }

  final CollectionReference recentCollection =
      FirebaseFirestore.instance.collection('recent_activity');

  Future<DocumentReference> addRecent(Question question) {
    return recentCollection.add(question.toJson());
  }

  Stream<QuerySnapshot> getRecentStream() {
    return recentCollection.snapshots();
  }

  //LeaderBoard Repository
  final CollectionReference leadersCollection =
      FirebaseFirestore.instance.collection('Leaders');

  Future<DocumentReference> addLeaders(Question question) {
    return leadersCollection.add(question.toJson());
  }

  Stream<QuerySnapshot> getLeadersStream() {
    return leadersCollection.snapshots();
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Stream<QuerySnapshot> getUserStream() {
    return usersCollection.snapshots();
  }

  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('Forum');

  Stream<QuerySnapshot> getCommentStream() {
    return commentCollection.snapshots();
  }
}
