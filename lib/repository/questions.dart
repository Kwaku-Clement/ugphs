import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

TextEditingController titleController = TextEditingController();
TextEditingController detailsController = TextEditingController();

class Question {
  String id;
  String name;
  String image;
  String time;
  String category;
  String createdBy;
  DateTime createdAt;
  DocumentReference reference;

  Question(
      {this.image,
      this.category,
      this.createdAt,
      this.createdBy,
      this.time,
      this.id,
      this.reference,
      this.name});

  factory Question.fromSnapshot(DocumentSnapshot snapshot) {
    Question newQuestion = Question.fromJson(snapshot.data());
    newQuestion.reference = snapshot.reference;
    return newQuestion;
  }

  factory Question.fromJson(Map<String, dynamic> json) =>
      _questionFromJson(json);

  Map<String, dynamic> toJson() => _questionToJson(this);

  @override
  String toString() => "Question<$name>";
}

Question _questionFromJson(Map<String, dynamic> json) {
  return Question(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    image: json['image'] as String,
    time: json['time'] as String,
    createdBy: json['createdBy'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : (json['createdAt'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _questionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'createdAt': instance.createdAt,
      'createdBy': instance.createdBy,
      'time': instance.time,
    };
