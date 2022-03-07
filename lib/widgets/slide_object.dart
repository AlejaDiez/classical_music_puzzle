import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';
import '../providers/puzzle.dart';

class SlideObjectWidget extends StatefulWidget {
  final int index;
  final double size;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  SlideObjectWidget({
    required this.index,
    required this.size,
    required this.margin,
    required this.borderRadius
  });

  @override
  State<SlideObjectWidget> createState() => _SlideObjectWidgetState();
}

class _SlideObjectWidgetState extends State<SlideObjectWidget> with TickerProviderStateMixin {
  late final AnimationController _scaleAnimationController, _jiggleAnimationController, _scaleAudioAnimationController;
  late final Animation<double> _scaleAnimation, _jiggleAnimationStep1, _jiggleAnimationStep2, _jiggleAnimationStep3, _scaleAnimationStep1, _scaleAnimationStep2, _scaleAnimationStep3;
  double _dragPositionX = 0.0;
  double _dragPositionY = 0.0;
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
    super.initState();
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _jiggleAnimationController.dispose();
    _scaleAudioAnimationController.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    final PuzzleProvider _puzzleProvider = Provider.of<PuzzleProvider>(context);
    return AnimatedPositioned(
      duration: _puzzleProvider.slideObjects[widget.index].duration,
      curve: Curves.easeOutQuad,
      onEnd: () => _puzzleProvider.slideObjects[widget.index].duration = Duration.zero,
      top: (widget.size * _puzzleProvider.slideObjects[widget.index].currentPoint.y) + _dragPositionY,
      left: (widget.size * _puzzleProvider.slideObjects[widget.index].currentPoint.x) + _dragPositionX,
      child: ConstrainedBox(
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
            cursor: (_puzzleProvider.slideObjectMoving == widget.index) ?SystemMouseCursors.grabbing :(_puzzleProvider.slideObjectPlaying != widget.index && _puzzleProvider.slideObjectPlaying != null && !((_puzzleProvider.emptyPoint.x == _puzzleProvider.slideObjects[widget.index].currentPoint.x || _puzzleProvider.emptyPoint.y == _puzzleProvider.slideObjects[widget.index].currentPoint.y) || ((((_puzzleProvider.emptyPoint.y - _puzzleProvider.slideObjects[widget.index].currentPoint.y).abs() == 1) && (_puzzleProvider.emptyPoint.x == _puzzleProvider.slideObjects[widget.index].currentPoint.x)) || (((_puzzleProvider.emptyPoint.x - _puzzleProvider.slideObjects[widget.index].currentPoint.x).abs() == 1) && (_puzzleProvider.emptyPoint.y == _puzzleProvider.slideObjects[widget.index].currentPoint.y))))) ?SystemMouseCursors.forbidden :SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _puzzleProvider.changeSlideObjectPoint(widget.index),
              onPanDown: ((_puzzleProvider.emptyPoint.x == _puzzleProvider.slideObjects[widget.index].currentPoint.x || _puzzleProvider.emptyPoint.y == _puzzleProvider.slideObjects[widget.index].currentPoint.y) || ((((_puzzleProvider.emptyPoint.y - _puzzleProvider.slideObjects[widget.index].currentPoint.y).abs() == 1) && (_puzzleProvider.emptyPoint.x == _puzzleProvider.slideObjects[widget.index].currentPoint.x)) || (((_puzzleProvider.emptyPoint.x - _puzzleProvider.slideObjects[widget.index].currentPoint.x).abs() == 1) && (_puzzleProvider.emptyPoint.y == _puzzleProvider.slideObjects[widget.index].currentPoint.y)))) ?(_) => _scaleAnimationController.forward() :null,
              onPanStart: (_) {
                _puzzleProvider.changeStateMovingSlideObject(widget.index);
                if(_puzzleProvider.slideObjectMoving == widget.index) _jiggleAnimationController.repeat();
              },
              onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                if(_puzzleProvider.slideObjectMoving == widget.index) {
                  if(_puzzleProvider.slideObjects[widget.index].currentPoint.x == _puzzleProvider.emptyPoint.x) { // Can move vertically
                    _dragPositionY += dragUpdateDetails.delta.dy;
                    if(_puzzleProvider.slideObjects[widget.index].currentPoint.y - _puzzleProvider.emptyPoint.y < 0) { // Move down
                      setState(() => _dragPositionY = _dragPositionY.clamp(0.0, widget.size));
                    } else { // Move up
                      setState(() => _dragPositionY = _dragPositionY.clamp(-widget.size, 0.0));
                    }
                  } else { // Can move horizontally
                    _dragPositionX += dragUpdateDetails.delta.dx;
                    if(_puzzleProvider.slideObjects[widget.index].currentPoint.x - _puzzleProvider.emptyPoint.x < 0) { // Move right
                      setState(() => _dragPositionX = _dragPositionX.clamp(0.0, widget.size));
                    } else { // Move left
                      setState(() => _dragPositionX = _dragPositionX.clamp(-widget.size, 0.0));
                    }
                  }
                }
              },
              onPanCancel: () => _scaleAnimationController.reverse(),
              onPanEnd: (_) {
                _scaleAnimationController.reverse();
                if(_puzzleProvider.slideObjectMoving == widget.index) {
                  _jiggleAnimationController.animateTo(0);
                  if((_dragPositionY > widget.size / 3 || _dragPositionY < -widget.size / 3) || (_dragPositionX > widget.size / 3 || _dragPositionX < -widget.size / 3)) _puzzleProvider.changeSlideObjectPoint(widget.index);
                  setState(() {               
                    _dragPositionX = 0.0;
                    _dragPositionY = 0.0;
                  });
                  _puzzleProvider.changeStateMovingSlideObject(widget.index);
                }
              },
              onLongPressDown: (_puzzleProvider.slideObjectPlaying == null || _puzzleProvider.slideObjectPlaying == widget.index) ?(_) => _scaleAnimationController.forward() :null,
              onLongPress: () {
                _puzzleProvider.playAudio(widget.index);
                if(_overlayEntry == null && _puzzleProvider.slideObjectPlaying == null) {
                  _overlayEntry = OverlayEntry(builder: (_) => _overlayWidget(_slideObjectKey.currentContext!.findRenderObject() as RenderBox));
                  Overlay.of(context)!.insert(_overlayEntry!);
                }
              },
              child: Container(
                margin: widget.margin,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: widget.borderRadius,
                  boxShadow: [BoxShadow(
                    blurRadius: widget.margin.horizontal,
                    spreadRadius: -(widget.margin.horizontal / 5),
                    color: Theme.of(context).shadowColor
                  )]
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(_puzzleProvider.slideObjects[widget.index].image, color: Theme.of(context).hintColor, fit: BoxFit.contain),
                    Positioned(
                      top: widget.size * 0.05,
                      left: widget.size * 0.05,
                      child: AnimatedOpacity(
                        opacity: _puzzleProvider.slideObjectPlaying == widget.index ?1.0 :0.0,
                        duration: Duration(milliseconds: 200),
                        onEnd: () {
                          if(_puzzleProvider.slideObjectPlaying == widget.index) _scaleAudioAnimationController.repeat();
                          else _scaleAudioAnimationController.stop();
                        },
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
                      )
                    ),
                    Positioned(
                      top: widget.size * 0.04,
                      right: widget.size * 0.04,
                      child: AnimatedOpacity(
                        opacity: gameProvider.easyMode ?1.0 :0.0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        child: Text((widget.index + 1).toString(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: widget.size * 0.12, fontWeight: FontWeight.bold, color: (Theme.of(context).brightness == Brightness.light) ?Color.fromRGBO(220, 216, 208, 1.0) :Color.fromRGBO(50, 46, 47, 1.0), height: 1.0))
                      )
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}