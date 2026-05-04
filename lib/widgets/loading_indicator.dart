import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double progress;

  const LoadingIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress < 1.0 ? progress : null,
      backgroundColor: Colors.transparent,
      color: const Color(0xFF4A9EFF),
      minHeight: 2,
    );
  }
}
