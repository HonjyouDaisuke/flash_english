import 'package:flutter/material.dart';

class TrainingProgressBar extends StatelessWidget {
  final double? value;
  final Animation<double>? animation;
  final Color color;
  final double minHeight;

  const TrainingProgressBar({
    super.key,
    this.value,
    this.animation,
    required this.color,
    this.minHeight = 8,
  }) : assert(
          value != null || animation != null,
          'value or animation is required',
        );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget buildBar(double value) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: value,
          minHeight: minHeight,
          backgroundColor: cs.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (_, __) => buildBar(animation!.value),
      );
    }

    return buildBar(value!);
  }
}
