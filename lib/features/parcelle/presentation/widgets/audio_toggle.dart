import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AudioToggle extends StatefulWidget {
  final String instructions;
  const AudioToggle({super.key, required this.instructions});

  @override
  _AudioToggleState createState() => _AudioToggleState();
}

class _AudioToggleState extends State<AudioToggle> {
  FlutterTts? _tts;
  bool _isPlaying = false;

  Future<void> _initTts() async {
    _tts ??= FlutterTts();
    await _tts!.setLanguage(Localizations.localeOf(context).languageCode);
  }

  Future<void> _toggleAudio() async {
    await _initTts();
    if (_isPlaying) {
      await _tts!.stop();
    } else {
      await _tts!.speak(widget.instructions);
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
      onPressed: _toggleAudio,
    );
  }
}