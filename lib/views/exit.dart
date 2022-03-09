import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/button.dart';

class ExitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
          child: Text(AppLocalizations.of(context)!.exitWarning, style: Theme.of(context).textTheme.headlineMedium!, textAlign: TextAlign.center),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: ButtonWidget(
                alignment: Alignment.center,
                shadow: false,
                borderRadius: BorderRadius.zero,
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.no)
              )
            ),
            Flexible(
              flex: 3,
              child: ButtonWidget(
                alignment: Alignment.center,
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.yes)
              )
            )
          ]
        )
      ]
    );
  }
}