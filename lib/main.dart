import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(Myapp());
  }
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        fontFamily:"Poppins",
        primarySwatch: Colors.cyan
      ),
      home: Home(),
    );
  }
}

