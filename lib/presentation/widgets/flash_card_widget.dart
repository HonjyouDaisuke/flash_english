import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:audioplayers/audioplayers.dart';

class FlashCardWidget extends StatefulWidget {
  final String frontText;
  final String backText;
  final String? frontAudio;
  final String? backAudio;

  const FlashCardWidget({
    super.key,
    required this.frontText,
    required this.backText,
    this.frontAudio,
    this.backAudio,
  });

  @override
  State<FlashCardWidget> createState() => FlashCardWidgetState();
}

class FlashCardWidgetState extends State<FlashCardWidget> {
  final AudioPlayer _player = AudioPlayer();
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool _isFront = true;
  Future<void> _play(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  Future<void> _handleFlip() async {
    _isFront = !_isFront;

    await _player.stop();

    if (_isFront && widget.frontAudio != null) {
      await _play(widget.frontAudio!);
    } else if (!_isFront && widget.backAudio != null) {
      await _play(widget.backAudio!);
    }
  }

  void reset() {
    if (_cardKey.currentState?.isFront == false) {
      _cardKey.currentState?.toggleCard();
      _isFront = true;
    }
  }

  Future<void> _playInitialAudio() async {
    if (widget.frontAudio != null) {
      await _play(widget.frontAudio!);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playInitialAudio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: _cardKey,
      onFlip: _handleFlip,
      front: Container(
        width: 300,
        height: 200,
        alignment: Alignment.center,
        child: Card(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              widget.frontText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      back: Container(
        width: 300,
        height: 200,
        child: Card(
          color: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              widget.backText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
