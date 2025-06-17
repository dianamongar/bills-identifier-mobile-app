import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> init() async {
    await _tts.setLanguage("es-ES");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  static Future<void> speak(String text, {Function()? onComplete}) async {
    _tts.setCompletionHandler(() {
      if (onComplete != null) {
        onComplete();
      }
    });

    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
