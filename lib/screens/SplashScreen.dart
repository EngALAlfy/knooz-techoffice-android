import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:techoffice/screens/HomeScreen.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Timer t = Timer(Duration(seconds: 10), () => goToRemove(context, HomeScreen()));

      Future.delayed(
          Duration(seconds: 10), () => goToRemove(context, HomeScreen()));
    });
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    //SystemChrome.setEnabledSystemUIOverlays( [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      primary: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/images/knooz.png",
                  width: (300 * 1.5).toDouble(),
                  height: (120 * 1.5).toDouble(),
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 30,
                ),
                IsLoadingWidget(),
                Spacer(),
                Text(
                  "..Aknowledgement..",
                  style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w900),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "This App was contributed and executed by Technical Office soldiers with great honor and out of respect and love , as a try to payback the huge consideration and the unconditional care we get from our",
                        ),
                        TextSpan(
                          text: " Brigadier-General",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: " and also our",
                        ),
                        TextSpan(
                          text: " Father",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: " / ",
                        ),
                        TextSpan(
                          text: "Hesham Abdelati Abdelwahab",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: "\nMany Thanks For Making Everything Easier.",
                        ),
                      ],
                    ),
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    textDirection: TextDirection.ltr,
                    locale: Locale('en', ''),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        sized: false,
        value: SystemUiOverlayStyle(
            // statusBarColor: Colors.white,
            ),
      ),
    );
  }
}
