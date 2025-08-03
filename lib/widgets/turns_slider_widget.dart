import 'package:flutter/material.dart';

class TurnsSliderWidget extends StatefulWidget {
  final int initialTurns;
  final ValueChanged<int> onTurnsChanged;

  const TurnsSliderWidget({
    super.key,
    this.initialTurns = 0,
    required this.onTurnsChanged,
  });

  @override
  State<TurnsSliderWidget> createState() => _TurnsSliderWidgetState();
}

class _TurnsSliderWidgetState extends State<TurnsSliderWidget> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialTurns.toDouble();
  }

  String _labelForValue(double value) {
    return value == 0 ? '∞' : value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turns: ${_labelForValue(_currentValue)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Slider(
              value: _currentValue,
              min: 0,
              max: 15,
              divisions: 3, // 0, 5, 10, 15
              label: _labelForValue(_currentValue),
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onTurnsChanged(value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text('∞'), Text('5'), Text('10'), Text('15')],
            ),
          ],
        ),
      ),
    );
  }
}
