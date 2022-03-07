import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './providers/game.dart';
import './views/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
    create: (_) => GameProvider(sharedPreferences),
    child: ClassicalMusicPuzzle()
  ));
}

class ClassicalMusicPuzzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classical Music Puzzle',
      home: GameView(),
      builder: (BuildContext context, Widget? home) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, 
          statusBarIconBrightness: (Theme.of(context).brightness == Brightness.light) ?Brightness.dark :Brightness.light,
          statusBarBrightness: Theme.of(context).brightness
        ));
        if(MediaQuery.of(context).size.shortestSide <= 768.0) SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        else SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft]);
        return home!;
      },
      locale: gameProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(255, 251, 242, 1.0),
        hintColor: Color.fromRGBO(108, 103, 94, 1.0),
        shadowColor: Color.fromRGBO(108, 103, 94, 0.2),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontFamily: "OpenSans", fontSize: 60.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 255, 255, 1.0), height: 1.0),
          headlineMedium: TextStyle(fontFamily: "OpenSans", fontSize: 34.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(108, 103, 94, 1.0), height: 1.0),
          titleLarge: TextStyle(fontFamily: "TimesNewRoman", fontSize: 32.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(108, 103, 94, 1.0), height: 1.0),
          titleMedium: TextStyle(fontFamily: "TimesNewRoman", fontSize: 16.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Color.fromRGBO(108, 103, 94, 1.0), height: 1.0),
          titleSmall: TextStyle(fontFamily: "TimesNewRoman", fontSize: 14.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(108, 103, 94, 0.6), height: 1.0),
          bodyMedium: TextStyle(fontFamily: "OpenSans", fontSize: 16.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(108, 103, 94, 0.6))
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(18, 14, 14, 1.0),
        hintColor: Color.fromRGBO(255, 251, 242, 1.0),
        shadowColor: Color.fromRGBO(0, 0, 0, 1.0),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontFamily: "OpenSans", fontSize: 60.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 255, 255, 1.0), height: 1.0),
          headlineMedium: TextStyle(fontFamily: "OpenSans", fontSize: 34.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(255, 251, 242, 1.0), height: 1.0),
          titleLarge: TextStyle(fontFamily: "TimesNewRoman", fontSize: 32.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 251, 242, 1.0), height: 1.0),
          titleMedium: TextStyle(fontFamily: "TimesNewRoman", fontSize: 16.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Color.fromRGBO(255, 251, 242, 1.0), height: 1.0),
          titleSmall: TextStyle(fontFamily: "TimesNewRoman", fontSize: 14.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(255, 251, 242, 0.6), height: 1.0),
          bodyMedium: TextStyle(fontFamily: "OpenSans", fontSize: 16.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(255, 251, 242, 0.6))
        )
      )
    );
  }
}