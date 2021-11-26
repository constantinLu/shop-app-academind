import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );

    // if (route.settings.name == '/') {
    //   return child;
    // }
    // return FadeTransition(
    //   opacity: animation,
    //   child: child,
    // );

    // return super
    //     .buildTransitions(context, animation, secondaryAnimation, child);
  }
}

// for using globally
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> pageRoute,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (pageRoute.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
