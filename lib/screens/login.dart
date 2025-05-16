import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/helpers/sliderightroute.dart';
import 'package:flutter_oauth2/screens/home.dart';
import 'package:flutter_oauth2/screens/register.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_oauth2/screens/admin_dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.errMsg});
  final String errMsg;
  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: StatefulLoginWidget(errMsg: errMsg),
    );
  }
}

class StatefulLoginWidget extends StatefulWidget {
  const StatefulLoginWidget({super.key, required this.errMsg});
  final String errMsg;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulLoginWidget> createState() =>
      _StatefulLoginWidget(errMsg: errMsg);
}

class _StatefulLoginWidget extends State<StatefulLoginWidget> {
  _StatefulLoginWidget({required this.errMsg});
  final String errMsg;
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  void checkToken() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          SlideRightRoute(page: const HomeScreen()),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();

    if (errMsg.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errMsg)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Logo or Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please sign in to continue',
                  style: TextStyle(fontSize: 16, color: Color(0xFF9098B1)),
                ),
                const SizedBox(height: 50),
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
                        if (value == null) {
                          return 'Please enter your email';
                        }
                        return EmailValidator.validate(value)
                            ? null
                            : 'Please enter a valid email';
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
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: _obscurePassword,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF6C63FF),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Login Button
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
                        if (_loginFormKey.currentState!.validate()) {
                          _loginFormKey.currentState!.save();
                          EasyLoading.show();
                          var res = await authService.login(
                            _emailController.text,
                            _passwordController.text,
                          );

                          switch (res!.statusCode) {
                            case 200:
                              EasyLoading.dismiss();
                              var data = jsonDecode(res.body);
                              await storage.write(
                                key: "token",
                                value: data['access_token'],
                              );
                              await storage.write(
                                key: "refresh_token",
                                value: data['refresh_token'],
                              );
                              if (!context.mounted) return;

                              if (data['isAdmin'] == true) {
                                Navigator.pushReplacement(
                                  context,
                                  SlideRightRoute(page: const AdminDashboard()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  SlideRightRoute(page: const HomeScreen()),
                                );
                              }
                              break;
                            case 401:
                              EasyLoading.dismiss();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Wrong email or password!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              break;
                            default:
                              EasyLoading.dismiss();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Something went wrong!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              break;
                          }
                        }
                      },
                      child: const Text(
                        'Sign In',
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
                // Register Link
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9098B1),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign Up',
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: const RegisterScreen(),
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
