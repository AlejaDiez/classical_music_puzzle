import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/game.dart';
import '../views/license.dart';
import '../widgets/button.dart';
import '../widgets/check_box.dart';
import '../widgets/dialog.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
          child: Text(AppLocalizations.of(context)!.settings, style: Theme.of(context).textTheme.headlineMedium!),
        ),
        ButtonWidget(
          alignment: Alignment.center,
          onPressed: () => gameProvider.easyMode = !gameProvider.easyMode,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: (gameProvider.easyMode) ?Text(AppLocalizations.of(context)!.hardMode, key: ValueKey("hard mode")) :Text(AppLocalizations.of(context)!.easyMode, key: ValueKey("easy mode")),
          )
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: gameProvider.vibrate != null,
              child: CheckBoxWidget(
                effect: TapEffect.none,
                value: gameProvider.vibrate ??false,
                onChanged: (bool value) {
                  gameProvider.vibrate = value;
                  gameProvider.playEffect(AudioEffect.tap, audio: false, vibrate: true);
                }
              )
            ),
            Visibility(
              visible: gameProvider.vibrate != null,
              child: Expanded(child: Center(child: SvgPicture.asset("assets/icons/vibrate.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor)))
            ),
            CheckBoxWidget(
              effect: TapEffect.none,
              value: gameProvider.audio,
              onChanged: (bool value) {
                gameProvider.audio = value;
                gameProvider.playEffect(AudioEffect.tap, audio: true, vibrate: false);
              }
            ),
            Expanded(child: Center(child: SvgPicture.asset("assets/icons/audio.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor))),
            Visibility(
              visible: gameProvider.vibrate == null,
              child: SizedBox(width: 20.0)
            ),
            CheckBoxWidget(
              value: gameProvider.shake,
              onChanged: (bool value) => gameProvider.shake = value
            ),
            Expanded(child: Center(child: Transform.rotate(
              angle: (pi / 6),
              child: SvgPicture.asset("assets/icons/mobile.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor)
            )))
          ]
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: ButtonWidget(
              height: null,
              padding: EdgeInsets.zero,
              onPressed: () => gameProvider.locale = Locale("es"),
              child: SvgPicture.asset("assets/icons/spanish.svg", fit: BoxFit.cover)
            )),
            SizedBox(width: 20.0),
            Expanded(child: ButtonWidget(
              height: null,
              padding: EdgeInsets.zero,
              onPressed: () => gameProvider.locale = Locale("en"),
              child: SvgPicture.asset("assets/icons/english.svg", fit: BoxFit.cover)
            ))
          ]
        ),
        SizedBox(height: 20.0),
        ButtonWidget(
          alignment: Alignment.center,
          onPressed: () => Navigator.push(context, DialogWidget(LicenseView(), canDismiss: false)),
          child: Text(AppLocalizations.of(context)!.licenses)
        )
      ]
    );
  }
}