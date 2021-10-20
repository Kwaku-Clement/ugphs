import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:tolerance/admin/add_announcement.dart';
import 'package:tolerance/admin/add_forum.dart';
import 'package:tolerance/admin/add_image.dart';
import 'package:tolerance/admin/add_leader.dart';
import 'package:tolerance/admin/add_program.dart';
import 'package:tolerance/admin/add_recent_activiies.dart';
import 'package:tolerance/authentication/signup_screen.dart';
import 'package:tolerance/constants/constants.dart';
import 'package:tolerance/constants/custom_colors.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/repository/questions.dart';
import 'package:tolerance/widgets/BottomSheet.dart';
import 'package:tolerance/widgets/card.dart';
import 'package:tolerance/widgets/sectionHeader.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const HomePage({Key key, @required this.openDrawer}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream slides;
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  CarouselSliderController _sliderController = CarouselSliderController();

  bool dataReceived = false;
  String userRole = '';
  int _current = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      userRole = userdoc.get('role');
      dataReceived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseGrey,
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
        title: '',
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CardWidget(
                      gradient: false,
                      button: false,
                      color: CustomColors.firebaseGrey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Today",
                              style: TextStyle(
                                  fontFamily: 'Red Hat Display',
                                  fontSize: 20,
                                  color: CustomColors.googleBackground,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              getStrToday(),
                              style: TextStyle(
                                  fontFamily: 'Red Hat Display',
                                  fontSize: 18,
                                  color: CustomColors.googleBackground,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  text: 'Recent Activities',
                  onPressed: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('imageURLs')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 270,
                              child: CarouselSlider.builder(
                                enableAutoSlider: true,
                                unlimitedMode: true,
                                itemCount: snapshot.data.docs.length,
                                controller: _sliderController,
                                slideBuilder: (index) {
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.network(
                                        snapshot.data.docs[index].get('url'),
                                      ),
                                    ),
                                  );
                                },
                                slideIndicator: CircularSlideIndicator(
                                  padding: EdgeInsets.only(bottom: 2),
                                  indicatorBorderColor: Colors.grey,
                                  currentIndicatorColor: Colors.blueAccent,
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(text: 'Upcoming Activities'),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 28.0,
                    left: 10,
                    right: 10,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 245,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: repository.getScheduleStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());

                          return _buildList(context, snapshot.data.docs);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: dataReceived == false
          ? Container()
          : userRole == 'Admin'
              ? FloatingActionButton(
                  onPressed: adminMenu,
                  tooltip: 'Update',
                  child: const Icon(Icons.add))
              : Container(),
    );
  }

  adminMenu() {
    showModalBottomSheet(
        enableDrag: false,
        context: (context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: BottomSheetWidget(
              container: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(icons[index]),
                              title: Text(
                                "${names[index]}",
                              ),
                              onTap: () => selectedUpdate(context, index),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final question = Question.fromSnapshot(snapshot);
    if (question == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: Expanded(
          child: CardWidget(
            color: Colors.white,
            gradient: false,
            button: false,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(question.name == null ? "" : question.name,
                    style: BoldStyle),
              ),
            ),
          ),
        ));
  }

  selectedUpdate(BuildContext context, item) {
    switch (item) {
      case 0:
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 260,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Choose what you want to update'),
                        ),
                        SizedBox(height: 10),
                        Card(
                          child: InkWell(
                              child: ListTile(
                                leading: Icon(Icons.file_upload),
                                title: Text('Documents'),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddImage(),
                                    ));
                              }),
                        ),
                        Card(
                          child: InkWell(
                              child: ListTile(
                                leading: Icon(Icons.picture_in_picture),
                                title: Text('Images'),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddImage(),
                                    ));
                              }),
                        ),
                        Card(
                          child: InkWell(
                            child: ListTile(
                              leading: Icon(Icons.recent_actors),
                              title: Text('Recent Activities'),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddRecentActivities(),
                                  ));
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            });
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAnnouncement(),
            ));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLeader(),
            ));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSchedule(),
            ));
        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddForum(),
            ));
        break;
      case 5:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(),
            ));
        break;
    }
  }

  final List names = [
    'Update resources',
    'Add announcement',
    'Update Executives',
    'Add Schedule',
    'Add Forum',
    'Create user'
  ];

  final List icons = [
    Icons.folder_open_outlined,
    Icons.announcement_outlined,
    Icons.leaderboard,
    Icons.schedule,
    Icons.forum,
    Icons.person_add,
  ];
}
