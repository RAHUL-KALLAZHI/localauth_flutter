import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/screens/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../service/auth_service.dart';
import '../service/shared_prfs_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferenceService sharedPrfns;
  late AuthService authService;

  @override
  void initState() {
    sharedPrfns = SharedPreferenceService();
    authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isEnabled = await sharedPrfns.getStatus();
      if (isEnabled) {
        final status = await authService.authenticate();
        if (status) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Authentication Failed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
              content: Text(
                "Biometric Autharization is required",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text("OK")),
              ],
            ),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
    return const Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Colors.purple,
          size: 30,
        ),
      ),
    );
  }
}
