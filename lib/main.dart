import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_oauth2/screens/login.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xFF6C63FF)
    ..backgroundColor = Colors.white
    ..indicatorColor = const Color(0xFF6C63FF)
    ..textColor = const Color(0xFF6C63FF)
    ..maskColor = Colors.black.withOpacity(0.2)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Role',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF6C63FF),
          surface: Colors.white,
          background: const Color(0xFFF5F6F9),
        ),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => const LoginScreen(errMsg: ''),
        // '/Register': (context) => RegisterScreen(),
        // '/Home': (context) => HomeScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
