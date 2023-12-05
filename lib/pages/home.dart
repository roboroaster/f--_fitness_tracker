import 'dart:ui';
import 'package:fitness_tracker/pages/ai_planner.dart';
import 'package:fitness_tracker/pages/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  void goToTrackPage(){
    setState(() {
      currentPage = 1;
    });
  }
  void goToAIPage(){
    setState(() {
      currentPage = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding; // to get device padding
    // Size size = MediaQuery.of(context).size; // to get device screen size
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            currentPage == 0 ? 
            const AIPlannerPage()
            : TrackPage(),
            Column(
              children: [
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 20),
                    child: SizedBox(
                      height: devicePadding.top,
                      width: double.infinity,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                // bottom nav bar
                CustomBottomNavBar(currentPage: currentPage, goToTrackPage: goToTrackPage, goToAIPage: goToAIPage)
              ],
            )
          ]
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback goToTrackPage;
  final VoidCallback goToAIPage;

  const CustomBottomNavBar({super.key, required this.currentPage, required this.goToTrackPage, required this.goToAIPage});

  @override

  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
        child: Container(
          padding: EdgeInsets.only(bottom: devicePadding.bottom + 10, left: 15, right: 15, top: 15),
          // height: devicePadding.bottom + 40,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Platform.isIOS? const Color.fromARGB(20, 0, 0, 0) : Colors.black,
            // color: Color.fromARGB(255, 0, 0, 0),
            border: const Border(top: BorderSide(color: Color.fromARGB(64, 255, 255, 255), width: 0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: goToAIPage,
                child: Icon(
                  Icons.list_alt_outlined,
                  color: currentPage == 0 ?
                    const Color.fromARGB(255, 149, 255, 0)
                      : Colors.white,)),

              GestureDetector(
                onTap: goToTrackPage,
                child: Icon(
                  Icons.pie_chart_outline,
                  color: currentPage == 1 ?
                    const Color.fromARGB(255, 149, 255, 0)
                      : Colors.white,)),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavbarItem extends StatelessWidget {
  const BottomNavbarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}