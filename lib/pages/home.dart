import 'package:flutter/material.dart';
import 'package:plotpal/pages/game.dart';
import 'package:plotpal/widgets/player_manager_widget.dart';
import 'package:plotpal/widgets/turns_slider_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> _players = {};
  int _turns = 0; // 0 = unlimited turns
  void _handlePlayersChanged(Set<String> players) {
    setState(() {
      _players = players;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Plot Pal',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                PlayerManagerWidget(onPlayersChanged: _handlePlayersChanged),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                TurnsSliderWidget(
                  initialTurns: _turns,
                  onTurnsChanged: (turns) {
                    setState(() {
                      _turns = turns;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_players.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add players first!'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Game(players: _players, turns: _turns, data: []),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text('Start Plotting'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
