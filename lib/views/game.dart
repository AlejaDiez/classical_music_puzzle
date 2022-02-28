import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../views/settings.dart';
import '../views/statistics.dart';
import '../widgets/button.dart';
import '../widgets/dialog.dart';

class GameView extends StatefulWidget {
  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  late final AnimationController _backOpacityAnimationController, _backSlideAnimationController, _rotateAnimationController;
  late final Animation<double> _backOpacityAnimation, _rotateAnimation;
  late final Animation<Offset> _backSlideAnimation;

  @override
  void initState() {
    _backOpacityAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))..value = 1.0;
    _backOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _backOpacityAnimationController, curve: Curves.decelerate));
    _backSlideAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400))..value = 1.0;
    _backSlideAnimation = Tween<Offset>(begin: Offset(-0.4, 0.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _backSlideAnimationController, curve: Curves.decelerate));
    _rotateAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(CurvedAnimation(parent: _rotateAnimationController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _backOpacityAnimationController.dispose();
    _backSlideAnimationController.dispose();
    _rotateAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
                      shadow: false,
                      onPressed: () {
                        _backOpacityAnimationController.reverse();
                        _backSlideAnimationController.reverse();
                      },
                      child: SvgPicture.asset("assets/icons/back.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
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