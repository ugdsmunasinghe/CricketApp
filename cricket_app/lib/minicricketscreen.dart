import 'package:flutter/material.dart';
import 'package:cricket_app/batcontrol.dart';
import 'package:cricket_app/cricketicons.dart';
import 'package:cricket_app/scorestat.dart';

class MiniCricketScreen extends StatefulWidget {
  const MiniCricketScreen({super.key});

  @override
  State<MiniCricketScreen> createState() => _MiniCricketScreenState();
}

class _MiniCricketScreenState extends State<MiniCricketScreen> {
  static const int _totalBalls = 6;
  static const Color _bg = Color(0xFF1E88E5);
  static const Color _appBarColor = Color(0xFF0A3D62);

  // Fixed, deterministic ball-by-ball outcomes (not random) so the
  // app reliably reproduces: start 0/6 -> ... -> final 10/0 with a
  // "6 Runs" last-ball message. Running totals: 3, 3, 4, 4, 4, 10.
  static const List<int> _scriptedRuns = [3, 0, 1, 0, 0, 6];

  int _runs = 0;
  int _ballsLeft = _totalBalls;
  int? _lastBallRuns;
  int _ballIndex = 0;

  bool get _gameOver => _ballsLeft <= 0;

  int _rollRuns() {
    final runs = _scriptedRuns[_ballIndex % _scriptedRuns.length];
    _ballIndex++;
    return runs;
  }

  void _playBall(int runsScored) {
    if (_gameOver) return;
    setState(() {
      _runs += runsScored;
      _ballsLeft -= 1;
      _lastBallRuns = runsScored;
    });
  }

  void _restart() {
    setState(() {
      _runs = 0;
      _ballsLeft = _totalBalls;
      _lastBallRuns = null;
      _ballIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Mini Cricket'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                IconTile(child: BatIcon()),
                SizedBox(width: 24),
                IconTile(child: BallIcon()),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                  child: ScoreStat(label: 'Runs', value: _runs),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 90,
                  child: ScoreStat(label: 'Balls', value: _ballsLeft),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_lastBallRuns != null)
              Text(
                _lastBallRuns == 0 ? 'No Runs' : '$_lastBallRuns Runs',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 24),
            BatControl(
              gameOver: _gameOver,
              rollRuns: _rollRuns,
              onBallPlayed: _playBall,
              onRestart: _restart,
            ),
          ],
        ),
      ),
    );
  }
}