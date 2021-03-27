import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
//screens
import './screen/home.dart';
//providers
import './providers/main_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MainProvider(),
        )
      ],
      child: FutureBuilder(
        // Replace the 3 second delay with your initialization code:
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            // Loading is done, return the app:
            return MaterialApp(
              home: NeumorphicApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                themeMode: ThemeMode.light,
                theme: NeumorphicThemeData(
                  baseColor: Color(0xFFFFFFFF),
                  lightSource: LightSource.topLeft,
                  depth: 10,
                  appBarTheme: NeumorphicAppBarThemeData(
                    // color: Colors.black45,
                    centerTitle: true,
                  ),
                ),
                darkTheme: NeumorphicThemeData(
                  baseColor: Color(0xFF3E3E3E),
                  lightSource: LightSource.topLeft,
                  depth: 6,
                ),
                home: HomePage(),
              ),
            );
          }
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: Center(
              child: Image.asset(
                'assets/images/splashlogo.png',
                width: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
