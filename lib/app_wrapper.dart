import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/pages/home_page.dart';
import '../services/speech_service.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final _speechService = SpeechService();
  int _tapCount = 0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _speechService.initSpeech(context); 
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _speechService.dispose();
    super.dispose();
  }

  void _handleTripleTap() {
    _tapCount++;
    _resetTimer?.cancel();

    if (_tapCount >= 3) {
      _tapCount = 0;
      _speechService.startListening();
    } else {
      _resetTimer = Timer(const Duration(milliseconds: 600), () {
        _tapCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTripleTap,
      child: const HomePage(),
    );
  }
}
