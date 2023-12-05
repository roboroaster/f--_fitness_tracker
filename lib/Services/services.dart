import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracker/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ThemeColors{
  final bool darkMode;
  ThemeColors({
    required this.darkMode
  });

  late bool isDarkMode = darkMode;
  late Color backgroundColor = darkMode ?Colors.black : Colors.white;
  late Color mainTextColor = darkMode ?Colors.white : Colors.black;
  late Color topAppBarColor = darkMode ?Colors.black45 : Colors.transparent;
  late Color iconColor = darkMode ? Colors.white : Colors.black;
  late Color defaultButtonColor = darkMode ? const Color.fromARGB(255, 40, 40, 40) : const Color.fromARGB(255, 225, 225, 225);
  late Color pressedButtonColor = darkMode ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 245, 245, 245);
  late Color subTextColor = darkMode ? Colors.grey : const Color.fromARGB(255, 90, 90, 90);
  late IconData colorModeIcon = darkMode ? Icons.light_mode : Icons.dark_mode;
}

class APIservice{
  // String api = 'http://127.0.0.1:5000/api';
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String uid = user!.uid;

  String api = 'http://127.0.0.1:5000/api';

  Future<Map<String, dynamic>> getUserTrackDetails() async{
    print(uid);
    String endpt = '/get-user-track-details';
    var uri = Uri.parse(api+endpt);
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
        'user_id' : uid
        }
      )
    );
    print(response.body);
    var data = jsonDecode(response.body);
    var message = data['message'];
    print(data['message']);
    List<MealDetailsModal> listMeals = []; 
    if(message['items-consumed'] != null){
      for(Map<String, dynamic> i in message['items-consumed']){
        listMeals.add(
          MealDetailsModal(
            item: i['name']!,
            calories: int.parse(i['calories']!),
            carbs: int.parse(i['carbs']!),
            fats: int.parse(i['fats']!),
            protiens: int.parse(i['protiens']!)
            )
          );
      }
    }
    return {
      'total_cals': message['calorie_goal'],
      'consumed_cals' : message['calorie_consumed'],
      'list_meals' : listMeals
    };
  }

  saveUserTrackDetails(List<MealDetailsModal> foodInfos, double consumedCals, double calGoal) async{
    String endpt = '/save-user-track-details';
    var uri = Uri.parse(api+endpt);
    List<Map<String, String>> itemsConsumed = [];
    for(MealDetailsModal i in foodInfos){
      itemsConsumed.add(
        {
          'calories' : '${i.calories}',
          'carbs' : '${i.carbs}',
          'fats' : '${i.fats}',
          'name' : i.item,
          'protiens' : '${i.protiens}',
        }
      );
    }
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {
          "user_id": uid,
          "calorie_consumed": "$consumedCals",
          "calorie_goal": "$calGoal",
          "items-consumed": itemsConsumed
        }
      )
    );
    print(jsonDecode(response.body));
  }
  
}