import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/services/tts_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../providers/detection_provider.dart';
import '../utils/detection_utils.dart';


class SpeechService with WidgetsBindingObserver {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;
  BuildContext? _context;

  Future<void> initSpeech(BuildContext context) async {
    _context = context;
    WidgetsBinding.instance.addObserver(this); // ← escucha cambios de estado de la app

    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        debugPrint('🔊 Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          _restartListening();
        }
      },
      onError: (error) {
        debugPrint('⚠️ Speech error: $error');
        _restartListening();
      },
    );

    if (_isAvailable) {
      startListening();
    }
  }

  void startListening() {
    if (_isAvailable && !_isListening && _context != null) {
      final options = stt.SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        partialResults: true
      );
      _speech.listen(
        localeId: 'es_BO',
        listenOptions: options,
        onResult: (result) {
          final text = result.recognizedWords.toLowerCase();
          debugPrint('🗣️ Texto detectado: $text');

          if (text.contains("último valor")) {
            final detection = _context!.read<DetectionProvider>();
            final message = buildDetectionMessage(
              detection.lastValue,
              detection.detectionTime,
            );
            TTSService.speak(message);
          }
        },
      );
      _isListening = true;
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
  }

  void _restartListening() async {
    _isListening = false;
    await Future.delayed(const Duration(milliseconds: 300));
    startListening();
  }

  /// Si la app va a segundo plano, detiene. Al volver, reanuda.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      debugPrint("📴 App en segundo plano. Deteniendo escucha...");
      stopListening();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("📲 App activa. Reiniciando escucha...");
      _restartListening();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopListening();
  }
}
