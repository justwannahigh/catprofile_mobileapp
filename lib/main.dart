import 'package:flutter/material.dart';
import 'cat_list_page.dart';

void main() {
  runApp(const CatManagerApp());
}

class CatManagerApp extends StatelessWidget {
  const CatManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          primary: Colors.pink[300],
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
      ),
      home: const CatListPage(),
    );
  }
}