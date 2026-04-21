import 'package:flutter/material.dart';

/// شعار التطبيق JExplore - يستخدم Logo2.png
class AppLogo extends StatelessWidget {
  final double height;
  final Color? colorFilter;
  final bool showOnError;

  const AppLogo({
    super.key,
    this.height = 40,
    this.colorFilter,
    this.showOnError = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Logo2.png',
      height: height,
      fit: BoxFit.contain,
      color: colorFilter,
      colorBlendMode: colorFilter != null ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) => showOnError
          ? Text(
              'JExplore',
              style: TextStyle(
                color: colorFilter ?? Colors.white,
                fontSize: height * 0.5,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
