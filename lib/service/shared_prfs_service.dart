import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  late SharedPreferences preference;

  Future<bool> getStatus() async {
    preference = await SharedPreferences.getInstance();
    return preference.getBool("isEnabled") ?? false;
  }

  Future<bool> setStatus() async {
    preference = await SharedPreferences.getInstance();
    return await preference.setBool("isEnabled", true);
  }

  Future<bool> clearStatus() async {
    preference = await SharedPreferences.getInstance();
    return await preference.clear();
  }
}
