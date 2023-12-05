import 'dart:convert';

import 'package:fitness_tracker/pages/login_page.dart';
import 'package:fitness_tracker/pages/track.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:http/http.dart' as http;

class AIPlannerPage extends StatefulWidget {
  const AIPlannerPage({super.key});

  // static const List<String> genders = <String>['Male', 'Female', 'Delusional'];

  static List<String> inputNames = [
    'Age',
    'Gender',
    'Height',
    'Weight', //3
    'Fitness Goals', // 4
    'Medical History',

    ///5
    'Workout Preferences', //6
    'Diet Preferences', //7
    'Allergies', //8
    'Workout Level', //9
    'Workout Frequency', //10
    'Workout Duration', //11
    'Workout Type', // 12
    'Equipment Availability',
    'Intensity',
    'Activity Level'
  ];

  static List<TextEditingController> textEditingControllers = [
    for (int i = 0; i < inputNames.length; i++) TextEditingController()
  ];

  @override
  State<AIPlannerPage> createState() => _AIPlannerPageState();
}

class _AIPlannerPageState extends State<AIPlannerPage> {
  Future submitResponse() async {
    setState(() {
      uploading = true;
    });
    // var url = 'http://192.168.29.100:5000/api/get-ai-response';
    var url = 'http://127.0.0.1:5000/api/get-ai-response';
    var body = jsonEncode({
      "user_info": {
        "age": AIPlannerPage.textEditingControllers[0].text,
        "gender": AIPlannerPage.textEditingControllers[1].text,
        "height": AIPlannerPage.textEditingControllers[2].text,
        "weight": AIPlannerPage.textEditingControllers[3].text,
        "medical_history": AIPlannerPage.textEditingControllers[5].text,
        "fitness_goals": AIPlannerPage.textEditingControllers[4].text,
        "activity_level": AIPlannerPage.textEditingControllers[15].text
      },
      "diet_pref": {
        "pref": AIPlannerPage.textEditingControllers[7].text,
        "allergies": AIPlannerPage.textEditingControllers[8].text
      },
      "workout_pref": {
        "level": AIPlannerPage.textEditingControllers[9].text,
        "freq": AIPlannerPage.textEditingControllers[10].text,
        "duration": AIPlannerPage.textEditingControllers[11].text,
        "type": AIPlannerPage.textEditingControllers[12].text,
        "equipment_availability": AIPlannerPage.textEditingControllers[13].text,
        "intensity": AIPlannerPage.textEditingControllers[14].text
      }
    });
    http
        .post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: body)
        .then((value) {
      setState(() {
        gotResponse = true;
        uploading = false;
      });
      print(value.statusCode);
      print(value.body);
      setState(() {
        content = jsonDecode(value.body)['message'];
      });
    });
  }

  bool uploading = false;
  bool gotResponse = false;
  String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PlayAnimationBuilder(
        tween: Tween(begin: 0.01, end: 1),
        duration: const Duration(milliseconds: 500),
        fps: 60,
        curve: Curves.fastLinearToSlowEaseIn,
        builder: (context, value, child) => Opacity(
            opacity: value.toDouble(),
            child: Container(
              color: Colors.black,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                children: [
                  const TopBarC(
                    title: 'AI Planner',
                  ),
                  !uploading && !gotResponse
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Personal Information',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ...AIPlannerPage.inputNames.map(
                              (e) => CustomInputField(
                                  title: e,
                                  widget: CustomInputFieldChildTextInput(
                                    title: e,
                                    controller: AIPlannerPage
                                            .textEditingControllers[
                                        AIPlannerPage.inputNames.indexOf(e)],
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                text: ' Continue ',
                                primaryColor: Colors.white,
                                secondaryColor: Colors.black,
                                function: () => submitResponse()),
                          ],
                        )
                      : uploading && !gotResponse
                          ? Center(
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 30, 30, 30),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: const CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Markdown(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              data: content!),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String title;
  final Widget widget;
  const CustomInputField(
      {super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: widget,
        ));
  }
}

class CustomInputFieldChildTextInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const CustomInputFieldChildTextInput(
      {super.key, required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class CustomDropdownInput extends StatelessWidget {
  final List<String> itemList;
  const CustomDropdownInput({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: DropdownButton(
          dropdownColor: const Color.fromARGB(255, 22, 22, 22),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          style: const TextStyle(color: Colors.white),
          underline: const SizedBox(),
          onChanged: (e) {},
          items: itemList
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList()),
    );
  }
}
