import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tolerance/repository/questions.dart';

class ModelNotifier with ChangeNotifier {
  List<Question> _forumList = [];
  Question _currentModel;

  UnmodifiableListView<Question> get forumList =>
      UnmodifiableListView(_forumList);

  Question get currentModel => _currentModel;

  set modelList(List<Question> forumList) {
    _forumList = forumList;
    notifyListeners();
  }

  set currentModel(Question forum) {
    _currentModel = forum;
    notifyListeners();
  }

  addModel(Question forum) {
    _forumList.insert(0, forum);
    notifyListeners();
  }

  deleteModel(Question forum) {
    _forumList.removeWhere((_forum) => _forum.id == forum.id);
    notifyListeners();
  }
}
