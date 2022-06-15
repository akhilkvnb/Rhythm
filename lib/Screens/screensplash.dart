import 'package:flutter/material.dart';
import 'package:music_player/Screens/screen_main.dart';
import 'package:music_player/functions/db_functions.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    splash();
    DBfunction.function();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color.fromARGB(255, 0, 15, 27)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(width: 5),
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      color: Color.fromARGB(255, 9, 34, 48),
                      spreadRadius: 15),
                ],
                image: const DecorationImage(
                    image: AssetImage(
                      'assets/New Project.jpg',
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Rhythm',
                style: TextStyle(
                    fontFamily: 'Cursive',
                    fontSize: 40,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  splash() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const ScreenMain(),
      ),
    );
  }
}
