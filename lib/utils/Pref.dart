import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getPref() async =>
    await SharedPreferences.getInstance();

Future<String> getSting(key) async => (await getPref()).getString(key);

Future<bool> getBool(key) async => (await getPref()).getBool(key);

Future<double> getDouble(key) async => (await getPref()).getDouble(key);

Future<int> getInt(key) async => (await getPref()).getInt(key);

Future<Map<String, dynamic>> getJson(key) async =>
    json.decode((await getPref()).getString(key));

//

Future<bool> setSting(key, value) async =>
    (await getPref()).setString(key, value);

Future<bool> setBool(key, value) async => (await getPref()).setBool(key, value);

Future<bool> setDouble(key, value) async =>
    (await getPref()).setDouble(key, value);

Future<bool> setInt(key, value) async => (await getPref()).setInt(key, value);

Future<bool> setJson(key, Map<String, dynamic> value) async =>
    (await getPref()).setString(key, json.encode(value));
