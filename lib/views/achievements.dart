import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/game.dart';
import '../utils/time.dart';

class AchievementsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 450.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Text(AppLocalizations.of(context)!.achievements, style: Theme.of(context).textTheme.headlineMedium!),
          ),
          (gameProvider.achievements.isEmpty)
            ?Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0, left: 20.0),
              child: Text(AppLocalizations.of(context)!.noData, style: Theme.of(context).textTheme.bodyMedium)
            )
            :Flexible(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: gameProvider.achievements.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  right: 20.0,
                  bottom: 20.0,
                  left: 20.0
                ),
                itemBuilder: (_, int index) => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(gameProvider.achievements[index].split('|')[0], style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.fade, softWrap: false)),
                    SizedBox(width: Theme.of(context).textTheme.bodyMedium!.fontSize!),
                    SvgPicture.asset("assets/icons/finger.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 0.8,  width: Theme.of(context).textTheme.bodyMedium!.fontSize! * 0.8),
                    SizedBox(width: Theme.of(context).textTheme.bodyMedium!.fontSize! / 3),
                    Text(gameProvider.achievements[index].split('|')[1], style: Theme.of(context).textTheme.bodyMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false)),
                    SizedBox(width: Theme.of(context).textTheme.bodyMedium!.fontSize! * 2),
                    Transform.rotate(
                      angle: (int.parse(gameProvider.achievements[index].split('|')[2]) / 60) * 2 * pi,
                      child: SvgPicture.asset("assets/icons/clock.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 0.8,  width: Theme.of(context).textTheme.bodyMedium!.fontSize! * 0.8)
                    ),
                    SizedBox(width: Theme.of(context).textTheme.bodyMedium!.fontSize! / 3),
                    Text(timeParse(int.parse(gameProvider.achievements[index].split('|')[2])), style: Theme.of(context).textTheme.bodyMedium, textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false))
                  ]
                ),
                separatorBuilder: (_, __) => Divider(
                  height: 22.0,
                  thickness: 2.0,
                  color: Theme.of(context).hintColor.withOpacity(0.06)
                )
              )
            )
        ]
      )
    );
  }
}