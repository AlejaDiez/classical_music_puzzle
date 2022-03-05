import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/game.dart';
import '../utils/time.dart';
import '../widgets/button.dart';

class CongratulationsView extends StatefulWidget {
  final String title;
  final String audio;
  final int movements;
  final int seconds;

  const CongratulationsView({
    required this.title,
    required this.audio,
    required this.movements,
    required this.seconds
  });

  @override
  State<CongratulationsView> createState() => _CongratulationsViewState();
}

class _CongratulationsViewState extends State<CongratulationsView> with TickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  late final ConfettiController _confettiController;
  late final AssetsAudioPlayer _audioPlayer;
  late final AnimationController _animationController, _closeAnimationController;
  late final Animation<double> _scaleAnimation, _scaleCloseAnimation, _opacityCloseAnimation;
  late final Animation<Offset> _positionAnimation;
  
  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 2))..play();
    _audioPlayer = AssetsAudioPlayer()..setVolume(1.0)..open(Audio(widget.audio), autoStart: true, volume: 1.0);
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))..forward();
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));
    _positionAnimation = Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));
    _closeAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))..addListener(() {
      _audioPlayer.setVolume(lerpDouble(1.0, 0.0, _closeAnimationController.value)!);
      if(_closeAnimationController.isCompleted) Navigator.pop(context);
    });
    _scaleCloseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _closeAnimationController, curve: Curves.decelerate));
    _opacityCloseAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _closeAnimationController, curve: Interval(0.0, 0.25, curve: Curves.decelerate)));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    _animationController.dispose();
    _closeAnimationController.removeListener(() {});
    _closeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0.0, Theme.of(context).textTheme.headlineLarge!.fontSize! / 2),
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 400,
                  emissionFrequency: 0,
                  particleDrag: 0.02,
                  shouldLoop: false,
                  displayTarget: true,
                  colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow]
                )
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (_, Widget? child) => ScaleTransition(
                  scale: _scaleAnimation,
                  child: child!
                ),
                child: Text(widget.title, style: Theme.of(context).textTheme.headlineLarge)
              ),
              SizedBox(height: 20.0 * 2),
              AnimatedBuilder(
                animation: _animationController,
                builder: (_, Widget? child) => SlideTransition(
                  position: _positionAnimation,
                  child: child!
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/finger.svg", color: Color.fromRGBO(255, 255, 255, 1.0), height: 20.0 * 0.8,  width: 20.0 * 0.8),
                        SizedBox(width: 20.0 / 3),
                        Text(widget.movements.toString(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.0, color: Color.fromRGBO(255, 255, 255, 1.0)), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
                      ]
                    ),
                    SizedBox(width: 20.0 * 2),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: (widget.seconds / 60) * 2 * pi,
                          child: SvgPicture.asset("assets/icons/clock.svg", color: Color.fromRGBO(255, 255, 255, 1.0), height: 20.0 * 0.8,  width: 20.0 * 0.8)
                        ),
                        SizedBox(width: 20.0 / 3),
                        Text(timeParse(widget.seconds), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.0, color: Color.fromRGBO(255, 255, 255, 1.0)), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
                      ]
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0 * 4),
              AnimatedBuilder(
                animation: Listenable.merge([_animationController, _closeAnimationController]),
                builder: (_, Widget? child) {
                  final Animation<double> _scale = (_animationController.value != 1.0)
                    ?_scaleAnimation
                    :Tween<double>(begin: 1.0, end: (MediaQuery.of(context).size.longestSide) / ((_buttonKey.currentContext!.findRenderObject() as RenderBox).size.height / 2)).animate(_scaleCloseAnimation); 
                  return ScaleTransition(
                    scale: _scale,
                    child: ButtonWidget(
                      key: _buttonKey,
                      height: null,
                      boxShape: BoxShape.circle,
                      effect: TapEffect.none,
                      padding: EdgeInsets.all(25.0),
                      onPressed: () => _closeAnimationController.forward(),
                      child: FadeTransition(
                        opacity: _opacityCloseAnimation,
                        child: child!
                      )
                    )
                  );
                },
                child: SvgPicture.asset("assets/icons/reset.svg", height: 31.25, width: 31.25, color: Theme.of(context).hintColor)
              )
            ]
          )
        )
      )
    );
  }
}