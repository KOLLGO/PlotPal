import 'package:flutter/material.dart';

class PlayerManagerWidget extends StatefulWidget {
  final void Function(Set<String>)? onPlayersChanged;
  const PlayerManagerWidget({super.key, this.onPlayersChanged});

  @override
  State<PlayerManagerWidget> createState() => _PlayerManagerWidgetState();
}

class _PlayerManagerWidgetState extends State<PlayerManagerWidget> {
  final TextEditingController nameController = TextEditingController();
  final Set<String> players = {};

  void _addPlayer() {
    final name = nameController.text.trim();
    if (name.isNotEmpty && !players.contains(name)) {
      setState(() {
        players.add(name);
        widget.onPlayersChanged?.call(players);
      });
      nameController.clear();
    }
  }

  void _removePlayer(String name) {
    setState(() {
      players.remove(name);
      widget.onPlayersChanged?.call(players);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field + button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Player Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addPlayer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Players:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              child: players.isEmpty
                  ? Center(
                      child: Text(
                        'No players added yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final name = players.elementAt(index);
                        return ListTile(
                          dense: true,
                          title: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePlayer(name),
                            tooltip: 'Remove',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
