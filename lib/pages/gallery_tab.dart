import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detection_provider.dart';

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final detection = Provider.of<DetectionProvider>(context);
    final label = detection.lastValue;
    final time = detection.detectionTime;

    String message;
    if (label != null && time != null) {
      message = 'Último valor detectado: $label a las ${time.hour}:${time.minute}';
    } else {
      message = 'No se ha detectado ningún valor aún.';
    }

    return Scaffold(
      body: Center(
        child: Text(message,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
