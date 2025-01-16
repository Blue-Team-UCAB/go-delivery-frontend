import 'package:flutter/cupertino.dart';

class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const FadeIn({
    Key? key,
    required this.child,
    required this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: child,
    );
  }
}