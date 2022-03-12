import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:vibration/vibration.dart';

import '../providers/puzzle.dart';
import '../utils/audio_effects.dart';

enum TapEffect {none, audio, vibrate, audioVibrate}
enum AudioEffect {tap, move, shake, page, closeBook}

class GameProvider extends ChangeNotifier {
  GameProvider(this.sharedPreferences) {
    Vibration.hasVibrator().then((bool? value) {
      if(value == true) _vibrate = sharedPreferences.getBool('vibrate') ??true;
      else _vibrate = null;
    });
  }

  final SharedPreferences sharedPreferences;
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer()..setVolume(0.1);

  late Locale _locale = Locale(sharedPreferences.getString('locale') ??((window.locale.languageCode == 'es') ?"es" :"en"));
  late bool? _vibrate;
  late bool _audio = sharedPreferences.getBool('audio') ??true;
  late bool _shake = sharedPreferences.getBool('shake') ??true;
  late bool _easyMode = sharedPreferences.getBool('easy mode') ??true;
  late List<String> _achievements = sharedPreferences.getStringList('achievements') ??[];
  PuzzleProvider? _currentPuzzle;
  late Function(PuzzleProvider?) onCurrentPuzzleChange;

  Locale get locale => _locale;
  bool? get vibrate => _vibrate;
  bool get audio => _audio;
  bool get shake => _shake;
  bool get easyMode => _easyMode;
  List<String> get achievements => _achievements;
  PuzzleProvider? get currentPuzzle => _currentPuzzle;

  set locale(Locale value) {
    if(value.languageCode == "es" || value.languageCode == "en") {
      _locale = value;
      notifyListeners();
      sharedPreferences.setString("locale", value.languageCode);
    } else throw("It is only possible to change to Spanish or English.");
  }
  set vibrate(bool? value) {
    _vibrate = value;
    notifyListeners();
    sharedPreferences.setBool("vibrate", value!);
  }
  set audio(bool value) {
    _audio = value;
    notifyListeners();
    sharedPreferences.setBool("audio", value);
  }
  set shake(bool value) {
    _shake = value;
    notifyListeners();
    sharedPreferences.setBool("shake", value);
  }
  set easyMode(bool value) {
    _easyMode = value;
    notifyListeners();
    sharedPreferences.setBool("easy mode", value);
  }
  void addachievements(String value) {
    _achievements.add(value);
    notifyListeners();
    sharedPreferences.setStringList("achievements", _achievements);
  }
  void changeCurrentPuzzle(PuzzleProvider? value) {
    if(value != null) {
      _currentPuzzle = value;
      _currentPuzzle!.puzzleState = PuzzleState.play;
    } else if(value == null && _currentPuzzle != null) {
      _currentPuzzle!.puzzleState = PuzzleState.stop;
      _currentPuzzle = null;
    }
    onCurrentPuzzleChange(_currentPuzzle);
    notifyListeners();
  }

  // Play effect
  void playEffect(AudioEffect? effect, {bool audio = true, bool vibrate = true}) {
    if(audio && _audio && effect != null) _audioPlayer.stop().then((_) => _audioPlayer.open(Audio(getAudioEffectPath(effect)), volume: 0.1, autoStart: true));
    if(vibrate && _vibrate == true) Vibration.vibrate(duration: 20);
  }
}