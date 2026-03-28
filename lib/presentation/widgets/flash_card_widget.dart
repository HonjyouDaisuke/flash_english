import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _player = AudioPlayer();
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  bool isFront = true;

  Future<void> _play(String path) async {
    if (path.isEmpty) return;
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  Future<void> playCurrentSound() async {
    if (isFront && widget.frontAudio != null) {
      await _play(widget.frontAudio!);
      debugPrint("表面: $isFront  ファイル名:$widget.frontAudio");
    } else if (!isFront && widget.backAudio != null) {
      await _play(widget.backAudio!);
      debugPrint("裏面: $isFront  ファイル名:$widget.backAudio");
    }
  }

  // Future<void> _handleFlip() async {
  //   _isFront = !_isFront;

  //   await playCurrentSound();
  //   widget.onFlip?.call(_isFront);
  // }

  void reset() {
    if (!isFront) {
      _cardKey.currentState?.toggleCard();
      isFront = true;
      //widget.onFlip?.call(_isFront);
    }
  }

  Future<void> _playInitialAudio() async {
    if (widget.frontAudio != null) {
      await _play(widget.frontAudio!);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      playCurrentSound();
    });
  }

  @override
  void didUpdateWidget(covariant FlashCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👇 問題が変わったときだけ
    if (oldWidget.frontText != widget.frontText ||
        oldWidget.backText != widget.backText) {
      isFront = true;

      if (_cardKey.currentState?.isFront == false) {
        _cardKey.currentState?.toggleCard();
      }

      //widget.onFlip?.call(true); // 親も同期
      //_playInitialAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: _cardKey,
      onFlipDone: (_) async {
        isFront = !isFront;
        await playCurrentSound();
        widget.onFlip?.call(isFront);
      },
      front: Container(
        width: 500,
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
      back: SizedBox(
        width: 500,
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
