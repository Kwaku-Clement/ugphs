import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String password;
  DateTime createdAt;
  String username;
  String notifToken;
  String role;
  String profileUrl;
  DocumentReference reference;

  UserModel({
    this.uid,
    this.email,
    this.createdAt,
    this.username,
    this.notifToken,
    this.role,
    this.reference,
    this.password,
    this.profileUrl,
  });
  factory UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    UserModel newQuestion = UserModel.fromJson(doc.data());
    newQuestion.reference = doc.reference;
    return newQuestion;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _questionFromJson(json);

  Map<String, dynamic> toJson() => _questionToJson(this);

  @override
  String toString() => "UserModel<$username>";
}

UserModel _questionFromJson(Map<String, dynamic> json) {
  return UserModel(
    uid: json['uid'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    profileUrl: json['profileUrl'] as String,
    role: json['role'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : (json['createdAt'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _questionToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'email': instance.email,
      'profileUrl': instance.profileUrl,
      'createdAt': instance.createdAt,
      'role': instance.role,
    };
