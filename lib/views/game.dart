import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../models/music_sheet.dart';
import '../providers/game.dart';
import '../providers/puzzle.dart';
import '../views/settings.dart';
import 'achievements.dart';
import '../widgets/button.dart';
import '../widgets/dialog.dart';
import '../widgets/music_sheet.dart';

class GameView extends StatefulWidget {
  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _navigationBarAniamtionController, _backOpacityAnimationController, _backSlideAnimationController, _resetOpacityAnimationController, _resetRotateAnimationController, _settingsAnimationController, _initialAnimationController;
  late final Animation<double> _navigationBarOpacityAniamtion, _backOpacityAnimation, _resetOpacityAnimation, _resetRotateAnimation, _settingsAnimation, _initialScaleAnimation, _initialAngleAnimation, _initialTranslationAnimation;
  late final Animation<Offset> _navigationBarOffsetAniamtion, _backOffsetAnimation;
  double _page = 0.0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0)..addListener(() => setState(() => _page = _pageController.page ??0.0));
    _navigationBarAniamtionController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _navigationBarOpacityAniamtion = Tween(begin: 1.0, end: 0.1).animate(CurvedAnimation(parent: _navigationBarAniamtionController, curve: Curves.decelerate));
    _navigationBarOffsetAniamtion = Tween(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.0)).animate(CurvedAnimation(parent: _navigationBarAniamtionController, curve: Curves.decelerate));
    _backOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _backOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _backOpacityAnimationController, curve: Curves.decelerate));
    _backSlideAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _backOffsetAnimation = Tween(begin: Offset(-0.5, 0.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _backSlideAnimationController, curve: Curves.decelerate));
    _resetOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resetOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _resetOpacityAnimationController, curve: Curves.decelerate));
    _resetRotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resetRotateAnimation = Tween(begin: 0.0, end: 0.25).animate(CurvedAnimation(parent: _resetRotateAnimationController, curve: Curves.decelerate));
    _settingsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _settingsAnimation = Tween(begin: 0.0, end: 0.25).animate(CurvedAnimation(parent: _settingsAnimationController, curve: Curves.decelerate));
    _initialAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800))..forward();
    _initialScaleAnimation = Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Curves.decelerate));
    _initialAngleAnimation = Tween(begin: 0.15, end: 0.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Curves.decelerate));
    _initialTranslationAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _initialAnimationController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();
    _navigationBarAniamtionController.dispose();
    _backOpacityAnimationController.dispose();
    _backSlideAnimationController.dispose();
    _resetOpacityAnimationController.dispose();
    _resetRotateAnimationController.dispose();
    _settingsAnimationController.dispose();
    _initialAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context)..onCurrentPuzzleChange = (PuzzleProvider? currentPuzzleProvider) {
      if(currentPuzzleProvider == null) {
        _navigationBarAniamtionController.reverse();
        _backOpacityAnimationController.reverse();
        _backSlideAnimationController.reverse();
        _resetOpacityAnimationController.reverse();
      } else {
        _navigationBarAniamtionController.forward();
        _backOpacityAnimationController.forward();
        _backSlideAnimationController.value = 1.0;
        _resetOpacityAnimationController.forward();
      }
    };
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _initialAnimationController,
            builder: (_, Widget? child) => Transform(
              transform: Matrix4.translationValues(_initialTranslationAnimation.value * MediaQuery.of(context).size.width, 0.0, 0.0)..scale(_initialScaleAnimation.value)..rotateZ(_initialAngleAnimation.value),
              alignment: Alignment.bottomCenter,
              child: child
            ),
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) {
                late double _size;
                if(constraints.maxWidth <= 768.0) {
                  if(constraints.maxHeight * 0.84 >= 4 * constraints.maxWidth / 3) _size = 4 * constraints.maxWidth / 3;
                  else _size = constraints.maxHeight * 0.84;
                } else {
                  if(constraints.maxWidth * 0.84 >= 3 * (constraints.maxHeight * 0.84) / 4) _size = constraints.maxHeight * 0.84;
                  else _size = constraints.maxWidth * 0.84;
                }
                return PageView(
                  controller: _pageController,
                  physics: (gameProvider.currentPuzzle == null) ?BouncingScrollPhysics() :NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  children: [
                    Transform(
                      transform: Matrix4.identity()..scale(lerpDouble(1.0, 0.6, _page.clamp(0.0, 1.0)))..rotateZ(lerpDouble(0.0, -0.16, _page.clamp(0.0, 1.0))!),
                      alignment: Alignment.bottomCenter,
                      child: MusicSheetWidget(
                        MusicSheet(
                          title: "Symphony No. 40",
                          author: "W. Amadeus Mozart",
                          items: 8,
                          imagePath: "assets/images/symphony_no_40_",
                          imageExtension: ".svg",
                          audioPath: "assets/sounds/symphony_no_40_",
                          audioExtension: ".mp3"
                        ),
                        size: _size,
                        backgroundColor: Color.fromRGBO(198, 40, 40, 1.0)
                      )
                    ),
                    Transform(
                      transform: Matrix4.identity()..scale(lerpDouble(0.6, 1.0, _page.clamp(0.0, 1.0))!)..rotateZ(lerpDouble(0.16, 0.0, _page.clamp(0.0, 1.0))!),
                      alignment: Alignment.bottomCenter,
                      child: MusicSheetWidget(
                        MusicSheet(
                          title: "Symphony No. 5",
                          author: "L. van Beethoven",
                          items: 15,
                          imagePath: "assets/images/symphony_no_5_",
                          imageExtension: ".svg",
                          audioPath: "assets/sounds/symphony_no_5_",
                          audioExtension: ".mp3"
                        ),
                        size: _size,
                        backgroundColor: Color.fromRGBO(83, 104, 120, 1.0)
                      )
                    )
                  ]
                );
              }
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _navigationBarAniamtionController,
              builder: (_, Widget? child) => FadeTransition(
                opacity: _navigationBarOpacityAniamtion,
                child: SlideTransition(
                  position: _navigationBarOffsetAniamtion,
                  child: child
                )
              ),
              child: Container(
                height: 14.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  right: ((1 - _page) * ((MediaQuery.of(context).size.width - 40.0) / 2)) + 20.0,
                  bottom: 10.0,
                  left: (_page * ((MediaQuery.of(context).size.width - 40.0) / 2)) + 20.0
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor,
                    borderRadius: BorderRadius.circular(100.0)
                  )
                )
              )
            )
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_backOpacityAnimationController, _backSlideAnimationController]),
                    builder: (_, Widget? child) => Visibility(
                      visible: _backOpacityAnimationController.value != 0.0,
                      child: FadeTransition(
                        opacity: _backOpacityAnimation,
                        child: SlideTransition(
                          position: _backOffsetAnimation,
                          child: child!
                        )
                      )
                    ),
                    child: ButtonWidget(
                      height: null,
                      padding: EdgeInsets.all(10.0),
                      borderRadius: BorderRadius.zero,
                      shadow: false,
                      effect: TapEffect.none,
                      backgroundColor: Colors.transparent,
                      onPressed: () => gameProvider.changeCurrentPuzzle(null),
                      child: SvgPicture.asset("assets/icons/back.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                    )
                  ),
                  SizedBox(width: 20.0),
                  AnimatedBuilder(
                    animation: Listenable.merge([_resetOpacityAnimationController, _resetRotateAnimationController]),
                    builder: (_, Widget? child) => Visibility(
                      visible: (_resetOpacityAnimationController.value != 0.0) && (!gameProvider.shake || MediaQuery.of(context).size.width >= 1024.0),
                      child: FadeTransition(
                        opacity: _resetOpacityAnimation,
                        child: RotationTransition(
                          turns: _resetRotateAnimation,
                          child: child!
                        )
                      )
                    ),
                    child: ButtonWidget(
                      height: null,
                      padding: EdgeInsets.all(10.0),
                      borderRadius: BorderRadius.zero,
                      shadow: false,
                      effect: TapEffect.none,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        gameProvider.currentPuzzle!.reset(effect: true);
                        _resetRotateAnimationController.forward().whenComplete(() => _resetRotateAnimationController.reverse());
                      },
                      child: SvgPicture.asset("assets/icons/reset.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                    )
                  ),
                  Expanded(child: SizedBox()),
                  ButtonWidget(
                    height: null,
                    padding: EdgeInsets.all(10.0),
                    borderRadius: BorderRadius.zero,
                    shadow: false,
                    backgroundColor: Colors.transparent,
                    onPressed: () => Navigator.push(context, DialogWidget(AchievementsView(), padding: EdgeInsets.zero)),
                    child: SvgPicture.asset("assets/icons/trophy.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                  ),
                  SizedBox(width: 20.0),
                  AnimatedBuilder(
                    animation: _settingsAnimationController,
                    builder: (_, Widget? child) => RotationTransition(
                      turns: _settingsAnimation,
                      child: child!
                    ),
                    child: ButtonWidget(
                      height: null,
                      padding: EdgeInsets.all(10.0),
                      borderRadius: BorderRadius.zero,
                      shadow: false,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        _settingsAnimationController.forward();
                        Navigator.push(context, DialogWidget(SettingsView())).whenComplete(() => _settingsAnimationController.reverse());
                      },
                      child: SvgPicture.asset("assets/icons/settings.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}