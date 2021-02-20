import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipic/models/user.dart';
import 'package:recipic/pages/wrapper.dart';
import 'package:recipic/services/auth.dart';

//Edited the main.dart to direct to newly designed UI elements

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        //theme: ThemeData.dark(),
      ),
    );
  }
}
