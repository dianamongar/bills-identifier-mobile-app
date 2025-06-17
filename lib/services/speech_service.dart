import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/services/tts_service.dart';
import 'package:flutter_bills_identifier/widgets/speech_overlay.dart';
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
  OverlayEntry? _overlayEntry;
  String _currentText = '';


  Future<void> initSpeech(BuildContext context) async {
    _context = context;
    TTSService.init();
    WidgetsBinding.instance.addObserver(this); // ← escucha cambios de estado de la app

    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        debugPrint('🔊 Speech status: $status');
        _isListening = status == 'listening';
      },
      onError: (error) {
        debugPrint('⚠️ Speech error: $error');
        _isListening = false;
      },
    );

  }

  void startListening() {
    if (_isAvailable && !_isListening && _context != null) {
      _showOverlay();
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
          _updateOverlayText(text);

          if (text.contains("último valor")) {
            final detection = _context!.read<DetectionProvider>();
            final message = buildDetectionMessage(
              detection.lastValue,
              detection.detectionTime,
            );
            TTSService.speak(
              message,
              onComplete: () {
                _removeOverlay();
              },
            );
          }
        },
      );
      _isListening = true;
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    _removeOverlay();
  }

  void _showOverlay() {
    if (_context == null || _overlayEntry != null) return;

    final overlay = Overlay.of(_context!);
    _overlayEntry = OverlayEntry(
      builder: (_) => SpeechOverlay(recognizedText: _currentText),
    );

    overlay.insert(_overlayEntry!);
  }

  void _updateOverlayText(String text) {
    _currentText = text;
    _overlayEntry?.markNeedsBuild(); // Redibuja el overlay
  }

  void _removeOverlay() {
    _currentText = '';
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Si la app va a segundo plano, detiene. Al volver, reanuda.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      debugPrint("📴 App en segundo plano. Deteniendo escucha...");
      stopListening();
    } else if (state == AppLifecycleState.resumed) {
      // debugPrint("📲 App activa. Reiniciando escucha...");
      // _restartListening();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopListening();
  }
}
