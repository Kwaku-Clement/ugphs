import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:tolerance/widgets/utils.dart';

class UploadImages extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const UploadImages({Key key, this.globalKey}) : super(key: key);
  @override
  _UploadImagesState createState() => new _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<Asset> images = [];
  List<File> imageStorage = [];
  List<String> imageUrls = [];
  String _error = 'No Error Dectected';

  //bool isUploading = false;
  bool _spinner = false;
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: List.generate(
        images.length,
        (index) {
          Asset asset = images[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                    child: AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 15.0,
        childAspectRatio: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _spinner,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          var res = await loadAssets();
                          setState(() {
                            images = res;
                            _error = "";
                          });
                        },

                        // loadAssets,
                        child: ThreeDContainer(
                          width: 130,
                          height: 50,
                          backgroundColor: MultiPickerApp.navigateButton,
                          backgroundDarkerColor: MultiPickerApp.background,
                          child: Center(
                              child: Text(
                            "Pick images",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (images.length != 0) {
                            SnackBar snackbar = SnackBar(
                                content: Text('Please wait, we are uploading'));
                            widget.globalKey.currentState
                                .showSnackBar(snackbar);

                            uploadImages();
                          } else {
                            setState(() {
                              _spinner = false;
                            });

                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    content: Text("No image selected",
                                        style: TextStyle(color: Colors.white)),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: ThreeDContainer(
                                          width: 80,
                                          height: 30,
                                          backgroundColor:
                                              MultiPickerApp.navigateButton,
                                          backgroundDarkerColor:
                                              MultiPickerApp.background,
                                          child: Center(
                                              child: Text(
                                            "Ok",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        child: ThreeDContainer(
                          width: 130,
                          height: 50,
                          backgroundColor: MultiPickerApp.navigateButton,
                          backgroundDarkerColor: MultiPickerApp.background,
                          child: Center(
                              child: Text(
                            "Upload Images",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: buildGridView(context),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImages() {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseFirestore.instance
              .collection('recent_activity')
              .doc(documnetID)
              .set({'urls': imageUrls}).then((_) {
            setState(() {
              _spinner = true;
            });
            SnackBar snackbar =
                SnackBar(content: Text('Uploaded Successfully'));
            widget.globalKey.currentState.showSnackBar(snackbar);
            setState(() {
              _spinner = true;
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<List<Asset>> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
    return resultList;
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('Gallery/images/$fileName');
    UploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
