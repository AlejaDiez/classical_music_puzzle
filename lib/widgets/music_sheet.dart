import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/music_sheet.dart';
import '../providers/game.dart';
import '../providers/puzzle.dart';
import '../utils/time.dart';
import '../widgets/slide_object.dart';

class MusicSheetWidget extends StatefulWidget {
  final MusicSheet musicSheet;
  final double size;
  final Color backgroundColor;

  const MusicSheetWidget(this.musicSheet, {
    required this.size,
    this.backgroundColor = Colors.black
  });

  @override
  State<MusicSheetWidget> createState() => _MusicSheetWidgetState();
}

class _MusicSheetWidgetState extends State<MusicSheetWidget> with TickerProviderStateMixin {
  late final AnimationController _coverAnimationController;
  late final Animation<double> _coverAnimation;

  @override
  void initState() {
    _coverAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _coverAnimation = Tween<double>(begin: 0.0, end: pi).animate(CurvedAnimation(parent: _coverAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
    super.initState();
  }

  @override
  void dispose() {
    _coverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => PuzzleProvider(context, gameProvider: gameProvider, musicSheet: widget.musicSheet, puzzleStateChange: (PuzzleState puzzleState) {
        switch(puzzleState) {
          case PuzzleState.play:
            gameProvider.playEffect(AudioEffect.page, audio: true, vibrate: true);
            _coverAnimationController.forward();
            break;
          case PuzzleState.stop:
            gameProvider.playEffect(AudioEffect.closeBook, audio: true, vibrate: true);
            _coverAnimationController.reverse();
            break;
          case PuzzleState.complete:
            break;
        }
      }),
      builder: (BuildContext context, _) {
        late final PuzzleProvider _puzzleProvider = Provider.of<PuzzleProvider>(context);
        return Center(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _coverAnimationController,
                builder: (_, __) => Container(
                  height: widget.size,
                  width: 3 * widget.size / 4,
                  clipBehavior: Clip.antiAlias,
                  transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(-_coverAnimation.value),
                  transformAlignment: FractionalOffset.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.012) + (widget.size * 0.006 * 2) + (widget.size * 0.012))),
                    boxShadow: [BoxShadow(
                      blurRadius: widget.size * 0.2,
                      spreadRadius: -(widget.size * 0.2 / 5),
                      color: Color.fromRGBO(0, 0, 0, (_coverAnimation.value > pi / 2) ?0.2 :0.0)
                    )]
                  )
                )
              ),
              Container(
                height: widget.size,
                width: 3 * widget.size / 4,
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.only(
                  top: widget.size * 0.012,
                  right: widget.size * 0.012,
                  bottom: widget.size * 0.012
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.012) + (widget.size * 0.006 * 2) + (widget.size * 0.012))),
                  boxShadow: [BoxShadow(
                    blurRadius: widget.size * 0.2,
                    spreadRadius: -(widget.size * 0.2 / 5),
                    color: Color.fromRGBO(0, 0, 0, 0.2)
                  )]
                ),
                child: Container(
                  height: widget.size - (widget.size * 0.012 * 2),
                  width: (3 * widget.size / 4) - (widget.size * 0.012),
                  padding: EdgeInsets.only(
                    top: widget.size * 0.006,
                    right: widget.size * 0.006,
                    bottom: widget.size * 0.006,
                    left: (widget.size * 0.012) + (widget.size * 0.006)
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.012) + (widget.size * 0.006 * 2))),
                    boxShadow: [BoxShadow(
                      blurRadius: widget.size * 0.012,
                      spreadRadius: -(widget.size * 0.012 / 5),
                      color: Color.fromRGBO(0, 0, 0, 0.2)
                    )]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(widget.size * 0.006),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: SizedBox()),
                              Text(_puzzleProvider.musicSheet.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: widget.size * 0.056)),
                              SizedBox(height: widget.size * 0.026),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/icons/finger.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: widget.size * 0.026 * 0.8,  width: widget.size * 0.026 * 0.8),
                                        SizedBox(width: widget.size * 0.026 / 3),
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 200),
                                          switchInCurve: Curves.decelerate,
                                          switchOutCurve: Curves.decelerate,
                                          transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: animation,
                                              child: child
                                            )
                                          ),
                                          child: Text(_puzzleProvider.movements.toString(), style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: widget.size * 0.026), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false), key: ValueKey(_puzzleProvider.movements))
                                        )
                                      ]
                                    )
                                  ),
                                  SizedBox(width: widget.size * 0.026 * 1.6),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AnimatedRotation(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.decelerate,
                                          turns: _puzzleProvider.seconds / 60,
                                          child: SvgPicture.asset("assets/icons/clock.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: widget.size * 0.026 * 0.8,  width: widget.size * 0.026 * 0.8)
                                        ),
                                        SizedBox(width: widget.size * 0.026 / 3),
                                        Text(timeParse(_puzzleProvider.seconds), style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: widget.size * 0.026), textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
                                      ]
                                    )
                                  )
                                ]
                              ),
                              Expanded(child: SizedBox()),
                              Align(alignment: Alignment.centerRight, child: Text(_puzzleProvider.musicSheet.author, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: widget.size * 0.056 / 2)))
                            ]
                          )
                        )
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(Size.square((3 * widget.size / 4) - (widget.size * 0.012 * 2) - (widget.size * 0.006 * 2))),
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: List.generate(_puzzleProvider.musicSheet.items, (index) => SlideObjectWidget(
                            index: index,
                            size: ((3 * widget.size / 4) - (widget.size * 0.012 * 2) - (widget.size * 0.006 * 2)) / sqrt(_puzzleProvider.musicSheet.items + 1),
                            margin: EdgeInsets.all(widget.size * 0.006),
                            borderRadius: BorderRadius.circular(widget.size * 0.012)
                          ))
                        )
                      )
                    ]
                  )
                )
              ),
              AnimatedBuilder(
                animation: _coverAnimationController,
                builder: (_, Widget? child) => Container(
                  height: widget.size,
                  width: 3 * widget.size / 4,
                  clipBehavior: Clip.antiAlias,
                  transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(_coverAnimation.value),
                  transformAlignment: FractionalOffset.centerLeft,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.012) + (widget.size * 0.006 * 2) + (widget.size * 0.012)))
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => gameProvider.changeCurrentPuzzle(_puzzleProvider),
                    child: Visibility(
                      visible: _coverAnimation.value < pi / 2,
                      child: child!
                    )
                  )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_puzzleProvider.musicSheet.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: widget.size * 0.07, color: Color.fromRGBO(255, 255, 255, 1.0))),
                    Divider(
                      height: widget.size * 0.1,
                      thickness: widget.size * 0.002,
                      indent: widget.size * 0.34,
                      endIndent: widget.size * 0.34,
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                    ),
                    Text(_puzzleProvider.musicSheet.author, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: widget.size * 0.07 / 2, fontStyle: FontStyle.normal, color: Color.fromRGBO(255, 255, 255, 0.6)))
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}