// lib/widgets/camera_view.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/providers/detection_provider.dart';
import 'package:provider/provider.dart';
import '../models/prediction.dart';
import '../services/prediction_service.dart';
import 'prediction_overlay.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  bool _isInitialized = false;
  List<Prediction> _predictions = [];
  Timer? _timer;
  final predictionService = PredictionService();


  @override
  void initState() {
    super.initState();
    debugPrint('initState: Iniciando cámara...');
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    debugPrint('Cámaras disponibles: ${cameras.length}');
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    debugPrint('Cámara inicializada');

    if (mounted) {
      setState(() => _isInitialized = true);
      _startFrameLoop();
      debugPrint('Camera ready y loop iniciado');
    }
  }

  void _startFrameLoop() {
    debugPrint('Iniciando timer para capturar frames...');
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _sendFrameToAPI());
  }

  Future<void> _sendFrameToAPI() async {
    debugPrint('Intentando capturar frame...');
    if (!_controller!.value.isStreamingImages) {
      await _controller!.startImageStream((CameraImage image) async {
        debugPrint('Obtenida imagen desde stream, deteniendo stream...');
        _controller!.stopImageStream();

        try {
          debugPrint('Convirtiendo imagen a JPEG...');
          Uint8List jpegBytes = await convertYUV420toJpeg(image, _controller!);

          debugPrint('Enviando imagen a la API...');
          final predictions = await predictionService.sendImageBytesForPrediction(jpegBytes);
          debugPrint('Predicciones recibidas: ${predictions.length}');

          if (mounted) {
            setState(() => _predictions = predictions);
          }
          // Actualizar el estado del provider con la primera predicción
          if (predictions.isNotEmpty) {
                final predictedLabel = predictions.first.className;
                Provider.of<DetectionProvider>(context, listen: false)
                    .updateDetection(predictedLabel);
              }
        } catch (e) {
          debugPrint('Error procesando frame: $e');
        }
      });
    } else {
      debugPrint('Ya hay un stream en curso, esperando...');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final screenSize = MediaQuery.of(context).size;
    final previewSize = _controller!.value.previewSize!;

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller!),
        PredictionOverlay(
          predictions: _predictions,
          previewWidth: previewSize.height, // ¡Ojo! width y height están rotados en portrait
          previewHeight: previewSize.width,
          screenWidth: screenSize.width,
          screenHeight: screenSize.height,
        ),
      ],
    );
  }
}

// Método auxiliar para convertir YUV420 a JPEG para enviar a la API
Future<Uint8List> convertYUV420toJpeg(CameraImage image, CameraController controller) async {
  debugPrint('Tomando foto usando takePicture()');
  final file = await controller.takePicture();
  final bytes = await file.readAsBytes();
  debugPrint('Imagen convertida a bytes: ${bytes.length} bytes');
  return bytes;
}

