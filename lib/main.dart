// ignore_for_file: prefer_const_constructors

import 'package:fake_store/cartProvider.dart';
import 'package:fake_store/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: false),
            home: const SplashScreen(),
          );
        }));
  }
}
