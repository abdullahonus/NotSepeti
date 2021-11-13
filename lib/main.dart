import 'package:flutter/material.dart';
import 'package:not_sepeti/utils/database_helper.dart';

import 'not_listesi.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir();
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Montserrat",
        primaryColor: Color(0xff501E4B),
        backgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(color: Color(0xff501E4B)),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xff501E4B)),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Countrol4',
      home: NotListesi(),
    );
  }
}
