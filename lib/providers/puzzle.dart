import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../models/music_sheet.dart';
import '../models/slide_object.dart';
import '../providers/game.dart';
import '../utils/is_solvable.dart';
import '../views/congratulations.dart';

enum PuzzleState {play, stop, complete}

class PuzzleProvider extends ChangeNotifier {
  PuzzleProvider(BuildContext context, {
    required GameProvider gameProvider,
    required this.musicSheet,
    required Function(PuzzleState) puzzleStateChange
  }) {
    _context = context;
    _gameProvider = gameProvider;
    _puzzleStateChange = puzzleStateChange;
    _shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
      if(_puzzleState == PuzzleState.play && gameProvider.shake) reset(effect: true);
    });
    _rawKeyboard = RawKeyboard.instance..addListener((RawKeyEvent rawKeyEvent) {
      if(_puzzleState == PuzzleState.play) {
        if(rawKeyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          for(SlideObject slideObject in _slideObjects) {
            if(slideObject.currentPoint.x == _emptyPoint.x && slideObject.currentPoint.y - 1 == _emptyPoint.y) {
              changeSlideObjectPoint(slideObject.index);
              break;
            } else continue;
          }
        } else if(rawKeyEvent.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          for(SlideObject slideObject in _slideObjects) {
            if(slideObject.currentPoint.y == _emptyPoint.y && slideObject.currentPoint.x + 1 == _emptyPoint.x) {
              changeSlideObjectPoint(slideObject.index);
              break;
            } else continue;
          }
        } else if(rawKeyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          for(SlideObject slideObject in _slideObjects) {
            if(slideObject.currentPoint.x == _emptyPoint.x && slideObject.currentPoint.y + 1 == _emptyPoint.y) {
              changeSlideObjectPoint(slideObject.index);
              break;
            } else continue;
          }
        } else if(rawKeyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          for(SlideObject slideObject in _slideObjects) {
            if(slideObject.currentPoint.y == _emptyPoint.y && slideObject.currentPoint.x - 1 == _emptyPoint.x) {
              changeSlideObjectPoint(slideObject.index);
              break;
            } else continue;
          }
        }
      }
    });
    _generateNewSolvableRandomPuzzle(false);
  }

  late final BuildContext _context;
  late final GameProvider _gameProvider;
  final MusicSheet musicSheet;

  // Generate a standard puzzle
  late Point _emptyPoint = Point(sqrt(musicSheet.items + 1).toInt() - 1, sqrt(musicSheet.items + 1).toInt() - 1);
  late List<SlideObject> _slideObjects = List.generate(musicSheet.items, (index) => SlideObject(
    index: index,
    correctPoint: Point((index % sqrt(musicSheet.items + 1)).toInt(), (index ~/ sqrt(musicSheet.items + 1)).toInt()),
    currentPoint: Point((index % sqrt(musicSheet.items + 1)).toInt(), (index ~/ sqrt(musicSheet.items + 1)).toInt()),
    image: musicSheet.images[index],
    audio: musicSheet.audios[index]
  ));

  Point get emptyPoint => _emptyPoint;
  List<SlideObject> get slideObjects => _slideObjects;

  // Variables
  PuzzleState _puzzleState = PuzzleState.stop;
  late final Function(PuzzleState) _puzzleStateChange;
  late final ShakeDetector _shakeDetector;
  late final RawKeyboard _rawKeyboard;
  int _movements = 0;
  int? _slideObjectMoving;
  late final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer()..setVolume(1.0)..isPlaying.listen((bool isPlaying) {
    if(isPlaying) _slideObjectPlaying = _lastSlideObjectPlaying;
    else _slideObjectPlaying = null;
    notifyListeners();
  });
  int _lastSlideObjectPlaying = 0;
  int? _slideObjectPlaying;
  Timer? _timer;
  int _seconds = 0;

  PuzzleState get puzzleState => _puzzleState;
  int get movements => _movements;
  int? get slideObjectMoving => _slideObjectMoving;
  int? get slideObjectPlaying => _slideObjectPlaying;
  int get seconds => _seconds;

  // Generate a new solvable puzzle
  void _generateNewSolvableRandomPuzzle(bool effect) {
    final Random _random = Random();
    List<int> _allPossiblePositions = List.generate(musicSheet.items + 1, (index) => index); // 0 is for empty point

    // Make random positions and check if is solvable
    do {
      _allPossiblePositions.shuffle(_random);
    } while(!isSolvable(_allPossiblePositions));

    for(int i = 0; i < _allPossiblePositions.length; i++) {
      if(_allPossiblePositions[i] == 0) { // Change empty point
        _emptyPoint = Point(i % sqrt(musicSheet.items + 1), i ~/ sqrt(musicSheet.items + 1));
      } else { // Change slide object point
        if(_slideObjects[_allPossiblePositions[i] - 1].currentPoint != Point(i % sqrt(musicSheet.items + 1), i ~/ sqrt(musicSheet.items + 1))) {
          _slideObjects[_allPossiblePositions[i] - 1].currentPoint = Point(i % sqrt(musicSheet.items + 1), i ~/ sqrt(musicSheet.items + 1));
          if(effect) _slideObjects[_allPossiblePositions[i] - 1].duration = Duration(milliseconds: 800);
        }
      }
    }
    notifyListeners();
  }

  // Change slide object current point and empty point
  void changeSlideObjectPoint(int index) {
    if(_puzzleState == PuzzleState.play) {
      if(_emptyPoint.x == _slideObjects[index].currentPoint.x || _emptyPoint.y == _slideObjects[index].currentPoint.y) { // Can move
        // Add timer if not started
        if(_timer == null) {
          _timer = Timer.periodic(Duration(seconds: 1), (_) {
            _seconds++;
            notifyListeners();
          });
        }

        // Save old current point
        Point _oldCurrentPoint = _slideObjects[index].currentPoint;

        // Play audio and vibrate
        _gameProvider.playEffect(AudioEffect.move);

        // Change current point
        _slideObjects.forEach((SlideObject slideObject) {
          if(slideObject.currentPoint.x == _slideObjects[index].currentPoint.x && (_emptyPoint.y > slideObject.currentPoint.y && _slideObjects[index].currentPoint.y <= slideObject.currentPoint.y)) { // Can move down
            slideObject.duration = Duration(milliseconds: 250);
            slideObject.currentPoint = Point(slideObject.currentPoint.x, slideObject.currentPoint.y + 1);
          } else if(slideObject.currentPoint.x == _slideObjects[index].currentPoint.x && (_emptyPoint.y < slideObject.currentPoint.y && _slideObjects[index].currentPoint.y >= slideObject.currentPoint.y)) { // Can move up
            slideObject.duration = Duration(milliseconds: 250);
            slideObject.currentPoint = Point(slideObject.currentPoint.x, slideObject.currentPoint.y - 1);
          } else if(slideObject.currentPoint.y == _slideObjects[index].currentPoint.y && (_emptyPoint.x < slideObject.currentPoint.x && _slideObjects[index].currentPoint.x >= slideObject.currentPoint.x)) { // Can move left
            slideObject.duration = Duration(milliseconds: 250);
            slideObject.currentPoint = Point(slideObject.currentPoint.x - 1, slideObject.currentPoint.y);
          } else if(slideObject.currentPoint.y == _slideObjects[index].currentPoint.y && (_emptyPoint.x > slideObject.currentPoint.x && _slideObjects[index].currentPoint.x <= slideObject.currentPoint.x)) { // Can move right
            slideObject.duration = Duration(milliseconds: 250);
            slideObject.currentPoint = Point(slideObject.currentPoint.x + 1, slideObject.currentPoint.y);
          }
        });

        // Change empty point
        _emptyPoint = _oldCurrentPoint;

        // Increase movements
        _movements++;
        notifyListeners();

        // Check if puzzle is complete
        _isComplete();
      }
    }
  }
  
  // Can slide
  void changeStateMovingSlideObject(int index) {
    if(_puzzleState == PuzzleState.play) {
      if((((_emptyPoint.y - _slideObjects[index].currentPoint.y).abs() == 1) && (_emptyPoint.x == _slideObjects[index].currentPoint.x)) || (((_emptyPoint.x - _slideObjects[index].currentPoint.x).abs() == 1) && (_emptyPoint.y == _slideObjects[index].currentPoint.y))) {
        if(_slideObjectMoving == index) {
          _slideObjects[index].duration = Duration(milliseconds: 250);
          _slideObjectMoving = null;
          notifyListeners();
        } else if(_slideObjectMoving == null) {
          _slideObjects[index].duration = Duration.zero;
          _slideObjectMoving = index;
          notifyListeners();
        }
      }
    }
  }

  // Play audio
  void playAudio(int index) {
    if(_slideObjectPlaying == null) {
      _gameProvider.playEffect(null, audio: false, vibrate: true);
      _audioPlayer.open(Audio(_slideObjects[index].audio), volume: 1.0, autoStart: true);
      _lastSlideObjectPlaying = index;
    } else if(_slideObjectPlaying == index) _audioPlayer.stop();
  }

  // Change puzzle state
  set puzzleState(PuzzleState value) {
    _puzzleState = value;
    if(_puzzleState == PuzzleState.play) {
      _movements = 0;
      _seconds = 0;
      _generateNewSolvableRandomPuzzle(false);
    } else {
      _slideObjectMoving = null;
      _audioPlayer.stop();
      _lastSlideObjectPlaying = 0;
      _slideObjectPlaying = null;
      _timer?.cancel();
      _timer = null;
    }
    _puzzleStateChange(_puzzleState);
    notifyListeners();
  }

  // Reset puzzle
  void reset({bool effect = false}) {
    // Reset variables
    _movements = 0;
    _slideObjectMoving = null;
    _audioPlayer.stop();
    _lastSlideObjectPlaying = 0;
    _slideObjectPlaying = null;
    _timer?.cancel();
    _timer = null;
    _seconds = 0;

    // Play effect
    if(effect) _gameProvider.playEffect(AudioEffect.shake, audio: true, vibrate: true);

    // Generate new puzzle
    _generateNewSolvableRandomPuzzle(effect);
  }

  // Is complete
  void _isComplete() {
    bool _correct = false;
    for(SlideObject slideObject in _slideObjects) {
      if(slideObject.correctPoint == slideObject.currentPoint) {
        _correct = true;
      } else {
        _correct = false;
        break;
      }
    }
    if(_correct) {
      _puzzleState = PuzzleState.complete;
      _slideObjectMoving = null;
      _audioPlayer.stop();
      _lastSlideObjectPlaying = 0;
      _slideObjectPlaying = null;
      _timer?.cancel();
      _timer = null;
      _gameProvider.addachievements(musicSheet.title + "|" + _movements.toString() + "|" + _seconds.toString());
      Navigator.of(_context).push(PageRouteBuilder(
        opaque: false,
        barrierColor: Color.fromRGBO(0, 0, 0, 0.8),
        transitionDuration: Duration(milliseconds: 400),
        fullscreenDialog: true,
        barrierDismissible: false,
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget page) => FadeTransition(opacity: animation, child: page),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => CongratulationsView(
          title: musicSheet.title,
          audio: slideObjects[0].audio,
          movements: _movements,
          seconds: _seconds
        )
      )).then((_) {
        _puzzleState = PuzzleState.play;
        reset(effect: true);
      });
    }
  }

  // Dispose
  @override
  void dispose() {
    _timer?.cancel();
    _shakeDetector.stopListening();
    _rawKeyboard.removeListener((RawKeyEvent rawKeyEvent) {});
    _audioPlayer.dispose();
    Future.microtask(() => super.dispose());
  }
}