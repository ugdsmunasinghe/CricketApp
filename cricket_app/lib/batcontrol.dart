import 'package:flutter/material.dart';

/// The interactive control at the bottom of the score area.
///
/// - While the over is live: shows a "Bat" button. Tapping it plays
///   the ball — the runs come from the `rollRuns` callback — and a
///   brief reveal animation (circle + "X Runs") shows the result.
/// - When the over ends: shows a red "Restart" button instead.
class BatControl extends StatefulWidget {
  final bool gameOver;
  final int Function() rollRuns;
  final void Function(int runsScored) onBallPlayed;
  final VoidCallback onRestart;

  const BatControl({
    super.key,
    required this.gameOver,
    required this.rollRuns,
    required this.onBallPlayed,
    required this.onRestart,
  });

  @override
  State<BatControl> createState() => _BatControlState();
}

class _BatControlState extends State<BatControl> {
  static const double _maxDrag = 110;
  static const int _maxRuns = 6;

  bool _revealing = false;
  int _revealedRuns = 0;

  double get _distanceForRuns =>
      (_revealedRuns / _maxRuns).clamp(0, 1).toDouble() * _maxDrag;

  Future<void> _playBall() async {
    if (widget.gameOver || _revealing) return;

    final runs = widget.rollRuns(); // 👈 call the host's roll function

    setState(() {
      _revealing = true;
      _revealedRuns = runs;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    widget.onBallPlayed(runs);

    setState(() {
      _revealing = false;
      _revealedRuns = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameOver) {
      return ElevatedButton(
        onPressed: widget.onRestart,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text('Restart'),
      );
    }

    return SizedBox(
      height: _maxDrag + 60,
      width: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (_revealing)
            Positioned(top: 0, child: _trackCircle()),
          if (_revealing)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: 44 + _distanceForRuns,
              child: Text(
                _revealedRuns == 0 ? 'No Runs' : '$_revealedRuns Runs',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_revealing)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: 44,
              child: Container(
                width: 1.5,
                height: _distanceForRuns,
                color: Colors.white70,
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: _revealing ? _distanceForRuns : 0,
            child: GestureDetector(
              onTap: _playBall,
              child: _batButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trackCircle() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.tealAccent, width: 2),
      ),
    );
  }

  Widget _batButton() {
    return Container(
      width: _revealing ? 44 : null,
      height: _revealing ? 44 : null,
      padding: _revealing
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF0A3D62),
        shape: _revealing ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: _revealing ? null : BorderRadius.circular(6),
        border: _revealing
            ? Border.all(color: Colors.tealAccent, width: 2)
            : null,
      ),
      child: const Text(
        'Bat',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}