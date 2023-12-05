import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/models/models.dart';
import 'package:fitness_tracker/widgets/list_item.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_animations/simple_animations.dart';

import '../Services/services.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
// bottom modal sheet

  void addDeetsTofoodInfo() async{
    await APIservice()
      .getUserTrackDetails()
        .then((value){
          setState(() {
            calGoal = double.parse(value['total_cals']);
            foodInfos = value['list_meals'];
          });
        });

    // print(foodInfos.last.item);
    // foodInfos = await APIservice().getUserTrackDetails()['list_meals'].toList();
  }
  @override
  void initState() {
    addDeetsTofoodInfo();
    super.initState();
  }
  double calGoal = 0;
  List<MealDetailsModal> foodInfos = [
    // MealDetailsModal(item: 'Burrito', calories: 690, carbs: 100, fats: 100, protiens: 200),
  ];
  DateTime selectedDate = DateTime.now();

  _saveUserTrackDetails(){
    APIservice().saveUserTrackDetails(
      foodInfos,
      foodInfos.map((e) => e.calories).toList().sum.toDouble(),
      calGoal
    );
  }

  _addItemToFoodInfos(MealDetailsModal food){
    setState(() {
      foodInfos.add(food);
    });

    final SnackBar sb = SnackBar(
      content: Text(
        'Added \'${food.item}\' Sucessfully!',
        style: const TextStyle(
          color: Colors.white
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      dismissDirection: DismissDirection.vertical,
      elevation: 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
  }


  _showAddMenu(){
    showModalBottomSheet(
      backgroundColor: Colors.black45,
      barrierColor: Colors.black45,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        TextEditingController mealNameController = TextEditingController();
        TextEditingController calController = TextEditingController();
        TextEditingController carbsController = TextEditingController();
        TextEditingController fatsController = TextEditingController();
        TextEditingController protiensController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) => 
            FractionallySizedBox(
            heightFactor: 0.85,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 22, 22),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubmitCancelButton(icon: Icons.close, color: Colors.red, function: () => Navigator.pop(context),),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.symmetric(vertical: 7.5),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 35, 35, 35),
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            child: const Text(
                              'Add a Meal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                            SubmitCancelButton(
                            icon: Icons.check,
                            color: Colors.green,
                            function: (){
                              if(
                                mealNameController.text != '' && 
                                calController.text != '' && 
                                carbsController.text != '' && 
                                fatsController.text != '' && 
                                protiensController.text != ''
                                ){
                              String mealName = mealNameController.text;
                              int mealCal = int.parse(calController.text);
                              int mealCarbs= int.parse(carbsController.text);
                              int mealFats = int.parse(fatsController.text);
                              int mealProtiens = int.parse(protiensController.text);
                              MealDetailsModal item 
                                  = MealDetailsModal(
                                    item: mealName,
                                    calories: mealCal, 
                                    carbs: mealCarbs,
                                    fats: mealFats,
                                    protiens: mealProtiens
                              );
                              _addItemToFoodInfos(item);
                              _saveUserTrackDetails();
                              print(foodInfos.last.item);
                              Navigator.pop(context);
                              } else {
                                    const SnackBar sb1 = SnackBar(
                                    content: Text(
                                      'Error: Your Input Feild Can\'t Be Empty',
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Color.fromARGB(255, 35, 35, 35),
                                    dismissDirection: DismissDirection.vertical,
                                    elevation: 0,
                                  );
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(sb1);
                              }
                            },
                          ),
                        
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: const Color.fromARGB(255, 35, 35, 35),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     //   showDatePicker(
                        //     //   context: context,
                        //     //   initialDate: DateTime.now(),
                        //     //   firstDate: DateTime(2002),
                        //     //   lastDate: DateTime(3000),
                        //     // ).then(
                        //     //   (pickedTime){
                        //     //     if(pickedTime == null){
                        //     //       print('not selected time lol');
                        //     //       return ;
                        //     //     } else {
                        //     //       setState(() {
                        //     //         selectedDate = pickedTime;
                        //     //         print(selectedDate);
                        //     //       });
                        //     //     }
                        //     //   }
                        //     // );
                        //   },
                        //   child: Text('${daysOfTheWeek[selectedDate.weekday - 1]} ${selectedDate.day} ${monthsOfTheYear[selectedDate.month - 1]}')
                        // ),
                        // const SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Color.fromARGB(255, 37, 35, 41)
                            ),
                            // alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Center(
                                child: TextField(
                                  controller: mealNameController,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 197, 182, 241)
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 12.5),
                                    hintText: 'Add Meal Name'
                                  ),
                                ),
                              ),
                            ),
                            
                          ),
                        )
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        AddMealMacroInputWidget(name: 'Cals',textEditingController: calController),
                        const Gap(10),
                        AddMealMacroInputWidget(name: 'Carbs',textEditingController: carbsController),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        AddMealMacroInputWidget(name: 'Fats',textEditingController: fatsController),
                        const Gap(10),
                        AddMealMacroInputWidget(name: 'Protiens',textEditingController: protiensController),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> daysOfTheWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> monthsOfTheYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: APIservice().getUserTrackDetails(),
        builder: (context, snapshot) => 
        snapshot.hasData ?
            PlayAnimationBuilder(
          tween: Tween(begin: 0.01, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          fps: 60,
          builder: (context, value, child) => 
            Opacity(
              opacity: value.toDouble(),
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                  children: [
                    const TopBarC(title: 'Tracking',),
                    ThePieChart(totalCals: calGoal, consumedCals: foodInfos.map((e) => e.calories).toList().sum.toDouble()),
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 22, 22, 22),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),  
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  ),
                                children: [
                                  TextSpan(text: foodInfos.map((e) => e.carbs).toList().sum.toString()),
                                  const TextSpan(
                                    text: '\nCarbs',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                      ),
                                    )
                                  ]
                                )
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: .8,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  ),
                                children: [
                                  TextSpan(text: foodInfos.map((e) => e.protiens).toList().sum.toString()),
                                  const TextSpan(
                                    text: '\nProtiens',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                      ),
                                    )
                                  ]
                                )
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: .8,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  ),
                                children: [
                                  TextSpan(text: foodInfos.map((e) => e.fats).toList().sum.toString()),
                                  const TextSpan(
                                    text: '\nFats',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                    ),
                                  )
                                ]
                              )
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            ' Meals',
                            style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            ),
                          ),
                          InkWell(
                            onTap: () => _showAddMenu(),
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            child: Ink(
                              height: 32,
                              width: 32,
                              child: const Center(
                                child: Icon(
                                  Icons.add_circle,
                                  size: 32,
                                  color: Color.fromARGB(255, 149, 255, 0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 22, 22, 22)
                      ),
                      child: 
                      foodInfos.isNotEmpty ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ...(snapshot.data!['list_meals']).map((e) => ListItemCustom(mealDetailsModal: e))
                          ...foodInfos.map((e) => ListItemCustom(mealDetailsModal: e))
                        ],
                      ) : const Center(child: Text('No Meals Yet 🙁', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                    ),
                    SizedBox(height: devicePadding.bottom + 80,)
                  ],
              ),
            ),
          ),
        ) : const Center(child: CupertinoActivityIndicator(),)
      ),
    );
  }
}




// Top Bar
class TopBarC extends StatelessWidget {
  final String title;
  const TopBarC({super.key, required this.title});
  static List<String> daysOfTheWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static List<String> monthsOfTheYear = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
  EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Container(
      margin: EdgeInsets.only(top: devicePadding.top + 20, bottom: 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${daysOfTheWeek[DateTime.now().weekday - 1]} ${DateTime.now().day} ${monthsOfTheYear[DateTime.now().month - 1]}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 149, 255, 0),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Futura'
                ),
              ),
            ],
          ),
          PopupMenuButton(
            color: const Color.fromARGB(255, 22, 22, 22),
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  // image: NetworkImage('https://ichef.bbci.co.uk/images/ic/704xn/p02hdy14.jpg'),
                  image: AssetImage('assets/logo_w.png'),
                  fit: BoxFit.cover
                )
              ),
            ),
            itemBuilder: (context) {
              return [ 
              const PopupMenuItem<int>(
                  value: 0,
                  child: Text("My Account"),
              ),
              const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Settings"),
              ),
              PopupMenuItem<int>(
                onTap: () => FirebaseAuth.instance.signOut(),
                  value: 2,
                  child: const Text("Logout"),
              ),];
            },
          )
        ],
      ),
    );
  }
}




// The Pie Chart



// ignore: must_be_immutable
class ThePieChart extends StatefulWidget {
  final double totalCals;
  final double consumedCals;
  ThePieChart({super.key, required this.totalCals, required this.consumedCals});

  GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  @override
  State<ThePieChart> createState() => _ThePieChartState();
}

class _ThePieChartState extends State<ThePieChart> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.consumedCals);
    setState(() {
      widget._chartKey.currentState?.updateData(
          [
            CircularStackEntry(
              [
                CircularSegmentEntry(widget.consumedCals / widget.totalCals * 100, const Color.fromARGB(255, 149, 255, 0), rankKey: ''),
                const CircularSegmentEntry(100,Color.fromARGB(156, 62, 124, 0)),
              ]
            ),
          ]
      );
    });
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: size.width/1.4,
        height: size.width/1.4,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size.width/1.4 - 100,
                height: size.width/1.4 - 100,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(size.width/2.8))
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text:  TextSpan(
                          style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Futura'
                        ),
                          children:  [
                            TextSpan(text: widget.consumedCals.toInt().toString()),
                          ]
                        )
                      ),
                      const Text(
                        'cal',
                        style: TextStyle( 
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
            AnimatedCircularChart(
              key: widget._chartKey,
              size: Size(size.width/1.4 + 160, size.width/1.4 + 160),
              duration: const Duration(milliseconds: 700),
              initialChartData: [
                CircularStackEntry(
                  [
                    CircularSegmentEntry(widget.consumedCals / widget.totalCals * 100, const Color.fromARGB(255, 149, 255, 0), rankKey: ''),
                    const CircularSegmentEntry(100,Color.fromARGB(156, 62, 124, 0)),
                  ]
                ),
              ],
              chartType: CircularChartType.Radial,
              percentageValues: true,
              edgeStyle: SegmentEdgeStyle.round,
              holeRadius: size.width/1.4/2 - 80,
              ),
          ],
        ),
      ),
    );
  }
}

class SubmitCancelButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback function;
  const SubmitCancelButton({super.key, required this.icon, required this.color, required this.function});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: function,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        splashColor: color.withAlpha(100),
        child: Ink(
          padding: const EdgeInsets.all(7.5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: color.withAlpha(50),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}


class AddMealMacroInputWidget extends StatelessWidget {
  final String name;
  final TextEditingController textEditingController;
  const AddMealMacroInputWidget({super.key,  required this.name, required this.textEditingController,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color.fromARGB(255, 37, 35, 41)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 197, 182, 241),
              ),
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12.5),
                hintText: '000'
              ),
              controller: textEditingController,
            ),
          ),
          const Gap(7.5),
          Container(
            height: 20,
            width: 2,
            color: Colors.white10,
          ),
          const Gap(7.5),
          Text(
            name
          ),
        ],
      )
    );
  }
}