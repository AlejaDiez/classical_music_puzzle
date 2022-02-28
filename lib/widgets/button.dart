import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';

class ButtonWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final bool shadow;
  final TextStyle? style;
  final TapEffect effect;
  final Function()? onPressed;
  final Widget child;

  ButtonWidget({
    Key? key,
    this.height = 56.0,
    this.width,
    this.padding = const EdgeInsets.all(20.0),
    this.borderRadius = const BorderRadius.all(const Radius.circular(8.0)),
    this.alignment,
    this.backgroundColor,
    this.shadow = true,
    this.style,
    this.effect = TapEffect.audio,
    required this.onPressed,
    required this.child
  }) :super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> with TickerProviderStateMixin {
  late final AnimationController _pressedAnimationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    _pressedAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _pressedAnimationController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _pressedAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return MouseRegion(
      cursor: (widget.onPressed != null) ?SystemMouseCursors.click :SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (widget.onPressed != null) ?(_) => _pressedAnimationController.forward() :null,
        onTap: (widget.onPressed != null) 
          ?() {
            gameProvider.playEffect(AudioEffect.tap, audio: (widget.effect == TapEffect.audio || widget.effect == TapEffect.audioVibrate) ?true :false, vibrate: (widget.effect == TapEffect.vibrate || widget.effect == TapEffect.audioVibrate) ?true :false);
            widget.onPressed!();
          }
          :null,
        onTapUp: (widget.onPressed != null) ?(_) => _pressedAnimationController.reverse() :null,
        onTapCancel: (widget.onPressed != null) ?() => _pressedAnimationController.reverse() :null,
        child: AnimatedBuilder(
          animation: _pressedAnimationController,
          builder: (_, Widget? child) => ScaleTransition(
            scale: _scaleAnimation,
            child: child!
          ),
          child: Container(
            height: widget.height,
            width: widget.width,
            padding: widget.padding,
            clipBehavior: Clip.antiAlias,
            alignment: widget.alignment,
            decoration: BoxDecoration(
              color: widget.backgroundColor ??Theme.of(context).primaryColor,
              borderRadius: widget.borderRadius,
              boxShadow: (widget.shadow)
                ?[BoxShadow(
                  blurRadius: 20.0,
                  spreadRadius: -4.0,
                  color: Theme.of(context).shadowColor
                )]
                :null
            ),
            child: DefaultTextStyle(style: widget.style ??Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor, height: 1.0), child: widget.child)
          )
        )
      )
    );
  }
}