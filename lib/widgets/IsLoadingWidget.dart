import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IsLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int i = Random().nextInt(27);

    Widget progress = CircularProgressIndicator();

    switch (i) {
      case 0:
        progress = SpinKitChasingDots(color: Colors.blueGrey);
        break;
      case 1:
        progress = SpinKitCircle(color: Colors.blueGrey);
        break;
      case 2:
        progress = SpinKitCubeGrid(color: Colors.blueGrey);
        break;
      case 3:
        progress = SpinKitDancingSquare(color: Colors.blueGrey);
        break;
      case 4:
        progress = SpinKitDoubleBounce(color: Colors.blueGrey);
        break;
      case 5:
        progress = SpinKitDualRing(color: Colors.blueGrey);
        break;
      case 6:
        progress = SpinKitFadingCircle(color: Colors.blueGrey);
        break;
      case 7:
        progress = SpinKitFadingCube(color: Colors.blueGrey);
        break;
      case 8:
        progress = SpinKitFadingFour(color: Colors.blueGrey);
        break;
      case 9:
        progress = SpinKitFadingGrid(color: Colors.blueGrey);
        break;
      case 10:
        progress = SpinKitFoldingCube(color: Colors.blueGrey);
        break;
      case 11:
        progress = SpinKitHourGlass(color: Colors.blueGrey);
        break;
      case 12:
        progress = SpinKitPianoWave(color: Colors.blueGrey);
        break;
      case 13:
        progress = SpinKitPouringHourGlass(color: Colors.blueGrey);
        break;
      case 14:
        progress = SpinKitPouringHourGlassRefined(color: Colors.blueGrey);
        break;
      case 15:
        progress = SpinKitPulse(color: Colors.blueGrey);
        break;
      case 16:
        progress = SpinKitPumpingHeart(color: Colors.blueGrey);
        break;
      case 17:
        progress = SpinKitRing(color: Colors.blueGrey);
        break;
      case 18:
        progress = SpinKitRipple(color: Colors.blueGrey);
        break;
      case 19:
        progress = SpinKitRotatingCircle(color: Colors.blueGrey);
        break;
      case 20:
        progress = SpinKitRotatingPlain(color: Colors.blueGrey);
        break;
      case 21:
        progress = SpinKitSpinningCircle(color: Colors.blueGrey);
        break;
      case 22:
        progress = SpinKitSpinningLines(color: Colors.blueGrey);
        break;
      case 23:
        progress = SpinKitSquareCircle(color: Colors.blueGrey);
        break;
      case 24:
        progress = SpinKitThreeBounce(color: Colors.blueGrey);
        break;
      case 25:
        progress = SpinKitThreeInOut(color: Colors.blueGrey);
        break;
      case 26:
        progress = SpinKitWanderingCubes(color: Colors.blueGrey);
        break;
      case 27:
        progress = SpinKitWave(color: Colors.blueGrey);
        break;
      default:
        progress = CircularProgressIndicator();
    }

    return Container(
      child: Center(
        child: Directionality(
          child: progress,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
