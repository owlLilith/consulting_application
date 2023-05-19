import 'dart:convert';
import 'dart:math';

import "package:intl/intl.dart";
import "package:flutter/material.dart";

import "package:http/http.dart" as http;
import '../models/contributor.dart';

class ContributorProvider with ChangeNotifier {
  String? token;
  String? userId;
  List<Contributor> favorites = [];

  final List<Contributor> _contributorsData = [
    Contributor(
      consultingCost: 50,
      walletNumber: "123 56b79 09h8i",
      gender: Gender.female,
      role: Role.expert,
      rate: 4.5,
      id: 65,
      name: "Andrea Chaviz",
      birthDay: DateTime.utc(2000, 7, 20),
      location: "California",
      phoneNumber: "+111 0438",
      email: "AndreaChaviz890@gmail.com",
      consultingDetail:
          "I think sharing an idea with your company collage is a pretty good idea, it increases your confidence and made you one of the participants one with building your company and growth \nso what are you waiting for, call me and i will help you get over your business problems",
      imageUrl:
          "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      experienceCategory: ExperienceCategory.proffesional,
      availableDates: {
        DateTime.now(): [9, 17],
        DateTime.now().add(const Duration(days: 2)): [7, 9],
        DateTime.now().add(const Duration(days: 3)): [10, 13],
      },
    ),
    Contributor(
      consultingCost: 50,
      walletNumber: "123 56b79 09h8i",
      gender: Gender.male,
      role: Role.expert,
      rate: 2.3,
      id: 90,
      name: "John Richreld",
      birthDay: DateTime.utc(1964, 1, 4),
      location: "United State",
      phoneNumber: "+123 674 94",
      email: "JohnRichreld@gmail.com",
      consultingDetail:
          "we all get sick from our daily routine.\nand sometime we start trying anything to cheer us up, even if it doesn't fit our personality, so here is my turn upper, let me help you find your passion, search for your potential through your figure, let me helpe you manege your plans, and make up your mind on the hard decision",
      imageUrl:
          "https://images.pexels.com/photos/834863/pexels-photo-834863.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      experienceCategory: ExperienceCategory.psychological,
    ),
    Contributor(
      gender: Gender.male,
      walletNumber: "123 56b79 09h8i",
      role: Role.expert,
      rate: 3.9,
      id: 89,
      name: "Joshua Huisman",
      birthDay: DateTime.utc(1986, 11, 25),
      location: "Canada",
      phoneNumber: "+061 897 7655",
      email: "Joshua000Huisman000@gmail.com",
      consultingDetail:
          "If you are a teen and you find it hard to talk to your parents or get them to come for your ideas, mom or dad and you can't get your kid to trust you enough to share his problems or life choices with you.\nI can help you get rid of all these problems, just call me and we will talk and build a safe space away from your life.\nBecause every mother, father, daughter, son, person deserves a safe place and a shoulder to cry on",
      imageUrl:
          "https://images.pexels.com/photos/532220/pexels-photo-532220.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      experienceCategory: ExperienceCategory.family,
    ),
    Contributor(
      gender: Gender.female,
      walletNumber: "123 56b79 09h8i",
      role: Role.expert,
      rate: 4.1,
      id: 67,
      name: "Angela Princescarolin",
      birthDay: DateTime.utc(1972, 4, 18),
      location: "Egypt - Cairo",
      phoneNumber: "+031 345 32",
      email: "AngPri123@gmail.com",
      consultingDetail:
          "We all have health problems, or we may be at risk of developing one.\nOr it maybe that you are surrounded by an environment that is harmful to your health and is a vector of infection\nTherefore, I strongly recommend taking a health consulter to constantly monitor your physical condition, so with my experience that may exceed ten years, I believe that I am your best choice",
      imageUrl:
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      experienceCategory: ExperienceCategory.medical,
    )
  ];

  Future<void> fetchContributors(String category) async {
    const String uri = "http://127.0.0.1:8000/Users/CategoryExperts";

    var response = await http.post(
      Uri.parse(uri),
      body: {"consulting_type": category},
      headers: {"Authorization": "Bearer $token"},
    );

    var responseData = json.decode(response.body);

    print(responseData);

    Enum _category = ExperienceCategory.anoun;
    if (responseData["Expert_Information"][0]["consulting_type"] == "family") {
      _category = ExperienceCategory.family;
    }
    if (responseData["Expert_Information"][0]["consulting_type"] ==
        "psychological") _category = ExperienceCategory.psychological;
    if (responseData["Expert_Information"][0]["consulting_type"] ==
        "adminstrative") _category = ExperienceCategory.adminstrative;
    if (responseData["Expert_Information"][0]["consulting_type"] == "medical") {
      _category = ExperienceCategory.medical;
    }
    if (responseData["Expert_Information"][0]["consulting_type"] ==
        "proffesional") _category = ExperienceCategory.proffesional;

    Enum _gender = Gender.anoun;
    if (responseData["Experts"][0][0]["gender"] == "male")
      _gender = Gender.male;
    if (responseData["Experts"][0][0]["gender"] == "female")
      _gender = Gender.female;

    Map<DateTime, List<int>> availabaleDates = {};
    for (var i = 0; i <= 6; i++) {
      if (responseData["Days"][0][0][DateFormat("EEEE")
              .format(DateTime.now().add(Duration(days: i)))
              .toString()
              .toLowerCase()] ==
          1) {
        String index1 = responseData["Days"][0][0][
                "begin_time_${DateFormat("EEEE").format(DateTime.now().add(Duration(days: 1))).toString().toLowerCase()}"]
            .toString()
            .substring(6);
        String index2 = responseData["Days"][0][0][
                "end_time_${DateFormat("EEEE").format(DateTime.now().add(Duration(days: i))).toString().toLowerCase()}"]
            .toString()
            .substring(6);
        availabaleDates.putIfAbsent(
            DateTime.now().add(Duration(days: i)),
            () => [
                  int.parse(index1),
                  int.parse(index2),
                ]);
      }
    }

    if (_contributorsData.where((element) {
      return element.id == responseData["Experts"][0][0]["id"];
    }).isEmpty) {
      _contributorsData.add(
        Contributor(
            id: responseData["Experts"][0][0]["id"],
            name: responseData["Experts"][0][0]["name"],
            email: responseData["Experts"][0][0]["email"],
            gender: _gender,
            phoneNumber: responseData["Expert_Information"][0]["phone"],
            experienceCategory: _category,
            consultingDetail: responseData["Expert_Information"][0]
                ["experience"],
            availableDates: availabaleDates,
            consultingCost: double.parse(
                responseData["Expert_Information"][0]["fee"].toString())),
      );
    }

    notifyListeners();
  }

  Future<List<Contributor>> search(
    String name,
  ) async {
    const uri = "http://127.0.0.1:8000/Users/Search";

    final response = await http.post(
      Uri.parse(uri),
      body: {
        'consultant_name': name,
      },
      headers: {"Authorization": "Bearer $token"},
    );

    final responseData = json.decode(response.body);
    List<Contributor> list = _contributorsData
        .where((element) => element.name == responseData["Result"][0]["name"])
        .toList();

    return list;
  }

  List<Contributor> get contributorsData {
    return _contributorsData;
  }

  Future<void> addToFavorite(int expertId) async {
    const String uri = "http://127.0.0.1:8000/api/favorite";

    print(userId);
    print(expertId);

    var response = await http.post(
      Uri.parse(uri),
      body: {"user_id": int.parse(userId!), "expert_id": expertId},
      headers: {"Authorization": "Bearer $token"},
    );

    var responseData = json.decode(response.body);
    print(response.statusCode);

    print(responseData);
  }

  Future<void> fetchFavorite(String category) async {
    String uri = "http://127.0.0.1:8000/api/favorite_experts";

    var response = await http.get(
      Uri.parse(uri),
      headers: {"Authorization": "Bearer $token"},
    );

    var responseData = json.decode(response.body);

    print(responseData);
  }

  void update(String? updateToken, String updateUserId) {
    token = updateToken;
    userId = updateUserId;
    notifyListeners();
  }
}
