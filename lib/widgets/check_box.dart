import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";


class CheckBoxWidget extends StatefulWidget {
  final double size;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final bool shadow;
  // final TapEffect effect;
  final bool value;
  final Function(bool)? onChanged;

  CheckBoxWidget({
    Key? key,
    this.size = 56.0,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8.0)),
    this.backgroundColor,
    this.shadow = true,
    // this.effect = TapEffect.audio,
    required this.value,
    required this.onChanged,
  }) :super(key: key);

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> with TickerProviderStateMixin {
  late final AnimationController _pressedAnimationController, _colorAnimationController;
  late final Animation<double> _scaleAnimation, _colorAnimation;
  
  @override
  void initState() {
    _pressedAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _pressedAnimationController, curve: Curves.decelerate));
    _colorAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _colorAnimationController, curve: Curves.linear));
    if(widget.value) _colorAnimationController.value = 1.0;
    else _colorAnimationController.value = 0.0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    if(widget.value) _colorAnimationController.forward();
    else _colorAnimationController.reverse();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pressedAnimationController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (widget.onChanged != null) ?SystemMouseCursors.click :SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (widget.onChanged != null) ?(_) => _pressedAnimationController.forward() :null,
        onTap: (widget.onChanged != null) 
          ?() {
            widget.onChanged!(!widget.value);
          }
          :null,
        onTapUp: (widget.onChanged != null) ?(_) => _pressedAnimationController.reverse() :null,
        onTapCancel: (widget.onChanged != null) ?() => _pressedAnimationController.reverse() :null,
        child: AnimatedBuilder(
          animation: _pressedAnimationController,
          builder: (_, Widget? child) => ScaleTransition(
            scale: _scaleAnimation,
            child: child!
          ),
          child: Container(
            height: widget.size,
            width: widget.size,
            padding: EdgeInsets.all(widget.size * 0.3),
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
            child: AnimatedBuilder(
              animation: _colorAnimationController,
              builder: (_, __) => SvgPicture.asset("assets/icons/check.svg", color: Color.lerp(Theme.of(context).hintColor.withOpacity(0.25), Color.fromRGBO(9, 188, 138, 1.0), _colorAnimation.value)
              )
            )
          )
        )
      )
    );
  }
}