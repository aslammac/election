import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
//providers
//models
import '../models/booth_model.dart';
import '../models/contact_model.dart';

class ContactScreen extends StatelessWidget {
  final BoothModel booth;
  ContactScreen(this.booth);
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text('Contacts'),
        buttonStyle: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          depth: 1,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 30),
          Row(
            children: [
              Spacer(),
              Neumorphic(
                child: Container(
                  width: 300,
                  // height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${booth.id}. ${booth.pollingStation}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Divider(),
                        listTileWidget(
                            'Operator',
                            booth.contactModel.operatorName,
                            booth.contactModel.operatorNumber,
                            _makePhoneCall),
                        listTileWidget(
                            'Control room officer',
                            booth.contactModel.taName,
                            booth.contactModel.taNumber,
                            _makePhoneCall),
                        listTileWidget(
                            'Akshaya block co-ordinator',
                            booth.contactModel.adpaName,
                            booth.contactModel.adpaNumber,
                            _makePhoneCall),
                        listTileWidget(
                            'BSNL officer',
                            booth.contactModel.bsnlName,
                            booth.contactModel.bsnlNumber,
                            _makePhoneCall),
                        listTileWidget(
                            'IT MISSION engineer',
                            booth.contactModel.hseName,
                            booth.contactModel.hseNumber,
                            _makePhoneCall,
                            divider: false),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}

Widget listTileWidget(String title, String name, String number, Function call,
    {bool divider = true}) {
  return Column(
    children: [
      ListTile(
        dense: true,
        horizontalTitleGap: 2,
        title: Text(
          title,
        ),
        subtitle: Text(
          name,
        ),
        trailing: Container(
          // color: Colors.black,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35), color: Colors.black12),
          child: IconButton(
            icon: NeumorphicIcon(
              Icons.phone,
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                color: Colors.black54,
                depth: 5,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
              ),
            ),
            onPressed: () => call('tel:$number'),
          ),
        ),
      ),
      if (divider) Divider()
    ],
  );
}
