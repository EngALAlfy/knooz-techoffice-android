import 'package:shared_preferences/shared_preferences.dart';

setToken(token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', token);
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
