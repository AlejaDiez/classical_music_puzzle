import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/game.dart';
import '../utils/time.dart';

class StatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
            child: Text(AppLocalizations.of(context)!.statistics, style: Theme.of(context).textTheme.headlineMedium)
          ),
          (gameProvider.statistics.isEmpty)
            ?Text(AppLocalizations.of(context)!.noData, style: Theme.of(context).textTheme.bodyMedium)
            :Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(gameProvider.statistics.length, (index) => Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text(gameProvider.statistics[index].split("|")[0], style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.fade, softWrap: false)),
                          SizedBox(width: 10.0),
                          SvgPicture.asset("assets/icons/finger.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: 12.0,  width: 12.0),
                          SizedBox(width: 4.0),
                          Text(gameProvider.statistics[index].split("|")[1], style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(width: 20.0),
                          Transform.rotate(
                            angle: (int.parse(gameProvider.statistics[index].split("|")[2]) / 60) * 2 * pi,
                            child: SvgPicture.asset("assets/icons/clock.svg", color: Theme.of(context).hintColor.withOpacity(0.6), height: 12.0,  width: 12.0)
                          ),
                          SizedBox(width: 4.0),
                          Text(timeParse(int.parse(gameProvider.statistics[index].split("|")[2])), style: Theme.of(context).textTheme.bodyMedium)
                        ]
                      ),
                      Visibility(
                        visible: index < gameProvider.statistics.length - 1,
                        child: Divider(
                          height: 40.0,
                          thickness: 2.0,
                          color: Theme.of(context).hintColor.withOpacity(0.06)
                        )
                      ),
                      Visibility(
                        visible: (index == gameProvider.statistics.length - 1) && (gameProvider.statistics.length > 1),
                        child: SizedBox(height: 20.0)
                      )
                    ]
                  ))
                )
              )
            )
        ]
      )
    );
  }
}