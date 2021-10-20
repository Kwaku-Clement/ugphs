import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolerance/pages/open_pdf.dart';
import 'package:tolerance/service/database.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tolerance/nav/custom_appbar.dart';

class Resources extends StatefulWidget {
  final VoidCallback openDrawer;

  Resources({Key key, this.openDrawer}) : super(key: key);

  @override
  State<Resources> createState() => _ResourcesState();
}

bool isLoading = false;

class _ResourcesState extends State<Resources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(openDrawer: widget.openDrawer, title: 'Resources'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ExpansionTile(
              title: Text('Images'),
              children: [
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Gallery')
                        .orderBy('imageId', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              padding: EdgeInsets.all(4),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.all(3),
                                      child: FadeInImage.memoryNetwork(
                                        fit: BoxFit.cover,
                                        image: snapshot.data.docs[index]
                                            .get('url'),
                                        placeholder: kTransparentImage,
                                      ),
                                    );
                                  }),
                            );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ExpansionTile(
              title: Text('Documents'),
              children: [
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Files')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              padding: EdgeInsets.all(4),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final url =
                                        snapshot.data.docs[index].get('url');

                                    return Container(
                                      child: ListTile(
                                        title: Card(
                                          elevation: 0,
                                          child: Stack(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                      fit: BoxFit.none,
                                                      image: snapshot
                                                          .data.docs[index]
                                                          .get('url'),
                                                      placeholder:
                                                          kTransparentImage,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Image.asset(
                                                  'assets/images/pdf_cover.png',
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          final file =
                                              await Database.loadNetwork(url);

                                          if (file != null) print('loading');
                                          openPDF(context, file);
                                        },
                                      ),
                                    );
                                  }),
                            );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => OpenPDFPage(file: file)),
      );
}
