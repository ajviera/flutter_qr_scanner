import 'package:flutter/material.dart';

class OnDifferentSide<T> extends MaterialPageRoute<T> {
  final offset;

  OnDifferentSide({WidgetBuilder builder, RouteSettings settings, this.offset})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    return SlideTransition(
      child: child,
      position: Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 550);
}
