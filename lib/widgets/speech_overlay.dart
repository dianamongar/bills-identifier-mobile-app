// lib/widgets/speech_overlay.dart
import 'package:flutter/material.dart';

class SpeechOverlay extends StatelessWidget {
  final String recognizedText;

  const SpeechOverlay({super.key, required this.recognizedText});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withAlpha((0.7 * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            recognizedText.isEmpty ? "Escuchando..." : recognizedText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
