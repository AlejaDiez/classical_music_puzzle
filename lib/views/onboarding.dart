import 'dart:math';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/game.dart';
import '../views/game.dart';
import '../widgets/button.dart';

class OnboardingView extends StatefulWidget {
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with TickerProviderStateMixin {
  late final PageController _pageController;
  Duration _animationDuration = Duration.zero;
  double _page = 0.0;
  int _index0 = 2;
  int _index1 = 0;
  int _index2 = 1;
  int _index3 = 3;
  double _dragPosition = 0.0;
  double _oldDragPosition = 0.0;
  late final AnimationController _navigationBarAniamtionController, _initialAnimationController, _shakeAnimationController;
  late final Animation<double> _navigationBarOpacityAniamtion, _initialOpacityAnimation, _initialOpacityDelayAnimation, _initialScaleAnimation, _shakeAnimationStep1, _shakeAnimationStep2, _shakeAnimationStep3;
  late final Animation<Offset> _navigationMobileBarOffsetAniamtion, _navigationDesktopBarOffsetAniamtion, _initialPositionAnimation;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0)..addListener(() => setState(() => _page = _pageController.page ??0.0));
    _navigationBarAniamtionController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))..forward();
    _navigationBarOpacityAniamtion = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _navigationBarAniamtionController, curve: Curves.decelerate));
    _navigationMobileBarOffsetAniamtion = Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _navigationBarAniamtionController, curve: Curves.decelerate));
    _navigationDesktopBarOffsetAniamtion = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _navigationBarAniamtionController, curve: Curves.decelerate));
    _initialAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600))..forward();
    _initialOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Curves.decelerate));
    _initialOpacityDelayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Interval(0.5, 1.0, curve: Curves.decelerate)));
    _initialScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Curves.decelerate));
    _initialPositionAnimation = Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _initialAnimationController, curve: Interval(0.5, 1.0, curve: Curves.decelerate)));
    _shakeAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat();
    _shakeAnimationStep1 = Tween<double>(begin: 0.0, end: -(pi / 50)).animate(CurvedAnimation(parent: _shakeAnimationController, curve: const Interval(0.0, 0.15, curve: Curves.easeIn)));
    _shakeAnimationStep2 = Tween<double>(begin: -(pi / 50), end: pi / 50).animate(CurvedAnimation(parent: _shakeAnimationController, curve: const Interval(0.15, 0.45, curve: Curves.easeOut)));
    _shakeAnimationStep3 = Tween<double>(begin: pi / 50, end: 0.0).animate(CurvedAnimation(parent: _shakeAnimationController, curve: const Interval(0.45, 0.60, curve: Curves.easeIn)));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navigationBarAniamtionController.dispose();
    _initialAnimationController.dispose();
    _shakeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      padding: MediaQuery.of(context).padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double _slideObjectSize = (constraints.maxWidth <= 768.0) ?constraints.maxHeight * 0.12 :(constraints.maxWidth * 0.12 < constraints.maxHeight * 0.12) ?constraints.maxWidth * 0.12 :constraints.maxHeight * 0.12;
          return Stack(
            fit: StackFit.expand,
            children: [
              PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                scrollDirection: (constraints.maxWidth <= 768.0) ?Axis.horizontal :Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: (constraints.maxWidth <= 768.0) ?Axis.vertical :Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _initialAnimationController, 
                          builder: (_, Widget? child) => FadeTransition(
                            opacity: _initialOpacityAnimation,
                            child: ScaleTransition(
                              scale: _initialScaleAnimation,
                              alignment: (constraints.maxWidth <= 768.0) ?Alignment.center :Alignment.centerRight,
                              child: child!
                            )
                          ),
                          child: Opacity(
                            opacity: lerpDouble(1.0, 0.0, _page.clamp(0.0, 1.0))!,
                            child: Transform.scale(
                              scale: lerpDouble(1.0, 0.0, _page.clamp(0.0, 1.0))!,
                              alignment: (constraints.maxWidth <= 768.0) ?Alignment.center :Alignment.centerRight,
                              child: _SlideObjectDemoWidget(
                                size: 200.0,
                                margin: EdgeInsets.all(200.0 * 4 * 0.008),
                                borderRadius: BorderRadius.circular(200.0 * 4 * 0.012)
                              )
                            )
                          )
                        ),
                        SizedBox(height: 80.0, width: 80.0),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: AnimatedBuilder(
                            animation: _initialAnimationController, 
                            builder: (_, Widget? child) => FadeTransition(
                              opacity: (constraints.maxWidth <= 768.0) ?_initialOpacityDelayAnimation :_initialOpacityAnimation,
                              child: ScaleTransition(
                                scale: _initialScaleAnimation,
                                alignment: (constraints.maxWidth <= 768.0) ?Alignment.center :Alignment.centerLeft,
                                child: (constraints.maxWidth <= 768.0)
                                  ?SlideTransition(
                                    position: _initialPositionAnimation,
                                    child: child!
                                  )
                                  :child!
                              )
                            ),
                            child: Opacity(
                              opacity: lerpDouble(1.0, 0.0, _page.clamp(0.0, 1.0))!,
                              child: Transform.scale(
                                scale: lerpDouble(1.0, 0.0, _page.clamp(0.0, 1.0))!,
                                alignment: (constraints.maxWidth <= 768.0) ?Alignment.center :Alignment.centerLeft,
                                child: Transform.translate(
                                  offset: (constraints.maxWidth <= 768.0) ?Offset(0.0, lerpDouble(0, MediaQuery.of(context).size.height * 0.05, _page.clamp(0.0, 1.0))!) :Offset(0.0, 0.0),
                                  child: RichText(
                                    textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start,
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(height: 1.16),
                                      children: [
                                        TextSpan(text: "Classical Music"),
                                        TextSpan(
                                          text: "\nPuzzle",
                                          style: TextStyle(foreground: Paint()..style = PaintingStyle.stroke ..strokeWidth = 2 ..color = Theme.of(context).hintColor)
                                        )
                                      ]
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Opacity(
                        opacity: lerpDouble(0.0, 1.0, _page.clamp(0.0, 1.0) - (_page.clamp(1.0, 2.0) - 1.0))!,
                        child: Transform.scale(
                          scale: lerpDouble(0.5, 1.0, _page.clamp(0.0, 1.0) - (_page.clamp(1.0, 2.0) - 1.0))!,
                          alignment: Alignment.center,
                          child: Transform.translate(
                            offset: Offset(0.0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, _page.clamp(0.0, 1.0) - (_page.clamp(1.0, 2.0) - 1.0))!),
                            child: Text(AppLocalizations.of(context)!.howToPlay, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center)
                          )
                        )
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: (constraints.maxWidth <= 768.0) ?Axis.vertical :Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: (constraints.maxWidth <= 768.0) ?CrossAxisAlignment.center :CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: (_page.clamp(1.0, 2.0) - 1.0) - (_page.clamp(2.0, 3.0) - 2.0),
                              child: Transform.translate(
                                offset: Offset(0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, (_page.clamp(1.0, 2.0) - 1.0) - (_page.clamp(2.0, 3.0) - 2.0))!),
                                child: Text(AppLocalizations.of(context)!.singleTap, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            ),
                            SizedBox(height: 20.0),
                            Opacity(
                              opacity: ((_page.clamp(1.5, 2.0) - 1.5) * 2) - ((_page.clamp(2.0, 2.5) - 2.0) * 2),
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: (constraints.maxWidth <= 768.0) ?null :constraints.maxWidth * 0.5),
                                child: Text(AppLocalizations.of(context)!.singleTapText, style: Theme.of(context).textTheme.bodyMedium, textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            )
                          ]
                        ),
                        Expanded(child: SizedBox()),
                        Opacity(
                          opacity: ((_page.clamp(1.5, 2.0) - 1.5) * 2) - ((_page.clamp(2.0, 2.5) - 2.0) * 2),
                          child: Container(
                            padding: EdgeInsets.all((_slideObjectSize * 4) * 0.006),
                            height: (4 * _slideObjectSize) + (2 * _slideObjectSize * 4 * 0.006),
                            width: _slideObjectSize + (2 * _slideObjectSize * 4 * 0.006),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(((_slideObjectSize * 4) * 0.006 * 2) + ((_slideObjectSize * 4) * 0.012)),
                              color: Theme.of(context).hintColor.withOpacity(0.1)
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: _animationDuration,
                                  curve: Curves.decelerate,
                                  top: _slideObjectSize * _index1,
                                  onEnd: () => _animationDuration = Duration.zero,
                                  child: _SlideObjectDemoWidget(
                                    size: _slideObjectSize,
                                    onTap: () {
                                      gameProvider.playEffect(AudioEffect.move, audio: true, vibrate: true);
                                      _animationDuration = Duration(milliseconds: 200);
                                      setState(() {
                                        switch(_index0) {
                                          case 0:
                                            _index0 = 1;
                                            _index1 = 0;
                                            break;
                                          case 1:
                                            _index0 = 0;
                                            _index1 = 1;
                                            break;
                                          case 2:
                                            _index0 = 0;
                                            _index1 = 1;
                                            _index2 = 2;
                                            break;
                                          case 3:
                                            _index0 = 0;
                                            _index1 = 1;
                                            _index2 = 2;
                                            _index3 = 3;
                                            break;
                                        }
                                      });
                                    }
                                  )
                                ),
                                AnimatedPositioned(
                                  duration: _animationDuration,
                                  curve: Curves.decelerate,
                                  top: _slideObjectSize * _index2,
                                  onEnd: () => _animationDuration = Duration.zero,
                                  child: _SlideObjectDemoWidget(
                                    size: _slideObjectSize,
                                    onTap: () {
                                      gameProvider.playEffect(AudioEffect.move, audio: true, vibrate: true);
                                      _animationDuration = Duration(milliseconds: 200);
                                      setState(() {
                                        switch(_index0) {
                                          case 0:
                                            _index0 = 2; 
                                            _index1 = 0;
                                            _index2 = 1;
                                            break;
                                          case 1:
                                            _index0 = 2;
                                            _index2 = 1;
                                            break;
                                          case 2:
                                            _index0 = 1;
                                            _index2 = 2;
                                            break;
                                          case 3:
                                            _index0 = 1;
                                            _index2 = 2;
                                            _index3 = 3;
                                            break;
                                        }
                                      });
                                    }
                                  )
                                ),
                                AnimatedPositioned(
                                  duration: _animationDuration,
                                  curve: Curves.decelerate,
                                  top: _slideObjectSize * _index3,
                                  onEnd: () => _animationDuration = Duration.zero,
                                  child: _SlideObjectDemoWidget(
                                    size: _slideObjectSize,
                                    onTap: () {
                                      gameProvider.playEffect(AudioEffect.move, audio: true, vibrate: true);
                                      _animationDuration = Duration(milliseconds: 200);
                                      setState(() {
                                        switch(_index0) {
                                          case 0:
                                            _index0 = 3; 
                                            _index1 = 0;
                                            _index2 = 1;
                                            _index3 = 2;
                                            break;
                                          case 1:
                                            _index0 = 3; 
                                            _index2 = 1;
                                            _index3 = 2;
                                            break;
                                          case 2:
                                            _index0 = 3; 
                                            _index3 = 2;
                                            break;
                                          case 3:
                                            _index0 = 2; 
                                            _index3 = 3;
                                            break;
                                        }
                                      });
                                    }  
                                  )
                                )
                              ]
                            )
                          )
                        ),
                        Visibility(
                          visible: constraints.maxWidth <= 768.0,
                          child: Expanded(child: SizedBox()),
                        ),
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: (constraints.maxWidth <= 768.0) ?Axis.vertical :Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: (constraints.maxWidth <= 768.0) ?CrossAxisAlignment.center :CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: (_page.clamp(2.0, 3.0) - 2.0) - (_page.clamp(3.0, 4.0) - 3.0),
                              child: Transform.translate(
                                offset: Offset(0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, (_page.clamp(2.0, 3.0) - 2.0) - (_page.clamp(3.0, 4.0) - 3.0))!),
                                child: Text(AppLocalizations.of(context)!.drag, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            ),
                            SizedBox(height: 20.0),
                            Opacity(
                              opacity: ((_page.clamp(2.5, 3.0) - 2.5) * 2) - ((_page.clamp(3.0, 3.5) - 3.0) * 2),
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: (constraints.maxWidth <= 768.0) ?null :constraints.maxWidth * 0.5),
                                child: Text(AppLocalizations.of(context)!.dragText, style: Theme.of(context).textTheme.bodyMedium, textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            )
                          ]
                        ),
                        Expanded(child: SizedBox()),
                        Opacity(
                          opacity: ((_page.clamp(2.5, 3.0) - 2.5) * 2) - ((_page.clamp(3.0, 3.5) - 3.0) * 2),
                          child: Container(
                            padding: EdgeInsets.all((_slideObjectSize * 4) * 0.006),
                            height: (2 * _slideObjectSize) + (2 * _slideObjectSize * 4 * 0.006),
                            width: _slideObjectSize + (2 * _slideObjectSize * 4 * 0.006),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(((_slideObjectSize * 4) * 0.006 * 2) + ((_slideObjectSize * 4) * 0.012)),
                              color: Theme.of(context).hintColor.withOpacity(0.1)
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: _animationDuration,
                                  curve: Curves.decelerate,
                                  top: _dragPosition,
                                  onEnd: () => _animationDuration = Duration.zero,
                                  child: _SlideObjectDemoWidget(
                                    size: _slideObjectSize,
                                    onMove: (DragUpdateDetails dragUpdateDetails) => setState(() {
                                      _animationDuration = Duration.zero;
                                      _dragPosition += dragUpdateDetails.delta.dy;
                                      _dragPosition = _dragPosition.clamp(0.0, constraints.maxHeight * 0.12);
                                    }),
                                    onMoveEnd: () => setState(() {
                                      _animationDuration = Duration(milliseconds: 200);
                                      if((_oldDragPosition == 0 && _dragPosition < (constraints.maxHeight * 0.12 / 3))) {
                                        _dragPosition = 0;
                                      } else if(_oldDragPosition != 0 && _dragPosition > (2 * constraints.maxHeight * 0.12 / 3)) {
                                        _dragPosition = constraints.maxHeight * 0.12;
                                      } else if(_oldDragPosition == 0 && _dragPosition > (constraints.maxHeight * 0.12 / 3)) {
                                        gameProvider.playEffect(AudioEffect.move, audio: true, vibrate: true);
                                        _dragPosition = constraints.maxHeight * 0.12;
                                      } else if(_oldDragPosition != 0 && _dragPosition < (2 * constraints.maxHeight * 0.12 / 3)) {
                                        gameProvider.playEffect(AudioEffect.move, audio: true, vibrate: true);
                                        _dragPosition = 0;
                                      }
                                      _oldDragPosition = _dragPosition;
                                    })
                                  )
                                )
                              ]
                            )
                          )
                        ),
                        Visibility(
                          visible: constraints.maxWidth <= 768.0,
                          child: Expanded(child: SizedBox()),
                        ),
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: (constraints.maxWidth <= 768.0) ?Axis.vertical :Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: (constraints.maxWidth <= 768.0) ?CrossAxisAlignment.center :CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: (_page.clamp(3.0, 4.0) - 3.0) - (_page.clamp(4.0, 5.0) - 4.0),
                              child: Transform.translate(
                                offset: Offset(0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, (_page.clamp(3.0, 4.0) - 3.0) - (_page.clamp(4.0, 5.0) - 4.0))!),
                                child: Text(AppLocalizations.of(context)!.longPress, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            ),
                            SizedBox(height: 20.0),
                            Opacity(
                              opacity: ((_page.clamp(3.5, 4.0) - 3.5) * 2) - ((_page.clamp(4.0, 4.5) - 4.0) * 2),
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: (constraints.maxWidth <= 768.0) ?null :constraints.maxWidth * 0.5),
                                child: Text(AppLocalizations.of(context)!.longPressText, style: Theme.of(context).textTheme.bodyMedium, textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            )
                          ]
                        ),
                        Expanded(child: SizedBox()),
                        Opacity(
                          opacity: ((_page.clamp(3.5, 4.0) - 3.5) * 2) - ((_page.clamp(4.0, 4.5) - 4.0) * 2),
                          child: Container(
                            padding: EdgeInsets.all((_slideObjectSize * 4) * 0.006),
                            height: _slideObjectSize + (2 * _slideObjectSize * 4 * 0.006),
                            width: _slideObjectSize + (2 * _slideObjectSize * 4 * 0.006),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(((_slideObjectSize * 4) * 0.006 * 2) + ((_slideObjectSize * 4) * 0.012)),
                              color: Theme.of(context).hintColor.withOpacity(0.1)
                            ),
                            child: _SlideObjectDemoWidget(
                              size: _slideObjectSize,
                              canLongPress: true
                            )
                          )
                        ),
                        Visibility(
                          visible: constraints.maxWidth <= 768.0,
                          child: Expanded(child: SizedBox()),
                        ),
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Flex(
                      direction: (constraints.maxWidth <= 768.0) ?Axis.vertical :Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: (constraints.maxWidth <= 768.0) ?CrossAxisAlignment.center :CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: (_page.clamp(4.0, 5.0) - 4.0) - (_page.clamp(5.0, 6.0) - 5.0),
                              child: Transform.translate(
                                offset: Offset(0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, (_page.clamp(4.0, 5.0) - 4.0) - (_page.clamp(5.0, 6.0) - 5.0))!),
                                child: Text(AppLocalizations.of(context)!.shake, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            ),
                            SizedBox(height: 20.0),
                            Opacity(
                              opacity: ((_page.clamp(4.5, 5.0) - 4.5) * 2) - ((_page.clamp(5.0, 5.5) - 5.0) * 2),
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: (constraints.maxWidth <= 768.0) ?null :constraints.maxWidth * 0.5),
                                child: Text(AppLocalizations.of(context)!.shakeText, style: Theme.of(context).textTheme.bodyMedium, textAlign: (constraints.maxWidth <= 768.0) ?TextAlign.center :TextAlign.start)
                              )
                            )
                          ]
                        ),
                        Expanded(child: SizedBox()),
                        Opacity(
                          opacity: ((_page.clamp(4.5, 5.0) - 4.5) * 2) - ((_page.clamp(5.0, 5.5) - 5.0) * 2),
                          child: AnimatedBuilder(
                            animation: _shakeAnimationController,
                            builder: (BuildContext context, Widget? child) {
                              final Animation<double> _shakeAnimation = (_shakeAnimationStep1.value != -(pi / 50))
                                    ?_shakeAnimationStep1
                                    :(_shakeAnimationStep2.value != (pi / 50))
                                      ?_shakeAnimationStep2
                                      :_shakeAnimationStep3;

                              return Transform.rotate(
                                angle: _shakeAnimation.value + (pi / 10),
                                child: child!
                              );
                            },
                            child: SvgPicture.asset("assets/icons/mobile.svg", color: Theme.of(context).hintColor, height: _slideObjectSize, width: _slideObjectSize)
                          )
                        ),
                        Visibility(
                          visible: constraints.maxWidth <= 768.0,
                          child: Expanded(child: SizedBox()),
                        ),
                        Visibility(
                          visible: constraints.maxWidth > 768.0,
                          child: SizedBox(width: constraints.maxWidth * 0.15)
                        )
                      ]
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: (_page.clamp(5.0, 6.0) - 5.0) - (_page.clamp(6.0, 7.0) - 6.0),
                          child: Transform.translate(
                            offset: Offset(0, lerpDouble(MediaQuery.of(context).size.height * 0.05, 0, (_page.clamp(5.0, 6.0) - 5.0) - (_page.clamp(6.0, 7.0) - 6.0))!),
                            child: Text(AppLocalizations.of(context)!.play, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center)
                          )
                        ),
                        SizedBox(height: 60.0),
                        Opacity(
                          opacity: (_page.clamp(5.0, 6.0) - 5.0) - (_page.clamp(6.0, 7.0) - 6.0),
                          child: Transform.scale(
                            scale: lerpDouble(0.0, 1.0, (_page.clamp(5.0, 6.0) - 5.0) - (_page.clamp(6.0, 7.0) - 6.0)),
                            alignment: Alignment.center,
                            child: ButtonWidget(
                              height: null,
                              boxShape: BoxShape.circle,
                              effect: TapEffect.audio,
                              padding: EdgeInsets.all(30.0),
                              child: SvgPicture.asset("assets/icons/next.svg", height: 30.0, width: 30.0, color: Theme.of(context).hintColor),
                              onPressed: () {
                                gameProvider.sharedPreferences.setBool("is first", false);
                                Navigator.of(context).pushReplacement(PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 400),
                                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget page) => FadeTransition(
                                    opacity: animation,
                                    child: page
                                  ),
                                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => GameView()
                                ));
                              }
                            )
                          )
                        )
                      ]
                    )
                  )
                ]
              ),
              Align(
                alignment: (constraints.maxWidth <= 768.0) ?Alignment.bottomCenter :Alignment.centerRight,
                child: AnimatedBuilder(
                  animation: _navigationBarAniamtionController,
                  builder: (_, Widget? child) => FadeTransition(
                    opacity: _navigationBarOpacityAniamtion,
                    child: SlideTransition(
                      position: (constraints.maxWidth <= 768.0) ?_navigationMobileBarOffsetAniamtion :_navigationDesktopBarOffsetAniamtion,
                      child: child
                    )
                  ),
                  child: Container(
                    height: (constraints.maxWidth <= 768.0) ?14.0 :MediaQuery.of(context).size.height,
                    width: (constraints.maxWidth <= 768.0) ?MediaQuery.of(context).size.width :14.0,
                    padding: EdgeInsets.only(
                      top: (constraints.maxWidth <= 768.0) ?0.0 :(_page * ((MediaQuery.of(context).size.height - 40.0) / 7)) + 20.0,
                      right: (constraints.maxWidth <= 768.0) ?((6 - _page) * ((MediaQuery.of(context).size.width - 40.0) / 7)) + 20.0 :10.0,
                      bottom: (constraints.maxWidth <= 768.0) ?10.0 :((6 - _page) * ((MediaQuery.of(context).size.height - 40.0) / 7)) + 20.0,
                      left: (constraints.maxWidth <= 768.0) ?(_page * ((MediaQuery.of(context).size.width - 40.0) / 7)) + 20.0 :0.0
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(100.0)
                      )
                    )
                  )
                )
              )
            ]
          );
        }
      )
    );
  }
}


class _SlideObjectDemoWidget extends StatefulWidget {
  final double size;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Function()? onTap;
  final Function(DragUpdateDetails)? onMove;
  final Function()? onMoveEnd;
  final bool canLongPress;

  _SlideObjectDemoWidget({
    this.size = 100.0,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.onMove,
    this.onMoveEnd,
    this.canLongPress = false
  });

  @override
  State<_SlideObjectDemoWidget> createState() => __SlideObjectDemoWidgetState();
}

class __SlideObjectDemoWidgetState extends State<_SlideObjectDemoWidget> with TickerProviderStateMixin {
  late final AnimationController _scaleAnimationController, _jiggleAnimationController, _scaleAudioAnimationController;
  late final Animation<double> _scaleAnimation, _jiggleAnimationStep1, _jiggleAnimationStep2, _jiggleAnimationStep3, _scaleAnimationStep1, _scaleAnimationStep2, _scaleAnimationStep3;
  late final AssetsAudioPlayer _audioPlayer;
  GlobalKey _slideObjectKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Widget _overlayWidget(RenderBox renderBox) => Positioned(
    top: renderBox.localToGlobal(Offset.zero).dy - (widget.size / 2),
    left: renderBox.localToGlobal(Offset.zero).dx - (widget.size / 2),
    child: ConstrainedBox(
      constraints: BoxConstraints.tight(Size.square(widget.size * 2)),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
        onEnd: () {
          _overlayEntry!.remove();
          _overlayEntry = null;
        },
        builder: (BuildContext context, double animation, _) => Opacity(
          opacity: lerpDouble(1.0, 0.0, pow(animation, 2).toDouble())!,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 4),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/crotchet.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                left: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 6)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/crotchet_rest.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 16),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/f_clef.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 32, sqrt(animation)),
                left: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 10)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/minim.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 16, sqrt(animation)),
                right: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-pi),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/sharp.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                right: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(0),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/semibreve.svg", height: widget.size * 0.1, width: widget.size * 0.1, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                right: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 8),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/f_clef.svg", height: widget.size * 0.25, width: widget.size * 0.25, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                right: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 16)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/flat.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                right: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 32, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 8),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/quaver_rest.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                right: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 16, sqrt(animation)),
                bottom: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 3)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/natural.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                right: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                bottom: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(0),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/quaver.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                right: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                bottom: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 16),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/crotchet.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                right: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                bottom: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 12)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/g_clef.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                bottom: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 16, sqrt(animation)),
                left: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 4)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/flat.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                right: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                bottom: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 32, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 4),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/fermata.svg", height: widget.size * 0.15, width: widget.size * 0.15, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                bottom: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 12)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/g_clef.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                bottom: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                left: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 8),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/crotchet_rest.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                bottom: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 16), ((widget.size * 2) / 5), sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, 0, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 16),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/natural.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                bottom: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 32, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(pi / 9),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/minim.svg", height: widget.size * 0.3, width: widget.size * 0.3, color: Theme.of(context).hintColor))
                  )
                )
              ),
              Positioned(
                top: lerpDouble(((widget.size * 2) / 4) + ((widget.size * 2) / 8), ((widget.size * 2) / 4) + ((widget.size * 2) / 12), sqrt(animation)),
                left: lerpDouble((widget.size * 2) / 4, (widget.size * 2) / 16, sqrt(animation)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size.square(widget.size * 0.3)),
                  child: Transform(
                    transform: Matrix4.identity()..scale(lerpDouble(0.0, 1.0, sqrt(animation)))..rotateZ(-(pi / 6)),
                    alignment: Alignment.center,
                    child: Center(child: SvgPicture.asset("assets/icons/quaver_rest.svg", height: widget.size * 0.2, width: widget.size * 0.2, color: Theme.of(context).hintColor))
                  )
                )
              )
            ]
          )
        )
      )
    )
  );

  @override
  void initState() {
    _scaleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _scaleAnimationController, curve: Curves.decelerate));
    _jiggleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 260));
    _jiggleAnimationStep1 = Tween<double>(begin: 0.0, end: -0.008).animate(CurvedAnimation(parent: _jiggleAnimationController, curve: const Interval(0.0, 0.25, curve: Curves.easeIn)));
    _jiggleAnimationStep2 = Tween<double>(begin: -0.008, end: 0.013).animate(CurvedAnimation(parent: _jiggleAnimationController, curve: const Interval(0.25, 0.75, curve: Curves.easeOut)));
    _jiggleAnimationStep3 = Tween<double>(begin: 0.013, end: 0.0).animate(CurvedAnimation(parent: _jiggleAnimationController, curve: const Interval(0.75, 1.0, curve: Curves.easeIn)));
    _scaleAudioAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _scaleAnimationStep1 = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _scaleAudioAnimationController, curve: const Interval(0.0, 0.25, curve: Curves.easeIn)));
    _scaleAnimationStep2 = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _scaleAudioAnimationController, curve: const Interval(0.25, 0.75, curve: Curves.easeOut)));
    _scaleAnimationStep3 = Tween<double>(begin: 1.1, end: 1.0).animate(CurvedAnimation(parent: _scaleAudioAnimationController, curve: const Interval(0.75, 1.0, curve: Curves.easeIn)));
    _audioPlayer = AssetsAudioPlayer()..open(Audio("assets/sounds/onboarding.mp3"), autoStart: false, volume: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _jiggleAnimationController.dispose();
    _scaleAudioAnimationController.dispose();
    _overlayEntry?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return ConstrainedBox(
      key: _slideObjectKey,
      constraints: BoxConstraints.tightFor(height: widget.size, width: widget.size),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimationController, _jiggleAnimationController]),
        builder: (_, Widget? child) {
          final Animation<double> _jiggleAnimation = (_jiggleAnimationStep1.value != -0.008)
            ?_jiggleAnimationStep1
            :(_jiggleAnimationStep2.value != 0.013)
              ?_jiggleAnimationStep2
              :_jiggleAnimationStep3;
          return ScaleTransition(
            scale: _scaleAnimation,
            child: RotationTransition(
              turns: _jiggleAnimation,
              child: child!
            )
          );
        },
        child: MouseRegion(
          cursor: (widget.canLongPress ||  widget.onTap != null) ?SystemMouseCursors.click :(widget.onMove != null  && widget.onMoveEnd != null) ?SystemMouseCursors.grab :SystemMouseCursors.basic,
          child: GestureDetector(
            onTapUp: (_) => _scaleAnimationController.reverse(),
            onTap: widget.onTap,
            onLongPressDown: (_) {
              if(widget.canLongPress) _scaleAnimationController.forward();
            },
            onLongPressEnd: (_) => _scaleAnimationController.reverse(),
            onPanDown: (_) {
              if(widget.onTap != null || (widget.onMove != null && widget.onMoveEnd != null)) _scaleAnimationController.forward();
            },
            onPanStart: (_) {
              if(widget.onMove != null && widget.onMoveEnd != null) _jiggleAnimationController.repeat();
            },
            onLongPress: () {
              if(widget.canLongPress) {
                // Show animation
                if(_overlayEntry == null && !_audioPlayer.isPlaying.value) {
                  _overlayEntry = OverlayEntry(builder: (_) => _overlayWidget(_slideObjectKey.currentContext!.findRenderObject() as RenderBox));
                  Overlay.of(context)!.insert(_overlayEntry!);
                }

                // Play audio
                gameProvider.playEffect(null, audio: false, vibrate: true);
                if(_audioPlayer.isPlaying.value) _audioPlayer.stop();
                else _audioPlayer.seek(Duration.zero).then((_) => _audioPlayer.play());
              }
            },
            onPanUpdate: widget.onMove,
            onPanEnd: (_) {
              _scaleAnimationController.reverse();
              if(widget.onMoveEnd != null) {
                _jiggleAnimationController.animateTo(0);
                widget.onMoveEnd!();
              }
            },
            child: Container(
              margin: widget.margin ??EdgeInsets.all((widget.size * 4) * 0.006),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: widget.borderRadius ??BorderRadius.circular((widget.size * 4) * 0.012),
                boxShadow: [BoxShadow(
                  blurRadius: (widget.margin == null) ?EdgeInsets.all((widget.size * 4) * 0.006).horizontal :widget.margin!.horizontal,
                  spreadRadius: -(((widget.margin == null) ?EdgeInsets.all((widget.size * 4) * 0.006).horizontal :widget.margin!.horizontal) / 5),
                  color: Theme.of(context).shadowColor
                )]
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset("assets/icons/classical_music_puzzle.svg", color: Theme.of(context).hintColor, fit: BoxFit.contain),
                  Positioned(
                    top: widget.size * 0.05,
                    left: widget.size * 0.05,
                    child: StreamBuilder<bool?>(
                      stream: _audioPlayer.isPlaying,
                      builder: (_, AsyncSnapshot snapshot) {
                        if(snapshot.data ??false) _scaleAudioAnimationController.repeat();
                        else _scaleAudioAnimationController.stop();
                        return AnimatedOpacity(
                          opacity: (snapshot.data ??false) ?1.0 :0.0,
                          duration: Duration(milliseconds: 200),
                          child: AnimatedBuilder(
                            animation: _scaleAudioAnimationController,
                            builder: (_, Widget? child) {
                              final Animation<double> _scaleAnimation = (_scaleAnimationStep1.value != 0.9)
                                ?_scaleAnimationStep1
                                :(_scaleAnimationStep2.value != 1.1)
                                  ?_scaleAnimationStep2
                                  :_scaleAnimationStep3;
                              return ScaleTransition(
                                scale: _scaleAnimation,
                                child: child!
                              );
                            },
                            child: SvgPicture.asset("assets/icons/quaver.svg", height: widget.size * 0.1, width: widget.size * 0.1, color: (Theme.of(context).brightness == Brightness.light) ?Color.fromRGBO(220, 216, 208, 1.0) :Color.fromRGBO(50, 46, 47, 1.0)) 
                          )
                        );
                      }
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}