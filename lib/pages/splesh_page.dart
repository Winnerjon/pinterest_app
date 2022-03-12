import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinterest_app/models/fade_animation.dart';
import 'package:pinterest_app/pages/home_page.dart';

class SpleshPage extends StatefulWidget {
  static const String id = "/splesh_page";

  const SpleshPage({Key? key}) : super(key: key);

  @override
  _SpleshPageState createState() => _SpleshPageState();
}

class _SpleshPageState extends State<SpleshPage> {
  void _openGlobalPage() {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    });
  }

  @override
  void initState() {
    _openGlobalPage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeAnimation(
        2,
        Center(
          child: Image(
            image: AssetImage("assets/images/locals/img_2.png"),
            height: 120,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}
