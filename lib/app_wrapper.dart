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

  @override
  void initState() {
    super.initState();
    _speechService.initSpeech(context);
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
