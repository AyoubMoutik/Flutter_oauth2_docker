import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../helpers/sliderightroute.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  static const String _title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: _title, home: StatefulHomeWidget());
  }
}

class StatefulHomeWidget extends StatefulWidget {
  const StatefulHomeWidget({super.key});

  @override
  State<StatefulHomeWidget> createState() => _StatefulHomeWidget();
}

class _StatefulHomeWidget extends State<StatefulHomeWidget> {
  late final String errMsg = "";
  late String secureMsg = "Loading...";
  final storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (errMsg.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errMsg)));
      });
    }
  }

  Future getSecureData() async {
    try {
      Response resp = await apiService.getSecretArea();
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        return data;
      } else {
        throw Exception('Failed to load protected data');
      }
    } catch (e) {
      await storage.deleteAll(); // Clear tokens on error
      if (mounted) {
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: const LoginScreen(
              errMsg: 'Session expired, please login again',
            ),
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flutter OAuth2',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xFF6C63FF)),
                    tooltip: 'Sign Out',
                    onPressed: () async {
                      await storage.deleteAll();
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          SlideRightRoute(
                            page: const LoginScreen(errMsg: 'User logged out'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder(
                  future: getSecureData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data as Map<String, dynamic>;
                      var user = data['user'] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Welcome ${user['name']}!',
                                style: const TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F6F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF6C63FF),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user['email'],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  data['msg'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF2D3142),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Error loading protected data',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6C63FF),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
