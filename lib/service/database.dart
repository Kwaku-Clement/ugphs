import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tolerance/provider/provider_notifier.dart';
import 'package:tolerance/model/userModel.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Database {
  final String uid;
  Database({this.uid});

// Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  User user = FirebaseAuth.instance.currentUser;

  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await userCollection.doc(user.uid).set({
        'username': user.username,
        'email': user.email.trim(),
        'role': user.role,
        'createdAt': Timestamp.now(),
        'notifToken': user.notifToken,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<UserModel> getUser(String uid) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot = await userCollection.doc(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createNotifications(
      List<String> tokens, String bookName, String author) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance.collection("notifications").add({
        'bookName': bookName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

// send message
  sendMessage(String id, chatMessageData) {
    FirebaseFirestore.instance
        .collection('Forum')
        .doc(id)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('Forum').doc(id).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String id) async {
    return FirebaseFirestore.instance
        .collection('Forum')
        .doc(id)
        .collection('forum_comment')
        .orderBy('time')
        .snapshots();
  }

  getComments(ModelNotifier foodNotifier, String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Forum')
        .doc(id)
        .collection('forum_comment')
        .orderBy("time", descending: true)
        .get();

    List<Question> _forumList = [];

    snapshot.docs.forEach((document) {
      Question food = Question.fromSnapshot(document.data());
      _forumList.add(food);
    });

    foodNotifier.modelList = _forumList;
  }

  getForum(ModelNotifier foodNotifier, String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Forum')
        .orderBy("createdAt", descending: true)
        .get();

    List<Question> _forumList = [];

    snapshot.docs.forEach((document) {
      Question food = Question.fromSnapshot(document.data());
      _forumList.add(food);
    });

    foodNotifier.modelList = _forumList;
  }

  uploadForumAndImage(
      Question forum, File localFile, Function forumUploaded) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      var uuid = Uuid().v4();

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Forum/images/$uuid$fileExtension');

      await firebaseStorageRef.putFile(localFile).whenComplete(() {
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();
      _uploadForum(forum, forumUploaded, imageUrl: url);
    } else {
      _uploadForum(forum, forumUploaded);
    }
  }

  _uploadForum(Question forum, Function forumUploaded,
      {String imageUrl}) async {
    CollectionReference forumRef =
        FirebaseFirestore.instance.collection('Forums');

    if (imageUrl != null) {
      forum.image = imageUrl;
    }
    forum.createdAt = DateTime.now();

    DocumentReference documentRef = await forumRef.add(forum.toJson());

    forum.id = documentRef.id;

    await documentRef.set(forum.toJson(), SetOptions(merge: true));
    await documentRef.update({'id': documentRef.id});

    forumUploaded(forum);
  }

  deleteForum(Question forum, String id, Function forumDeleted) async {
    if (forum.image != null) {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(forum.image);

      print(storageReference.fullPath);

      await storageReference.delete();
    }

    await FirebaseFirestore.instance.collection('Forum').doc(forum.id).delete();
    forumDeleted(forum);
  }

//api for scheduling meetings
  getSchedule(ModelNotifier scheduleNotifier) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Schedule')
        .orderBy("createdAt", descending: true)
        .get();

    List<Question> _scheduleList = [];

    snapshot.docs.forEach((document) {
      Question schedule = Question.fromSnapshot(document.data());
      _scheduleList.add(schedule);
    });

    scheduleNotifier.modelList = _scheduleList;
  }

  uploadScheduleAndImage(
      Question schedule, File localFile, Function scheduleUploaded) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      var uuid = Uuid().v4();

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Schedule/images/$uuid$fileExtension');

      await firebaseStorageRef.putFile(localFile).whenComplete(() {
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();
      _uploadSchedule(schedule, scheduleUploaded, imageUrl: url);
    } else {
      _uploadSchedule(schedule, scheduleUploaded);
    }
  }

  _uploadSchedule(Question schedule, Function forumUploaded,
      {String imageUrl}) async {
    CollectionReference forumRef =
        FirebaseFirestore.instance.collection('Schedule');

    if (imageUrl != null) {
      schedule.image = imageUrl;

      schedule.createdAt = DateTime.now();

      DocumentReference documentRef = await forumRef.add(schedule.toJson());

      schedule.id = documentRef.id;

      await documentRef.set(schedule.toJson(), SetOptions(merge: true));

      forumUploaded(schedule);
    }
  }

  deleteSchedule(Question schedule, Function forumDeleted) async {
    if (schedule.image != null) {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(schedule.image);

      await storageReference.delete();
    }

    await FirebaseFirestore.instance
        .collection('Schedule')
        .doc(schedule.id)
        .delete();
    forumDeleted(schedule);
  }

//api for announcement
  getAnnouncement(ModelNotifier announcementNotifier) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Announcement')
        .orderBy("createdAt", descending: true)
        .get();

    List<Question> _announcementList = [];

    snapshot.docs.forEach((document) {
      Question announcement = Question.fromSnapshot(document.data());
      _announcementList.add(announcement);
    });

    announcementNotifier.modelList = _announcementList;
  }

  uploadAnnouncementAndImage(Question announcement, File localFile,
      Function announcementUploaded) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      var uuid = Uuid().v4();

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Announcement/images/$uuid$fileExtension');

      await firebaseStorageRef.putFile(localFile).whenComplete(() {
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();
      _uploadAnnouncement(announcement, announcementUploaded, imageUrl: url);
    } else {
      _uploadAnnouncement(announcement, announcementUploaded);
    }
  }

  _uploadAnnouncement(Question announcement, Function forumUploaded,
      {String imageUrl}) async {
    CollectionReference forumRef =
        FirebaseFirestore.instance.collection('Announcement');

    if (imageUrl != null) {
      announcement.image = imageUrl;
    }
    announcement.createdAt = DateTime.now();

    DocumentReference documentRef = await forumRef.add(announcement.toJson());

    announcement.id = documentRef.id;

    await documentRef.set(announcement.toJson(), SetOptions(merge: true));

    forumUploaded(announcement);
  }

  deleteAnnouncement(
      Question announcement, Function announcementDeleted) async {
    if (announcement.image != null) {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(announcement.image);

      await storageReference.delete();
    }

    await FirebaseFirestore.instance
        .collection('Announcement')
        .doc(announcement.id)
        .delete();
    announcementDeleted(announcement);
  }

//api for party executives
  getLeaders(ModelNotifier leadersNotifier) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Leaders')
        .orderBy("createdAt", descending: true)
        .get();

    List<Question> _leadersList = [];

    snapshot.docs.forEach((document) {
      Question leaders = Question.fromSnapshot(document.data());
      _leadersList.add(leaders);
    });

    leadersNotifier.modelList = _leadersList;
  }

  uploadLeadersAndImage(
      Question leader, File localFile, Function leaderUploaded) async {
    if (localFile != null) {
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      var uuid = Uuid().v4();

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('Leaders/images/$uuid$fileExtension');

      await firebaseStorageRef.putFile(localFile).whenComplete(() {
        return false;
      });

      String url = await firebaseStorageRef.getDownloadURL();
      _uploadLeaders(leader, leaderUploaded, imageUrl: url);
    } else {
      _uploadLeaders(leader, leaderUploaded);
    }
  }

  _uploadLeaders(Question leader, Function leaderUploaded,
      {String imageUrl}) async {
    CollectionReference leaderRef =
        FirebaseFirestore.instance.collection('Leaders');

    if (imageUrl != null) {
      leader.image = imageUrl;
    }
    leader.createdAt = DateTime.now();

    DocumentReference documentRef = await leaderRef.add(leader.toJson());

    leader.id = documentRef.id;

    await documentRef.set(leader.toJson(), SetOptions(merge: true));

    leaderUploaded(leader);
  }

  deleteLeaders(Question leader, Function leaderDeleted) async {
    if (leader.image != null) {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(leader.image);

      await storageReference.delete();
    }

    await FirebaseFirestore.instance
        .collection('Leaders')
        .doc(leader.id)
        .delete();
    leaderDeleted(leader);
  }

  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File> downloadFile(String url) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);

    List<List<int>> chunks = [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

        // Save the file

        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }

        return _storeFile(url, bytes);
      });
    });
  }

  static Future<File> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    return File(result.paths.first);
  }

  static Future<File> loadFirebase(String url) async {
    try {
      final refPDF = FirebaseStorage.instance.ref().child(url);
      final bytes = await refPDF.getData();

      return _storeFile(url, bytes);
    } catch (e) {
      return null;
    }
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = path.basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
