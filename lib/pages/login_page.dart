
import 'package:fitness_tracker/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isSigninPage = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1554139844-af2fc8ad3a3a?q=80&w=2397&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
              ),
              fit: BoxFit.cover
            )
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      image: DecorationImage(
                        image: NetworkImage('https://i.giphy.com/media/3otO6NFBIAFg2vPZuM/giphy.webp'),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(CupertinoIcons.arrow_right, color: Colors.white),
                          Image.network('https://icons.veryicon.com/png/o/internet--web/iview-3-x-icons/logo-google.png'),
                          const Icon(CupertinoIcons.arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.black38,
                      onTap: () {
                        AuthService().signInWithGoogle();
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: Ink(
                        width: double.infinity,
                        height: 64,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // child: Center(
          //   child: Container(
          //     width: double.infinity,
          //     margin: const EdgeInsets.all(12),
          //     padding: const EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: const BorderRadius.all(Radius.circular(20)),
          //       boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10)]
          //     ),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: 50,
          //           height: 50,
          //           padding: const EdgeInsets.all(13),
          //           decoration: const BoxDecoration(
          //             color: Color.fromARGB(255, 25, 25, 25),
          //             borderRadius: BorderRadius.all(Radius.circular(12)),
          //           ),
          //           child: Image.asset('assets/logo_w.png'),
          //         ),
          //         const SizedBox(height: 10,),
                  
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hintText;
  const CustomInputField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 200, 200, 200), fontSize: 15),
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  final Color primaryColor;
  final Color secondaryColor;
  const CustomButton({super.key, required this.text, required this.function, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    Color textColor = secondaryColor;
    Color bgColor = primaryColor == Colors.white ? const Color.fromARGB(255, 240, 240, 240) : Colors.black;
    Color borderColor = primaryColor == Colors.white ? Colors.grey.withAlpha(10) : Colors.black;
    Color splashColor = secondaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        splashColor: splashColor,
        onTap: function,
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            border: Border.all(width: 1, color: borderColor)
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor, 
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}