import 'package:flutter/material.dart';
import '../models/prediction.dart';

class PredictionOverlay extends StatelessWidget {
  final List<Prediction> predictions;
  final double previewWidth;
  final double previewHeight;
  final double screenWidth;
  final double screenHeight;

  const PredictionOverlay({
    super.key,
    required this.predictions,
    required this.previewWidth,
    required this.previewHeight,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Escala de la cámara al tamaño de la pantalla
    final scaleX = screenWidth / previewWidth;
    final scaleY = screenHeight / previewHeight;

    return Stack(
      children: predictions.map((prediction) {
        final bbox = prediction.bbox;
        final left = bbox[0] * scaleX;
        final top = bbox[1] * scaleY;
        final width = (bbox[2] - bbox[0]) * scaleX;
        final height = (bbox[3] - bbox[1]) * scaleY;

        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  '${prediction.className} (${(prediction.confidence * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
