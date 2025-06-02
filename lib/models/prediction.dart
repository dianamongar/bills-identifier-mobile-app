class Prediction {
  final int classId;
  final String className;
  final double confidence;
  final List<double> bbox;

  Prediction({
    required this.classId,
    required this.className,
    required this.confidence,
    required this.bbox,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      classId: json['class_id'],
      className: json['class_name'],
      confidence: (json['confidence'] as num).toDouble(),
      bbox: List<double>.from(json['bbox'].map((e) => (e as num).toDouble())),
    );
  }
}
