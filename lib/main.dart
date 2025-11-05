import 'package:flutter/material.dart';
// import 'login_page.dart'; // 👈 HAPUS ATAU KOMENTARI BARIS INI
import 'splash_page.dart';   // 👈 TAMBAHKAN BARIS INI

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const LoginPage(), // 👈 GANTI BARIS INI
      home: const SplashPage(),  // 👈 MENJADI INI
    );
  }
}