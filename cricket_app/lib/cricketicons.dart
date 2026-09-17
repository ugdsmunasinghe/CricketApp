import 'package:flutter/material.dart';

/// White square tile that wraps an icon widget.
class IconTile extends StatelessWidget {
  final Widget child;

  const IconTile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      color: Colors.white,
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Cricket bat image (falls back to an icon if asset is missing).
class BatIcon extends StatelessWidget {
  const BatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/bat.png',
      width: 70,
      height: 70,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.sports_cricket, size: 60, color: Colors.brown),
    );
  }
}

/// Cricket ball image (falls back to an icon if asset is missing).
class BallIcon extends StatelessWidget {
  const BallIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/ball.png',
      width: 70,
      height: 70,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.sports_baseball, size: 60, color: Colors.red),
    );
  }
}