// pages/camera_tab.dart
import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';  // importa tu widget CameraView

class CameraTab extends StatelessWidget {
  const CameraTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CameraView();  // aquí usas tu widget que ya maneja cámara y predicción
  }
}