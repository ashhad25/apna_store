// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:fake_store/Models/getusers.dart';
import 'package:fake_store/components/customAppbar.dart';
import 'package:fake_store/components/custom_alert_dialog.dart';
import 'package:fake_store/database/db_helper.dart';
import 'package:fake_store/views/authentications/register.dart';
import 'package:fake_store/views/products.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  DBHelper? dbHelper = DBHelper();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int? userId;
  String? user_email, user_password;

  loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getInt('userId');
    user_email = sp.getString('user_email');
    user_password = sp.getString('user_password');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                imagePath: 'assets/images/exit_app.png',
                text1: 'Are you sure you want to exit the app?',
                text2: 'Exit',
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          text: 'Login',
          padding: EdgeInsets.fromLTRB(130, 80, 0, 0),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                ReusableTextFormField('Email..', 'Please enter your email',
                    _emailController, false, null),
                ReusableTextFormField(
                  'Password..',
                  'Please enter your password',
                  _passwordController,
                  obscureText,
                  IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText
                              ? obscureText = false
                              : obscureText = true;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility)),
                ),
                Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        User? user = await dbHelper!
                            .getUserByEmail(_emailController.text);

                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'User does not exist. Please register first!'),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                          ));
                        } else if (user.user_password ==
                            _passwordController.text) {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setBool('isLogin', true);
                          sp.setInt('userId', user.user_id!);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('User logged in successfully.'),
                            backgroundColor: Colors.green,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Products(
                                        user_password: user.user_password,
                                        user_name: user.user_name,
                                        user_email: user.user_email,
                                        user_id: user.user_id,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid username or password'),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                          ));
                        }
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF364960))),
                    child: Text('Sign In',
                        style: GoogleFonts.poppins(fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(
                    text: 'New User? ',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF364960),
                        letterSpacing: 2),
                    children: [
                      TextSpan(
                          text: 'Register Now',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            })
                    ]))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget ReusableTextFormField(String label, errorMessage,
      TextEditingController controller, bool obscureText, Widget? suffixIcon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Color(0xFF364960)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF364960), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF364960), width: 2.0),
            ),
            suffixIcon: suffixIcon,
            suffixIconColor: Color(0xFF364960),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          }),
    );
  }
}
