import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class AuthService {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<List<BiometricType>> getAuthDevices() async {
    List<BiometricType> availableDevices = [];
    final status = await canAuthenticate();
    if (status) {
      availableDevices = await localAuth.getAvailableBiometrics();
      print(availableDevices);
    }
    return availableDevices;
  }

  Future<bool> authenticate() async {
    final availableDevices = await getAuthDevices();
    if (availableDevices.isNotEmpty) {
      try {
        final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Place your finger on sensor ',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ],
          options: const AuthenticationOptions(useErrorDialogs: false),
        );
        print(didAuthenticate);
        return didAuthenticate;
      } on PlatformException catch (e) {
        if (e.code == auth_error.notEnrolled) {
          print("PlatformException => ${e.code}");
        }
        print("PlatformException => $e");
        return false;
      } catch (e) {
        print("cath => $e");
        return false;
      }
    } else {
      print("No availableDevices");
      return false;
    }
  }

  Future<bool> disableAuth() async {
    return await localAuth.stopAuthentication();
  }
}
