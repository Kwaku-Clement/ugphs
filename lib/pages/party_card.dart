import 'package:flutter/material.dart';
import 'package:tolerance/nav/custom_appbar.dart';
import 'package:tolerance/widgets/card.dart';
import 'package:tolerance/widgets/sectionHeader.dart';

class PartyCard extends StatefulWidget {
  final VoidCallback openDrawer;

  const PartyCard({Key key, this.openDrawer}) : super(key: key);

  @override
  _PartyCardState createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  String text =
      'A member will have Identity card if he or she has served for one year and qualify to contest for any position aside speaker which is in the standing order 7 clause 2(a)I. \n\nAny member shalll be sanctioned by the privilege committee and return all documents which belong to the urgust house base on standing order 10 clause a, b, c, d, e, and f \n\nOrder 10 \nA members shall sanction by the privilege committee \n';
  bool value = false;

  final List names = [
    'He / she absent himself/ herald parliamentary sittings for three consecutive times in a semester without any written permission obtained from Mr. Speaker, however subject to appeal to the board of parliamentary service.',
    'He/she misbehave at parliamentary sittings.',
    'Charge or found guilty of contempt of parliament under the standing order 6,7,1 and 9.',
    'He / She is found to be unparliamentary in his/ her dressing code.',
    'All sanctions shall only be applicable upon referral by Mr. Speaker to the privilege committee.',
    'For the avoidance of doubt any member has the right to call the attention of Mr. Speaker to any act that deserves sanctioning.',
  ];

  final List index = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CardWidget(
              gradient: false,
              button: false,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(text),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: index.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4),
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              "${index[i]}.",
                              style: TextStyle(
                                  fontFamily: 'Red Hat Display',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              "${names[i]}",
                              style: TextStyle(
                                  fontFamily: 'Red Hat Display',
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  CheckboxListTile(
                    value: this.value,
                    onChanged: (checked) {
                      setState(() {
                        this.value = checked;
                      });
                    },
                    title: Text('Accept'),
                  ),
                  TextButton(
                    onPressed: value ? () {} : null,
                    child: Text('Request for party Card'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
