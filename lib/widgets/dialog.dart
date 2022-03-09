import 'package:flutter/material.dart';

class DialogWidget extends PageRouteBuilder {
  final Widget child;
  final bool canDismiss;
  final EdgeInsetsGeometry padding;

  DialogWidget(this.child, {
    this.canDismiss = true,
    this.padding = const EdgeInsets.all(20.0)
  }) : super(
    barrierDismissible: canDismiss,
    opaque: false,
    barrierColor: Color.fromRGBO(0, 0, 0, 0.8),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Align(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          width: 420.0,
          margin: const EdgeInsets.all(20.0),
          padding: padding,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(const Radius.circular(28.0)),
          ),
          child: child
        )
      )
    ),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => FadeTransition(opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation), child: SlideTransition(position: Tween<Offset>(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0)).animate(animation), child: child))
  );
}