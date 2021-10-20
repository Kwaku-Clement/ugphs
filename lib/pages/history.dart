import 'package:flutter/material.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/widgets/card.dart';
import 'package:tolerance/widgets/sectionHeader.dart';

class History extends StatefulWidget {
  final VoidCallback openDrawer;

  const History({Key key, this.openDrawer}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool local;
  final List names = [
    'University of Ghana Parliament \nUniversity of Ghana Parliament House is the first tertiary parliament established by parliament of Ghana, aimed at practicing DEMOCRACY from below \nTo promote understanding and appreciation of the system of governance among university students leading to the consolidation of Ghana\'s democracy. \nTo educate and conscientise students on their constitutional rights and responsibilities, and to further strive to induce the spirit of patriotism and a sense of national pride. \nTo provide ad interactive platform for the discussion of government policies, especially those directly and indirectly affecting students and youth, thereby making informed contributions into these policies. \nTo serve as agents of change in the society. \nTo instill in members the culture of democratic leadership engagement. \nTo promote and train future leaders.',
  ];
  @override
  void initState() {
    local = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
        title: 'History',
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
              delegate: SliverChildListDelegate.fixed([Container()]),
              itemExtent: MediaQuery.of(context).size.height * 0.05),
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8),
                        child: CardWidget(
                          color: Colors.white,
                          gradient: false,
                          button: false,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${names[index]}",
                                style: TextStyle(
                                    fontFamily: 'Red Hat Display',
                                    fontSize: 15,
                                    color: Color(0xFF585858)),
                              ),
                            ),
                            // subtitle: Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(
                            //     "${coins[index]}",
                            //     style: TextStyle(
                            //         fontFamily: 'Red Hat Display',
                            //         fontSize: 18,
                            //         color: Color(0xFF585858)),
                            //   ),
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
