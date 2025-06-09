import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detection_provider.dart';

class GalleryTab extends StatefulWidget {
  const GalleryTab({super.key});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  @override
  void initState() {
    super.initState();
    
  }

  
  @override
  Widget build(BuildContext context) {
    final detection = Provider.of<DetectionProvider>(context);
    final label = detection.lastValue;
    final time = detection.detectionTime;

    String message, labelToSpeak='';
    if (label != null && time != null ) {
      if(label=="10bs") {
        labelToSpeak = "10 bolivianos";
      }
      if(label=="10bsBack") {
        labelToSpeak = "10 bolivianos (reverso)";
      }
      message = 'Último valor detectado: $labelToSpeak a las ${time.hour}:${time.minute}';
    } else {
      message = 'No se ha detectado ningún valor aún.';
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){} ,
              child: const Text('🔊 Repetir mensaje'),
            ),
          ],
        ),
      ),
    );
  }
}
