import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphicWidget extends StatelessWidget {
  const GlassmorphicWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              // color: const Color(0x80606060).withOpacity(0.5),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)),
          child: child,
        ),
      ),
    );
  }
}
