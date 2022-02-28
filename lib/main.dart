import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './providers/game.dart';

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
      title: 'Classical Music Puzzle',
      home: Scaffold(
        appBar: AppBar(title: Text("Classical Music Puzzle")),
        body: Center(
          child: Container(
            child: Text('Hello World')
          )
        )
      ),
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
          headlineMedium: TextStyle(fontFamily: "OpenSans", fontSize: 30.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(108, 103, 94, 1.0), height: 1.0),
          bodyMedium: TextStyle(fontFamily: "OpenSans", fontSize: 16.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(108, 103, 94, 0.6))
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(18, 14, 14, 1.0),
        hintColor: Color.fromRGBO(255, 251, 242, 1.0),
        shadowColor: Color.fromRGBO(0, 0, 0, 1.0),
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontFamily: "OpenSans", fontSize: 30.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 251, 242, 1.0), height: 1.0),
          bodyMedium: TextStyle(fontFamily: "OpenSans", fontSize: 16.0, fontWeight: FontWeight.normal, color: Color.fromRGBO(255, 251, 242, 0.6))
        )
      )
    );
  }
}