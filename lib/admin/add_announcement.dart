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

class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
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
                    ? ButtonTheme(
                        child: TextButton(
                          onPressed: () => _getLocalImage(),
                          child: Text(
                            'Add Image',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                Container(
                  child: TextFormField(
                    initialValue: _currentModel.category,
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: kInputTextFieldDecoration.copyWith(
                        labelText: 'Announcement title'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Name is required';
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
                  controller: detailsController,
                  minLines: 5,
                  maxLines: null,
                  decoration: kInputTextFieldDecoration.copyWith(
                      labelText: 'Announcement details'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Anouncement detail is required';
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
          _saveFood();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveFood() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Database().uploadAnnouncementAndImage(
        _currentModel, _imageFile, _onAnnounmentUploaded);
  }

  _onAnnounmentUploaded(Question food) {
    ModelNotifier modelNotifier =
        Provider.of<ModelNotifier>(context, listen: false);
    modelNotifier.addModel(food);
    titleController.clear();
    detailsController.clear();
  }
}
