// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fake_store/services/utilites/network_connectivity.dart';
import 'package:fake_store/views/authentications/login.dart';
import 'package:fake_store/views/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool('isLogin') ?? false;
    String name = sp.getString('user_name') ?? '';
    String email = sp.getString('user_email') ?? '';
    String password = sp.getString('user_password') ?? '';
    int userId = sp.getInt('user_id') ?? 0;
    if (isLogin) {
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      user_name: name,
                      user_email: email,
                      user_id: userId,
                      user_password: password,
                    )));
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkAndNavigate();

    // Subscribe to connectivity changes
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          checkAndNavigate();
        } else {
          InternetConnectivityHelper.showRetryDialog(context);
        }
      });
    });
  }

  StreamSubscription<ConnectivityResult>? subscription;

  Future<void> checkAndNavigate() async {
    bool isConnected =
        await InternetConnectivityHelper.checkInternetConnectivity(context);

    if (isConnected) {
      isLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      blurStyle: BlurStyle.normal,
                      offset: Offset(0, 3),
                    )
                  ],
                  color: Color(0xFF364960),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Icon(Icons.shopping_cart,
                          size: 100, color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Fake Store',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20, letterSpacing: 3, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    SpinKitFadingCircle(
                      color: Color(0xFF364960),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Designed By Ashhad',
                      style: GoogleFonts.inter(color: Color(0xFF364960)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'ashhadahmed72@gmail.com',
                      style: GoogleFonts.inter(color: Color(0xFF364960)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
