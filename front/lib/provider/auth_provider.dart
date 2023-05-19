import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/contributor.dart';
import "package:shared_preferences/shared_preferences.dart";

import 'package:http/http.dart' as http;
import '../error/httpError.dart';

Contributor? _contributor;
String? _token;
var _responseData;

class authProvider with ChangeNotifier {
  String errorMessage = "";

  Contributor get contributor => _contributor!;

  String? get token {
    if (_token != null) return _token;
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate({
    String? name,
    required String email,
    required String password,
    String? role,
    String? gender,
    String? experienceCategory,
    String? consultingDetails,
    int? consultCost,
    String? phoneNumber,
    String? location,
    Map<DateTime, List<int>>? availableDates,
    required String uriSegment,
  }) async {
    var body = uriSegment == "SignUp"
        ? role == Role.user.name
            ? {
                "name": name,
                "email": email,
                "password": password,
                "gender": gender,
                "role": role,
              }
            : {
                "name": name,
                "email": email,
                "password": password,
                "gender": gender,
                "role": role,
                "experience": consultingDetails,
                "consulting_type": experienceCategory,
                "fee": consultCost!.toString(),
                "address": location,
                "phone": phoneNumber,
                for (var i in availableDates!.keys)
                  DateFormat("EEEE").format(i).toLowerCase():
                      availableDates[i]!.first.toString(),
                for (var i in availableDates.keys)
                  "begin_time_${DateFormat("EEEE").format(i).toLowerCase()}":
                      availableDates[i]!.elementAt(1).toString(),
                for (var i in availableDates.keys)
                  "end_time_${DateFormat("EEEE").format(i).toLowerCase()}":
                      availableDates[i]!.last.toString(),
              }
        : {
            "email": email,
            "password": password,
          };

    final uri = "http://127.0.0.1:8000/Register/$uriSegment";

    try {
      var response = await http.post(
        Uri.parse(uri),
        body: body,
      );

      _responseData = await json.decode(response.body);

      print(_responseData);

      if (_responseData!["Status"] == false) {
        var error = _responseData!["Message"];
        throw httpError(error);
      } else {
        _token = _responseData!["Token"];
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "Token": _token,
      });
      prefs.setString("userData", userData);

      await getUser(_responseData["User"]["id"].toString());
      notifyListeners();
    } catch (error) {
      print("******" + error.toString());
      rethrow;
    }
  }

  Future<void> signupUser(String name, String email, String password,
      String role, String gender) async {
    return await authProvider()._authenticate(
        name: name,
        email: email,
        password: password,
        role: role,
        gender: gender,
        uriSegment: "SignUp");
  }

  Future<void> signupExpert(
    String name,
    String email,
    String password,
    String role,
    String gender,
    String experienceCategory,
    String consultingDetails,
    int consultCost,
    String phoneNumber,
    String location,
    Map<DateTime, List<int>> availableDates,
  ) async {
    return await authProvider()._authenticate(
        name: name,
        email: email,
        location: location,
        password: password,
        role: role,
        gender: gender,
        availableDates: availableDates,
        consultCost: consultCost,
        consultingDetails: consultingDetails,
        experienceCategory: experienceCategory,
        phoneNumber: phoneNumber,
        uriSegment: "SignUp");
  }

  Future<void> login(String email, String password) async {
    return await authProvider()
        ._authenticate(email: email, password: password, uriSegment: "LogIn");
  }

  Future<bool> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    // final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    // if (expiryDate.isBefore(DateTime.now())) return false;

    if (extractedUserData["Token"] == null) return false;

    _token = extractedUserData["Token"];
    // this._localId = extractedUserData["localId"];
    // this._expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    const String uri = "http://127.0.0.1:8000/Register/LogOut";
    var response = await http
        .get(Uri.parse(uri), headers: {"Authorization": "Bearer $_token"});
    var responseData = json.decode(response.body);
    if (responseData["Status"]) _token = null;

    notifyListeners();
  }

  Future<void> getUser(String id) async {
    final uri = "http://127.0.0.1:8000/Users/GetUser/$id";

    var response = await http
        .get(Uri.parse(uri), headers: {"Authorization": "Bearer $_token"});
    var responseData = json.decode(response.body);

    Enum _gender;
    if (responseData["User"]["gender"] == "female") {
      _gender = Gender.female;
    } else {
      _gender = Gender.male;
    }

    Enum _role;
    if (responseData["User"]["role"] == "user") {
      _role = Role.user;
    } else {
      _role = Role.expert;
    }
    Enum _category = ExperienceCategory.anoun;
    if (_role == Role.expert) {
      if (responseData["Expert"][0]["consulting_type"] == "family") {
        _category = ExperienceCategory.family;
      } else if (responseData["Expert"][0]["consulting_type"] ==
          "adminstrative") {
        _category = ExperienceCategory.adminstrative;
      } else if (responseData["Expert"][0]["consulting_type"] == "medical") {
        _category = ExperienceCategory.medical;
      } else if (responseData["Expert"][0]["consulting_type"] ==
          "proffesional") {
        _category = ExperienceCategory.proffesional;
      } else if (responseData["Expert"][0]["consulting_type"] ==
          "psychological") {
        _category = ExperienceCategory.psychological;
      }
    }

    Map<DateTime, List<int>> availabaleDate = {};
    if (_role == Role.expert) {
      for (var i = 0; i <= 6; i++) {
        if (responseData["Days"][0][DateFormat("EEEE")
                .format(DateTime.now().add(Duration(days: i)))
                .toString()
                .toLowerCase()] ==
            1) {
          String index1 = responseData["Days"][0][
                  "begin_time_${DateFormat("EEEE").format(DateTime.now().add(Duration(days: 1))).toString().toLowerCase()}"]
              .toString()
              .substring(6);
          String index2 = responseData["Days"][0][
                  "end_time_${DateFormat("EEEE").format(DateTime.now().add(Duration(days: i))).toString().toLowerCase()}"]
              .toString()
              .substring(6);
          availabaleDate.putIfAbsent(
              DateTime.now().add(Duration(days: i)),
              () => [
                    int.parse(index1),
                    int.parse(index2),
                  ]);
        }
      }
    }

    print(availabaleDate);

    _contributor = Contributor(
      id: responseData["User"]["id"],
      name: responseData["User"]["name"],
      email: responseData["User"]["email"],
      gender: _gender,
      role: _role,
      imageUrl: "assets/image/profile_picture.png",
      phoneNumber: _role == Role.expert
          ? responseData["Expert"][0]["phone"].toString()
          : "provide your phone number",
      experienceCategory: _category,
      consultingDetail:
          _role == Role.expert ? responseData["Expert"][0]["experience"] : "",
      consultingCost: _role == Role.expert
          ? double.parse(responseData["Expert"][0]["fee"].toString())
          : 0.0,
      availableDates: _role == Role.expert ? availabaleDate : {},
    );

    notifyListeners();
  }
}
