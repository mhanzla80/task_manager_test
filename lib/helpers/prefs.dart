import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _instance = Prefs._internal();
  static Prefs get instance => _instance;
  Prefs._internal();
  factory Prefs() => _instance;

  static late SharedPreferences _prefs;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  void clear() => _prefs.clear();

  int? loadElapsedTime(String taskId) {
    int? savedTime = _prefs.getInt('elapsedTime_$taskId');
    if (savedTime != null) {
      return savedTime;
    }
    return null;
  }

  Future<void> saveElapsedTime(String taskId, int elapsedTime) async {
    await _prefs.setInt('elapsedTime_$taskId', elapsedTime);
  }

  Future<void> clearElapsedTime(String taskId) async {
    await _prefs.remove('elapsedTime_$taskId');
  }

  // Future<bool> setUserAssessment(AssessmentModel assessment) =>
  //     _prefs.setString(_keyUserAssessment, jsonEncode(assessment.toJson()));

  // AssessmentModel? get userAssessment {
  //   final userString = _prefs.getString(_keyUserAssessment);
  //   if (userString != null) {
  //     final userJson = jsonDecode(userString);
  //     return AssessmentModel.fromJson(userJson);
  //   }
  //   return null;
  // }
  //
  // List<BloodSugar> get getBloodSugarList {
  //   final prefsString = _prefs.getString(_keyBloodSugar) ?? '';
  //   if (prefsString.isEmpty) return [];
  //
  //   final List<dynamic> decodedList = jsonDecode(prefsString);
  //
  //   return BloodSugar.fromJsonList(decodedList).toList();
  // }
  //
  // Future<void> setBloodSugarList(List<BloodSugar> list) =>
  //     _prefs.setString(_keyBloodSugar, jsonEncode(list));
  //
  // List<BloodPressure> getBloodPressureList() {
  //   final prefsString = _prefs.getString(_keyBloodPressure) ?? '';
  //   if (prefsString.isEmpty) return [];
  //
  //   final List<dynamic> decodedList = jsonDecode(prefsString);
  //
  //   return BloodPressure.fromJsonList(decodedList).toList();
  // }
  //
  // Future<void> setBloodPressureList(List<BloodPressure> list) =>
  //     _prefs.setString(_keyBloodPressure, jsonEncode(list));
  //
  // List<Weight> getWeightList() {
  //   final prefsString = _prefs.getString(_keyWeight) ?? '';
  //   if (prefsString.isEmpty) return [];
  //
  //   final List<dynamic> decodedList = jsonDecode(prefsString);
  //
  //   return Weight.fromJsonList(decodedList).toList();
  // }
  //
  // Future<void> setWeightList(List<Weight> list) =>
  //     _prefs.setString(_keyWeight, jsonEncode(list));
  //
  // Future<bool> deleteWeightTarget() => _prefs.remove(_keyWeightList);
}
