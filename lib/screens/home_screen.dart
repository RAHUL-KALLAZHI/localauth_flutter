import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../service/shared_prfs_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthService localAuth;
  late SharedPreferenceService sharedPreferenceService;

  @override
  void initState() {
    localAuth = AuthService();
    sharedPreferenceService = SharedPreferenceService();
    super.initState();
  }

  Future<void> enableAuth() async {
    final canAuthenticate = await localAuth.canAuthenticate();
    if (canAuthenticate) {
      sharedPreferenceService.setStatus().then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.purple,
                behavior: SnackBarBehavior.floating,
                content: Text("Authentication Enabled"),
              ),
            )
          });
    }
  }

  Future<void> disableAuth() async {
    final status = await localAuth.disableAuth();
    if (status) {
      sharedPreferenceService.clearStatus().then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.purple,
                behavior: SnackBarBehavior.floating,
                content: Text("Authentication Disabled"),
              ),
            )
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                await enableAuth();
              },
              child: const Text("Enable Authentication"),
            ),
            OutlinedButton(
              onPressed: () async {
                await disableAuth();
              },
              child: const Text("Disable Authentication"),
            ),
          ],
        ),
      ),
    );
  }
}
