import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//widgets
import '../widgets/home_dropdown.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NeumorphicAppBar appbar = NeumorphicAppBar(
      centerTitle: true,
      // backgroundColor: Colors.teal,
      title: Text('instaControl'),
    );
    return Scaffold(
      appBar: appbar,
      body: HomeDropdown(),
    );
  }
}
