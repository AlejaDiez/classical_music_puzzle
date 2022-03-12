import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/button.dart';

class LicenseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 550.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.licenses, style: Theme.of(context).textTheme.headlineMedium!),
                ButtonWidget(
                  height: null,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.zero,
                  backgroundColor: Colors.transparent,
                  onPressed: () => Navigator.pop(context),
                  child: SvgPicture.asset("assets/icons/close.svg", color: Theme.of(context).hintColor, height: 25.0, width: 25.0)
                )
              ]
            )
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Classical Music Puzzle ",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor.withOpacity(0.8))
                        ),
                        TextSpan(text: "by Alejandro Diez Bermejo is licensed under a "),
                        TextSpan(
                          text: "Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License",
                          style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                          mouseCursor: SystemMouseCursors.click,
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            if (!await launch("https://creativecommons.org/licenses/by-nc-sa/4.0/")) throw "Could not launch.";
                          }
                        ),
                        TextSpan(text: ".")
                      ]
                    )
                  ),
                  SizedBox(height: 20.0),
                  Text("Icons and Images", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Icons: Created by "),
                          TextSpan(
                            text: "Freepik",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://www.freepik.com/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Flaticon",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://www.flaticon.com/uicons/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Music Sheet: I do with Illustrator and I use music notes of "),
                          TextSpan(
                            text: "rawpixel.com (Freepik)",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://www.freepik.com/rawpixel-com")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  ),
                  SizedBox(height: 20.0),
                  Text("Sounds", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Sound Effects: obtained from "),
                          TextSpan(
                            text: "Zapsplat",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://www.zapsplat.com/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Onboarding music it's mine.", style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Symphony No. 40: recorded by "),
                          TextSpan(
                            text: "Musopen Symphony",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://musopen.org/music/performer/musopen-symphony/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Symphony No. 5: recorded by "),
                          TextSpan(
                            text: "Fulda Symphonic Orchesta",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://musopen.org/music/performer/fulda-symphonic-orchesta/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  ),
                  SizedBox(height: 20.0),
                  Text("Fonts", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(text: "Fonts: obtained from "),
                          TextSpan(
                            text: "Google Fonts",
                            style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(8, 69, 148, 0.6)),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              if (!await launch("https://fonts.google.com/")) throw "Could not launch.";
                            }
                          ),
                          TextSpan(text: ".")
                        ]
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}