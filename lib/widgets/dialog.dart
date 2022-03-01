import 'package:flutter/material.dart';

enum DialogType {popUp, slide}

class DialogWidget extends PageRouteBuilder {
  final DialogType dialogType;
  final bool canDismiss;
  final Widget child;

  DialogWidget({
    required this.dialogType,
    this.canDismiss = true,
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
              fit: BoxFit.contain,
              child: Container(
                width: 400.0,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(const Radius.circular(28.0))
                ),
                child: child
              )
            )
          );
        case DialogType.slide:
          return Align(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(top: const Radius.circular(28.0))
                ),
                child: child
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
          return SlideTransition(position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(animation), child: child);
      }
    }
  );
}