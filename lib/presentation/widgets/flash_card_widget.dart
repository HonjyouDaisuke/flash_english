import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashCardWidget extends StatefulWidget {
  final String frontText;
  final String backText;
  final String? frontAudio;
  final String? backAudio;
  final ValueChanged<bool>? onFlip;

  const FlashCardWidget({
    super.key,
    required this.frontText,
    required this.backText,
    this.frontAudio,
    this.backAudio,
    this.onFlip,
  });

  @override
  State<FlashCardWidget> createState() => FlashCardWidgetState();
}

class FlashCardWidgetState extends State<FlashCardWidget> {
  // final AudioPlayer _player = AudioPlayer();
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool isFront = true;

  void reset() {
    if (!isFront) {
      _cardKey.currentState?.toggleCard();
      isFront = true;
    }
  }

  @override
  void didUpdateWidget(covariant FlashCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return FlipCard(
      key: _cardKey,
      onFlipDone: (_) async {
        isFront = !isFront;
        // await playCurrentSound();
        widget.onFlip?.call(isFront);
      },
      front: Container(
        width: 500,
        height: 200,
        alignment: Alignment.center,
        child: Card(
          color: cs.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              widget.frontText,
              style: TextStyle(fontSize: 24, color: cs.onPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      back: SizedBox(
        width: 500,
        height: 200,
        child: Card(
          color: cs.secondary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              widget.backText,
              style: TextStyle(fontSize: 24, color: cs.onSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
