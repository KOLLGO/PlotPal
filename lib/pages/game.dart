import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Game extends StatefulWidget {
  final Set<String> players;
  final List<String> data;
  final int turns; // 0 = unlimited turns

  const Game({
    super.key,
    required this.players,
    required this.turns,
    required this.data,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool _stop = false;
  bool _revealAll = false;
  late List<String> _data;
  int _currentTurn = 0;
  late Iterator<String> _playerIterator;
  String? _currentPlayer;
  String? _nextPlayer;
  final TextEditingController _controller = TextEditingController();
  bool _inputEnabled = false;
  Completer<void>? _inputCompleter;

  @override
  void initState() {
    super.initState();
    _data = List<String>.from(widget.data);
    _playerIterator = widget.players.iterator;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runTurns();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> runTurns() async {
    if (widget.players.isEmpty) return;
    _currentTurn = 0;
    bool unlimited = widget.turns == 0;
    final playerList = widget.players.toList();

    while ((unlimited || _currentTurn < widget.turns) && !_stop) {
      _playerIterator = playerList.iterator;
      int idx = 0;
      while (_playerIterator.moveNext() && !_stop) {
        setState(() {
          _currentPlayer = _playerIterator.current;
          _nextPlayer = (idx + 1 < playerList.length)
              ? playerList[idx + 1]
              : playerList[0];
          _inputEnabled = true;
        });
        await _waitForInput();
        if (_stop) break;
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Next Player'),
            content: Text(
              'Pass the Phone to ${_nextPlayer ?? "the next player"}.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (_stop) break;
        idx++;
      }
      _currentTurn++;
    }

    if (!_stop) {
      stopTurns();
    }
  }

  Future<void> _waitForInput() async {
    _inputCompleter = Completer<void>();
    await _inputCompleter!.future;
    _inputCompleter = null;
  }

  void _submitSentence() {
    String value = _controller.text.trim();
    if (value.isNotEmpty) {
      if (!value.endsWith('.')) {
        value += '.';
      }
      setState(() {
        _data.insert(0, value);
        _controller.clear();
        _inputEnabled = false;
      });
      _inputCompleter?.complete();
    }
  }

  void stopTurns() async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Story?'),
        content: const Text('Do you want to save the story?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      await _saveStory();
    }

    setState(() {
      _stop = true;
      _inputEnabled = false;
      _revealAll = true;
    });
  }

  Future<void> _saveStory() async {
    try {
      Directory? baseDir;
      try {
        baseDir = await getDownloadsDirectory();
      } catch (_) {}
      baseDir ??= await getExternalStorageDirectory();
      if (baseDir == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not access a writable folder!'),
            ),
          );
        }
        return;
      }
      final storiesDir = Directory('${baseDir.path}/plotpal');
      if (!await storiesDir.exists()) {
        await storiesDir.create(recursive: true);
      }
      final now = DateTime.now();
      final filename =
          'Story${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.txt';
      final file = File('${storiesDir.path}/$filename');
      await file.writeAsString(_data.reversed.join('\n'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Story saved in ${storiesDir.path}/$filename'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save story!')));
      }
    }
  }

  double _spaceWidth(BuildContext context) {
    final textPainter = TextPainter(
      text: const TextSpan(text: ' ', style: TextStyle(fontSize: 16)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    List<String> visibleSentences;
    if (_revealAll) {
      visibleSentences = _data.reversed.toList(); // FIFO
    } else if (_data.isNotEmpty) {
      visibleSentences = [_data.first];
    } else {
      visibleSentences = [];
    }
    return Scaffold(
      body: Column(
        children: [
          Divider(height: 30, color: Colors.transparent),
          const SizedBox(height: 16),
          Text(
            'Turn: ${_currentTurn + 1}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: _spaceWidth(context),
                runSpacing: 8,
                children: _data.reversed.toList().asMap().entries.map((entry) {
                  final idx = entry.key;
                  final e = entry.value;
                  final isVisible = _revealAll || idx == _data.length - 1;
                  if (isVisible) {
                    return Text(
                      e,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    );
                  } else {
                    final text = Text(
                      e,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.transparent,
                      ),
                    );
                    final dots = List.filled(e.runes.length, '•').join();
                    return Card(
                      color: Colors.grey.shade400,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            text,
                            Text(
                              dots,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.transparent,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
          if (_currentPlayer != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '$_currentPlayer\'s Turn:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: _inputEnabled,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Your Sentence...',
                    ),
                    onSubmitted: (_) {
                      if (_inputEnabled) _submitSentence();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _inputEnabled
                      ? () {
                          _submitSentence();
                        }
                      : null,
                  child: const Text('Post'),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: stopTurns, child: const Text('Stop')),
          const SizedBox(height: 16),
          Divider(height: 30, color: Colors.transparent),
        ],
      ),
    );
  }
}
