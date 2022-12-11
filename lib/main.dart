import 'package:ez_localization/ez_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:techoffice/providers/AuthProvider.dart';
import 'package:techoffice/providers/DBProvider.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/SplashScreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:techoffice/utils/Notifications.dart';

import 'package:timeago/timeago.dart' as ago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DBProvider(),
        ),
      ],
      child: EzLocalizationBuilder(
          delegate: EzLocalizationDelegate(
            supportedLocales: [
              Locale('ar', ''),
            ],
          ),
          builder: (context, localizationDelegate) {
            return MaterialApp(
              darkTheme: ThemeData(
                fontFamily: 'cairo',
                brightness: Brightness.dark,
                accentColor: Colors.blueGrey,
              ),
              locale: Locale('ar', ''),
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'cairo',
                brightness: Brightness.light,
                primarySwatch: Colors.blueGrey,
              ),
              builder: EasyLoading.init(),
              localizationsDelegates:
                  localizationDelegate.localizationDelegates,
              supportedLocales: localizationDelegate.supportedLocales,
              localeResolutionCallback:
                  localizationDelegate.localeResolutionCallback,
              home: getHome(context),
            );
          }),
    );
  }

  getHome(context) {
    ago.setLocaleMessages('ar', ago.ArMessages());
    initNotifications(context);
    return WillPopScope(
      child: SplashScreen(),
      onWillPop: () async {
        return true;
      },
    );
  }
}
