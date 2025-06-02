import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import '../models/prediction.dart';

class PredictionService {
  final String apiUrl;

  PredictionService({this.apiUrl = 'http://192.168.0.50:8000/predict/'});

  Future<List<Prediction>> sendImageBytesForPrediction(Uint8List imageBytes) async {
  final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  request.files.add(
    http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: 'frame.jpg',
      contentType: MediaType('image', 'jpeg'),
    ),
  );
  debugPrint('Enviando solicitud POST con imagen...');

  final response = await request.send();

  debugPrint('Respuesta recibida con código: ${response.statusCode}');

  if (response.statusCode == 200) {
    final responseString = await response.stream.bytesToString();
    final jsonData = json.decode(responseString);
    // imprime en consola el JSON recibido
    debugPrint('Respuesta del servidor: $jsonData');

    return (jsonData['predictions'] as List)
        .map((item) => Prediction.fromJson(item))
        .toList();
  } else {
    debugPrint('Error al enviar imagen: ${response.statusCode}');
    return [];
  }
}
}
