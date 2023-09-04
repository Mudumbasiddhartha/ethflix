
import 'package:flutter/material.dart';

import 'details_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
        
        },
    );
  }
}