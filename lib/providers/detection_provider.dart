import 'package:flutter/material.dart';

class DetectionProvider with ChangeNotifier {
  String? _lastValue;
  DateTime? _detectionTime;

  String? get lastValue => _lastValue;
  DateTime? get detectionTime => _detectionTime;

  void updateDetection(String value) {
    _lastValue = value;
    _detectionTime = DateTime.now();
    notifyListeners();
  }

  String getDetectionPhrase() {
    if (_lastValue == null || _detectionTime == null) {
      return 'No hay detección aún.';
    }
    final hour = _detectionTime!.hour.toString().padLeft(2, '0');
    final minute = _detectionTime!.minute.toString().padLeft(2, '0');
    return 'Último valor detectado $_lastValue a las $hour:$minute';
  }
}
