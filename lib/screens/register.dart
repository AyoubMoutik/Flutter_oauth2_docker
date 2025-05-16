import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/helpers/sliderightroute.dart';
import 'package:flutter_oauth2/screens/login.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static const String _title = 'Register';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: _title, home: StatefulRegisterWidget());
  }
}

class StatefulRegisterWidget extends StatefulWidget {
  const StatefulRegisterWidget({super.key});

  @override
  State<StatefulRegisterWidget> createState() => _StatefulRegisterWidget();
}

class _StatefulRegisterWidget extends State<StatefulRegisterWidget> {
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    size: 80,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please fill in your details',
                  style: TextStyle(fontSize: 16, color: Color(0xFF9098B1)),
                ),
                const SizedBox(height: 40),
                // Name Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Full Name',
                        hintStyle: const TextStyle(color: Color(0xFF9098B1)),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF6C63FF),
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Color(0xFF9098B1)),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF6C63FF),
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFF9098B1)),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF6C63FF),
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Register Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (_registerFormKey.currentState!.validate()) {
                          _registerFormKey.currentState!.save();
                          EasyLoading.show();
                          var res = await authService.register(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                          );

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              Navigator.push(
                                context,
                                SlideRightRoute(
                                  page: const LoginScreen(
                                    errMsg: 'Registered Successfully',
                                  ),
                                ),
                              );
                              break;
                            case 400:
                              EasyLoading.dismiss();
                              var data = jsonDecode(res.body);
                              if (data["msg"] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(data["msg"].toString()),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registration Failed"),
                                  ),
                                );
                              }
                              break;
                            default:
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Registration Failed"),
                                ),
                              );
                              break;
                          }
                        }
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Login Link
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9098B1),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    SlideRightRoute(
                                      page: const LoginScreen(errMsg: ''),
                                    ),
                                  );
                                },
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
