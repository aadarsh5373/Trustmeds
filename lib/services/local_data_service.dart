import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  static const _userKey = 'trustmeds_user';
  static const _selectedAddressIdKey = 'trustmeds_selected_address_id';
  static const _prescriptionKey = 'trustmeds_latest_prescription';

  late final SharedPreferences _prefs;

  Future<LocalDataService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Map<String, dynamic>? getUserData() {
    final raw = _prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    await _prefs.setString(_userKey, jsonEncode(data));
  }

  String? getSelectedAddressId() {
    return _prefs.getString(_selectedAddressIdKey);
  }

  Future<void> saveSelectedAddressId(String id) async {
    await _prefs.setString(_selectedAddressIdKey, id);
  }

  Map<String, dynamic>? getLatestPrescription() {
    final raw = _prefs.getString(_prescriptionKey);
    if (raw == null || raw.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  Future<void> saveLatestPrescription(Map<String, dynamic> data) async {
    await _prefs.setString(_prescriptionKey, jsonEncode(data));
  }

  Future<void> clearSession() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_selectedAddressIdKey);
  }
}
