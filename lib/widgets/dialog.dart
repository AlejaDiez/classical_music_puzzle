import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'button.dart';

enum DialogType {popUp, slide}

class DialogWidget extends PageRouteBuilder {
  final DialogType dialogType;
  final bool canDismiss;
  final String? title;
  final Widget child;

  DialogWidget({
    required this.dialogType,
    this.canDismiss = true,
    this.title,
    required this.child
  }) : super(
    barrierDismissible: canDismiss,
    opaque: false,
    barrierColor: Color.fromRGBO(0, 0, 0, 0.8),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      switch(dialogType) {
        case DialogType.popUp:
          return Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Container(
                width: 400.0,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(const Radius.circular(28.0))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: title != null,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                        child: Text(title ??"", style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
                      )
                    ),
                    child
                  ]
                )
              )
            )
          );
        case DialogType.slide:
          return Align(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Container(
                height: (MediaQuery.of(context).size.height * 0.9) - MediaQuery.of(context).padding.top,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(top: const Radius.circular(28.0))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: title != null,
                            child: Text(title ??"", style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.left)
                          ),
                          Expanded(child: SizedBox()),
                          ButtonWidget(
                            height: 25.0,
                            width: 25.0,
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.zero,
                            shadow: false,
                            backgroundColor: Colors.transparent,
                            onPressed: () => Navigator.pop(context),
                            child: SvgPicture.asset("assets/icons/close.svg", height: 25.0, width: 25.0, color: Theme.of(context).hintColor)
                          )
                        ]
                      )
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: child
                    )
                  ]
                )
              )
            )
          );
      }
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      switch(dialogType) {
        case DialogType.popUp:
          return FadeTransition(opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation), child: SlideTransition(position: Tween<Offset>(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0)).animate(animation), child: child));
        case DialogType.slide:
          return SlideTransition(position: Tween<Offset>(begin: Offset(0.0, ((MediaQuery.of(context).size.height * 0.9) - MediaQuery.of(context).padding.top) / MediaQuery.of(context).size.height), end: Offset(0.0, 0.0)).animate(animation), child: child);
      }
    }
  );
}