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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
          child: Text(AppLocalizations.of(context)!.settings, style: Theme.of(context).textTheme.headlineLarge)
        ),
        ButtonWidget(
          alignment: Alignment.center,
          onPressed: () => gameProvider.easyMode = !gameProvider.easyMode,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchInCurve: Curves.decelerate,
            switchOutCurve: Curves.decelerate,
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
              opacity: animation,
              child: child
            ),
            child: Text((gameProvider.easyMode) ?AppLocalizations.of(context)!.hardMode :AppLocalizations.of(context)!.easyMode, key: ValueKey<bool>(!gameProvider.easyMode))
          )
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: (400.0 - (56.0 * 2) - 60.0) / 2),
                child: Center(child: SvgPicture.asset("assets/icons/vibrate.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor))
              )
            ),
            Visibility(
              visible: gameProvider.vibrate != null,
              child: SizedBox(width: 20.0)
            ),
            CheckBoxWidget(
              effect: TapEffect.none,
              value: gameProvider.audio,
              onChanged: (bool value) {
                gameProvider.audio = value;
                gameProvider.playEffect(AudioEffect.tap, audio: true, vibrate: false);
              }
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: (400.0 - (56.0 * 2) - 60.0) / 2),
              child: Center(child: SvgPicture.asset("assets/icons/audio.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor))
            )
          ]
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonWidget(
              width: (400.0 - 60.0) / 2,
              padding: EdgeInsets.zero,
              onPressed: () => gameProvider.locale = Locale("es"),
              child: SvgPicture.asset("assets/icons/spanish.svg", fit: BoxFit.cover)
            ),
            SizedBox(width: 20.0),
            ButtonWidget(
              width: (400.0 - 60.0) / 2,
              padding: EdgeInsets.zero,
              onPressed: () => gameProvider.locale = Locale("en"),
              child: SvgPicture.asset("assets/icons/english.svg", fit: BoxFit.cover)
            )
          ]
        ),
        SizedBox(height: 20.0),
        ButtonWidget(
          alignment: Alignment.center,
          onPressed: () => Navigator.push(context, DialogWidget(dialogType: DialogType.slide, child: LicenseView(), canDismiss: false)),
          child: Text(AppLocalizations.of(context)!.licenses)
        )
      ]
    );
  }
}