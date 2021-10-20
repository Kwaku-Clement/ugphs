import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/variables.dart';
import 'package:tolerance/provider/provider_notifier.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:tolerance/service/database.dart';

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  String title;
  String details;

  final dateFormat = DateFormat('MM-dd-yyyy');

  Question _currentModel;
  String _imageUrl;

  File _imageFile;
  ImagePicker imagePicker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ModelNotifier modelNotifier =
        Provider.of<ModelNotifier>(context, listen: false);

    if (modelNotifier.currentModel != null) {
      _currentModel = modelNotifier.currentModel;
    } else {
      _currentModel = Question();
    }
    _imageUrl = _currentModel.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Container(
        color: Colors.grey,
        height: 250,
        width: 300,
        child: Icon(Icons.person),
      );
    } else if (_imageFile != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              child: Text(
                'Change Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: () => _getLocalImage(),
            ),
          )
        ],
      );
    } else if (_imageUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              child: Text(
                'Change Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: () => _getLocalImage(),
            ),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    PickedFile imageFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1200,
        imageQuality: 80);
    setState(() {
      _imageFile = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Back'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _showImage(),
                SizedBox(height: 16),
                _imageFile == null && _imageUrl == null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: ButtonTheme(
                          child: ElevatedButton(
                            onPressed: () => _getLocalImage(),
                            child: Text(
                              'Add Image',
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    initialValue: _currentModel.category,
                    keyboardType: TextInputType.text,
                    decoration: kInputTextFieldDecoration.copyWith(
                        labelText: 'Schedule theme'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Theme is required';
                      }

                      return null;
                    },
                    onSaved: (String value) {
                      _currentModel.name = value;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                    child: TextFormField(
                  initialValue: _currentModel.category,
                  minLines: 5,
                  maxLines: null,
                  decoration:
                      kInputTextFieldDecoration.copyWith(labelText: 'Position'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Schedule details is required';
                    }

                    return null;
                  },
                  onSaved: (String value) {
                    _currentModel.category = value;
                  },
                )),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveProgram();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveProgram() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Database()
        .uploadScheduleAndImage(_currentModel, _imageFile, _onLeaderUploaded);
  }

  _onLeaderUploaded(Question leader) {
    ModelNotifier modelNotifier =
        Provider.of<ModelNotifier>(context, listen: false);
    modelNotifier.addModel(leader);
    titleController.clear();
    detailsController.clear();
  }
}
