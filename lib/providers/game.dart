import 'dart:ui';

import 'package:classical_music_puzzle/providers/puzzle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:vibration/vibration.dart';

import '../utils/audio_effects.dart';

enum TapEffect {none, audio, vibrate, audioVibrate}
enum AudioEffect {tap, move, shake, page, closeBook}

class GameProvider extends ChangeNotifier {
  GameProvider(this.sharedPreferences) {
    Vibration.hasVibrator().then((bool? value) {
      if(value == true) _vibrate = this.sharedPreferences.getBool('vibrate') ??true;
      else _vibrate = null;
    });
  }

  final SharedPreferences sharedPreferences;
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer()..setVolume(0.1);

  late Locale _locale = Locale(this.sharedPreferences.getString('locale') ??((window.locale.languageCode == 'es') ?"es" :"en"));
  late bool _audio = this.sharedPreferences.getBool('audio') ??true;
  late bool? _vibrate;
  late bool _easyMode = this.sharedPreferences.getBool('easy mode') ??true;
  late List<String> _statistics = this.sharedPreferences.getStringList('statistics') ??[];
  PuzzleProvider? _currentPuzzle;

  Locale get locale => this._locale;
  bool get audio => this._audio;
  bool? get vibrate => this._vibrate;
  bool get easyMode => this._easyMode;
  List<String> get statistics => this._statistics;
  PuzzleProvider? get currentPuzzle => this._currentPuzzle;

  set locale(Locale value) {
    if(value.languageCode == "es" || value.languageCode == "en") {
      this._locale = value;
      notifyListeners();
      sharedPreferences.setString("locale", value.languageCode);
    } else throw("It is only possible to change to Spanish or English.");
  }
  set audio(bool value) {
    this._audio = value;
    notifyListeners();
    sharedPreferences.setBool("audio", value);
  }
  set vibrate(bool? value) {
    this._vibrate = value;
    notifyListeners();
    sharedPreferences.setBool("vibrate", value!);
  }
  set easyMode(bool value) {
    this._easyMode = value;
    notifyListeners();
    sharedPreferences.setBool("easy mode", value);
  }
  void addStatistics(String value) {
    this._statistics.add(value);
    notifyListeners();
    sharedPreferences.setStringList("statistics", this._statistics);
  }
  void changeCurrentPuzzle(PuzzleProvider? value) {
    if(value != null) {
      this._currentPuzzle = value;
      this._currentPuzzle!.changePuzzleState(PuzzleState.play);
    } else if(value == null && _currentPuzzle != null) {
      this._currentPuzzle!.changePuzzleState(PuzzleState.stop);
      this._currentPuzzle = null;
    }
    notifyListeners();
  }

  // Play effect
  void playEffect(AudioEffect? effect, {bool audio = true, bool vibrate = true}) {
    if(audio && this._audio && effect != null) _audioPlayer.stop().then((_) => _audioPlayer.open(Audio(getAudioEffectPath(effect)), volume: 0.1, autoStart: true));
    if(vibrate && this._vibrate == true) Vibration.vibrate(duration: 50);
  }
}