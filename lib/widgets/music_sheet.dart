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
  late final PuzzleProvider _puzzleProvider;
  late final AnimationController _coverAnimationController;
  late final Animation<double> _coverAnimation;

  @override
  void initState() {
    _puzzleProvider = PuzzleProvider(context, gameProvider: Provider.of<GameProvider>(context, listen: false), musicSheet: widget.musicSheet);
    _coverAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _coverAnimation = Tween<double>(begin: 0.0, end: pi).animate(CurvedAnimation(parent: _coverAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
    _puzzleProvider.addListener(() {
      if(_puzzleProvider.puzzleState == PuzzleState.play && _coverAnimationController.value == 0.0) {
        _coverAnimationController.forward();
        Provider.of<GameProvider>(context, listen: false).playEffect(AudioEffect.page, audio: true, vibrate: true);
      } else if(_puzzleProvider.puzzleState == PuzzleState.stop && _coverAnimationController.value == 1.0) {
        _coverAnimationController.reverse();
        Provider.of<GameProvider>(context, listen: false).playEffect(AudioEffect.closeBook, audio: true, vibrate: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _puzzleProvider.dispose();
    _coverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return ChangeNotifierProvider.value(
      value: _puzzleProvider,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: widget.size,
            width: 3 * widget.size / 4
          ),
          child: Consumer<PuzzleProvider>(
            builder: (_, PuzzleProvider puzzleProvider, __) => Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: widget.size,
                  width: 3 * widget.size / 4,
                  padding: EdgeInsets.only(
                    top: widget.size * 0.01,
                    right: widget.size * 0.01,
                    bottom: widget.size * 0.01
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.016) + (widget.size * 0.008 * 2) + (widget.size * 0.01))),
                    color: widget.backgroundColor
                  ),
                  child: Container(
                    height: widget.size - (widget.size * 0.01 * 2),
                    width: (3 * widget.size / 4) - (widget.size * 0.01),
                    padding: EdgeInsets.only(
                      top: widget.size * 0.008,
                      right: widget.size * 0.008,
                      bottom: widget.size * 0.008,
                      left: (widget.size * 0.01) + (widget.size * 0.008)
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.016) + (widget.size * 0.008 * 2))),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [BoxShadow(
                        blurRadius: widget.size * 0.01,
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
                            padding: EdgeInsets.only(
                              top: widget.size * 0.008,
                              right: widget.size * 0.008,
                              bottom: widget.size * 0.008 * 2,
                              left: widget.size * 0.008
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: SizedBox()),
                                Text(puzzleProvider.musicSheet.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: widget.size * 0.054)),
                                SizedBox(height: widget.size * 0.032),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/icons/finger.svg", height: widget.size * 0.026 * 0.75, width: widget.size * 0.026 * 0.75, color: Theme.of(context).hintColor.withOpacity(0.6)),
                                        SizedBox(width: widget.size * 0.008),
                                        AnimatedSize(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.decelerate,
                                          child: AnimatedSwitcher(
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
                                            child: Text(puzzleProvider.movements.toString(), style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: widget.size * 0.026), key: ValueKey<int>(puzzleProvider.movements))
                                          )
                                        )
                                      ]
                                    )),
                                    SizedBox(width: widget.size * 0.05),
                                    Flexible(child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AnimatedRotation(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.decelerate,
                                          turns: puzzleProvider.seconds / 60,
                                          child: SvgPicture.asset("assets/icons/clock.svg", height: widget.size * 0.026 * 0.75, width: widget.size * 0.026 * 0.75, color: Theme.of(context).hintColor.withOpacity(0.6))
                                        ),
                                        SizedBox(width: widget.size * 0.008),
                                        AnimatedSize(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.decelerate,
                                          alignment: Alignment.centerLeft,
                                          child: Text(timeParse(puzzleProvider.seconds), style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: widget.size * 0.026))
                                        )
                                      ]
                                    ))
                                  ]
                                ),
                                Expanded(child: SizedBox()),
                                Align(alignment: Alignment.centerRight, child: Text(puzzleProvider.musicSheet.author, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: widget.size * 0.054 * 0.5)))
                              ]
                            )
                          )
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tight(Size.square((3 * widget.size / 4) - (widget.size * 0.008 * 2) - (widget.size * 0.01 * 2))),
                          child: Stack(
                            fit: StackFit.expand,
                            children: List.generate(puzzleProvider.musicSheet.items, (index) => SlideObjectWidget(
                              index: index,
                              size: ((3 * widget.size / 4) - (widget.size * 0.008 * 2) - (widget.size * 0.01 * 2)) / sqrt(puzzleProvider.musicSheet.items + 1),
                              margin: EdgeInsets.all(widget.size * 0.008),
                              borderRadius: BorderRadius.circular(widget.size * 0.016)
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
                    transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(_coverAnimation.value),
                    transformAlignment: FractionalOffset.centerLeft,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular((widget.size * 0.016) + (widget.size * 0.008 * 2) + (widget.size * 0.01))),
                      color: widget.backgroundColor
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => gameProvider.changeCurrentPuzzle(puzzleProvider),
                      child: Visibility(
                        visible: _coverAnimation.value < pi / 2,
                        child: child!
                      )
                    )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(puzzleProvider.musicSheet.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: widget.size * 0.064, color: Color.fromRGBO(255, 255, 255, 1.0))),
                      Divider(
                        height: widget.size * 0.1,
                        thickness: widget.size * 0.002,
                        indent: widget.size * 0.32,
                        endIndent: widget.size * 0.32,
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                      ),
                      Text(puzzleProvider.musicSheet.author, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: widget.size * 0.064 * 0.5, fontStyle: FontStyle.normal, color: Color.fromRGBO(255, 255, 255, 0.6)))
                    ]
                  )
                )
              ]
            )  
          )
        )
      )
    );
  }
}