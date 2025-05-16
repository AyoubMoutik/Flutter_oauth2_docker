import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_oauth2/screens/edit_user.dart';
import 'package:flutter_oauth2/services/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_oauth2/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../helpers/sliderightroute.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();
  List<dynamic> users = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      EasyLoading.show(status: 'Loading users...');
      final response = await _apiService.getUsers();
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body)['users'];
          isLoading = false;
        });
      } else if (response.statusCode == 403) {
        // Not an admin
        if (mounted) {
          Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: const LoginScreen(
                errMsg: 'Access denied. Admin privileges required.',
              ),
            ),
          );
        }
      } else {
        setState(() {
          error = 'Failed to load users';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: ${e.toString()}';
        isLoading = false;
      });
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6C63FF)),
            tooltip: 'Sign Out',
            onPressed: () async {
              await storage.deleteAll();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  SlideRightRoute(
                    page: const LoginScreen(errMsg: 'Logged out successfully'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                ),
              )
              : error.isNotEmpty
              ? Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadUsers,
                color: const Color(0xFF6C63FF),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        title: Text(
                          user['name'] ?? 'No name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              user['email'] ?? 'No email',
                              style: const TextStyle(
                                color: Color(0xFF9098B1),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (user['isAdmin'] ?? false)
                                        ? const Color(
                                          0xFF6C63FF,
                                        ).withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (user['isAdmin'] ?? false) ? 'Admin' : 'User',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      (user['isAdmin'] ?? false)
                                          ? const Color(0xFF6C63FF)
                                          : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF6C63FF),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditUserScreen(user: user),
                              ),
                            );
                            if (result == true) {
                              _loadUsers();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
