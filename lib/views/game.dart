import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';
import '../views/settings.dart';
import '../views/statistics.dart';
import '../widgets/button.dart';
import '../widgets/dialog.dart';

class GameView extends StatefulWidget {
  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  late final AnimationController _backOpacityAnimationController, _backSlideAnimationController, _resetOpacityAnimationController, _resetRotateAnimationController, _rotateAnimationController;
  late final Animation<double> _backOpacityAnimation, _resetOpacityAnimation, _resetRotateAnimation, _rotateAnimation;
  late final Animation<Offset> _backSlideAnimation;

  @override
  void initState() {
    _backOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _backOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _backOpacityAnimationController, curve: Curves.decelerate));
    _backSlideAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _backSlideAnimation = Tween<Offset>(begin: Offset(-0.3, 0.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _backSlideAnimationController, curve: Curves.decelerate));
    _resetOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resetOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _resetOpacityAnimationController, curve: Curves.decelerate));
    _resetRotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resetRotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(CurvedAnimation(parent: _resetRotateAnimationController, curve: Curves.decelerate));
    _rotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(CurvedAnimation(parent: _rotateAnimationController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _backOpacityAnimationController.dispose();
    _backSlideAnimationController.dispose();
    _resetOpacityAnimationController.dispose();
    _resetRotateAnimationController.dispose();
    _rotateAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    if(gameProvider.currentPuzzle == null && _backOpacityAnimationController.isCompleted && _backSlideAnimationController.isCompleted && _resetOpacityAnimationController.isCompleted) {
      _backOpacityAnimationController.reverse();
      _backSlideAnimationController.reverse();
      _resetOpacityAnimationController.reverse();
    } else if(gameProvider.currentPuzzle != null && _backOpacityAnimationController.value == 0.0 && _backSlideAnimationController.value == 0.0 && _resetOpacityAnimationController.value == 0.0) {
      _backOpacityAnimationController.forward();
      _backSlideAnimationController.value = 1.0;
      _resetOpacityAnimationController.forward();
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              late double _size;
              if(constraints.maxWidth <= 768.0) {
                if(constraints.maxHeight * 0.9 >= 4 * constraints.maxWidth / 3) _size = 4 * constraints.maxWidth / 3;
                else _size = constraints.maxHeight * 0.9;
              } else {
                if(constraints.maxWidth * 0.9 >= 3 * (constraints.maxHeight * 0.9) / 4) _size = constraints.maxHeight * 0.9;
                else _size = constraints.maxWidth * 0.9;
              }
              return PageView(
                physics: BouncingScrollPhysics(),
                children: []
              );
            }
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: 65.0,
                width: MediaQuery.of(context).size.width
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: Listenable.merge([_backOpacityAnimationController, _backSlideAnimationController]),
                    builder: (_, Widget? child) => Visibility(
                      visible: _backOpacityAnimation.value != 0.0,
                      child: FadeTransition(
                        opacity: _backOpacityAnimation,
                        child: SlideTransition(
                          position: _backSlideAnimation,
                          child: child!
                        )
                      )
                    ),
                    child: ButtonWidget(
                      height: null,
                      width: null,
                      padding: const EdgeInsets.all(20.0),
                      borderRadius: BorderRadius.zero,
                      backgroundColor: Colors.transparent,
                      effect: TapEffect.none,
                      shadow: false,
                      onPressed: () => gameProvider.changeCurrentPuzzle(null),
                      child: SvgPicture.asset("assets/icons/back.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                    )
                  ),
                  AnimatedBuilder(
                    animation: Listenable.merge([_resetOpacityAnimationController, _resetRotateAnimationController]),
                    builder: (_, Widget? child) => Visibility(
                      visible: _backOpacityAnimation.value != 0.0,
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
                      width: null,
                      padding: const EdgeInsets.all(20.0),
                      borderRadius: BorderRadius.zero,
                      backgroundColor: Colors.transparent,
                      effect: TapEffect.none,
                      shadow: false,
                      onPressed: () {
                        gameProvider.currentPuzzle!.reset(effect: true);
                        _resetRotateAnimationController.forward().then((_) => _resetRotateAnimationController.reverse());
                      },
                      child: SvgPicture.asset("assets/icons/reset.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                    )
                  ),
                  Expanded(child: SizedBox()),
                  ButtonWidget(
                    height: null,
                    width: null,
                    padding: const EdgeInsets.all(20.0),
                    borderRadius: BorderRadius.zero,
                    backgroundColor: Colors.transparent,
                    shadow: false,
                    onPressed: () => Navigator.push(context, DialogWidget(dialogType: DialogType.popUp, child: StatisticsView())).whenComplete(() => _rotateAnimationController.reverse()),
                    child: SvgPicture.asset("assets/icons/statistics.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                  ),
                  AnimatedBuilder(
                    animation: _rotateAnimationController,
                    builder: (_, Widget? child) => RotationTransition(
                      turns: _rotateAnimation,
                      child: child!
                    ),
                    child: ButtonWidget(
                      height: null,
                      width: null,
                      padding: const EdgeInsets.all(20.0),
                      borderRadius: BorderRadius.zero,
                      backgroundColor: Colors.transparent,
                      shadow: false,
                      onPressed: () {
                        _rotateAnimationController.forward();
                        Navigator.push(context, DialogWidget(dialogType: DialogType.popUp, child: SettingsView())).whenComplete(() => _rotateAnimationController.reverse());
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