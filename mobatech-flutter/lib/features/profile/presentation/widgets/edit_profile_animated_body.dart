import 'package:flutter/material.dart';

class EditProfileAnimatedBody extends StatelessWidget {
  final Widget child;

  const EditProfileAnimatedBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, childWidget) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: childWidget,
        ),
      ),
      child: child,
    );
  }
}
