// ignore_for_file: prefer_const_constructors

import 'package:fake_store/Models/getusers.dart';
import 'package:fake_store/components/customAppbar.dart';
import 'package:fake_store/database/db_helper.dart';
import 'package:fake_store/views/authentications/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  DBHelper? dbHelper = DBHelper();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  saveData(int userId, String user_name, user_email, user_password) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('userId', userId);
    sp.setString('user_name', user_name);
    sp.setString('user_email', user_email);
    sp.setString('user_password', user_password);
  }

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Register',
        padding: EdgeInsets.fromLTRB(110, 80, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              ReusableTextFormField('Name..', 'Please enter your name',
                  _nameController, false, null),
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
                        obscureText ? obscureText = false : obscureText = true;
                      });
                    },
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility)),
              ),
              Container(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      bool ifUserExists = await dbHelper!
                          .checkIfUserExists(_emailController.text);

                      if (!ifUserExists) {
                        User newUser = User(
                          user_name: _nameController.text,
                          user_email: _emailController.text,
                          user_password: _passwordController.text,
                        );

                        User createdUser = await dbHelper!.insertUser(newUser);

                        print(createdUser.user_id);

                        if (createdUser.user_id != null) {
                          // Save data and proceed
                          await saveData(
                              createdUser.user_id!,
                              createdUser.user_name!,
                              createdUser.user_email,
                              createdUser.user_password);
                        } else {
                          // Handle the error case
                          print('Error: user_id is null after insertion');
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User registered successfully!'),
                          backgroundColor: Colors.green,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                        ));

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User already exists!'),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                        ));
                      }
                    }
                  },
                  child:
                      Text('Sign Up', style: GoogleFonts.poppins(fontSize: 18)),
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xFF364960))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text.rich(TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF364960), letterSpacing: 2),
                  children: [
                    TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          })
                  ]))
            ]),
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
