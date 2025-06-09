
String buildDetectionMessage(String? label, DateTime? time) {
  if (label == null || time == null) {
    return 'No se ha detectado ningún valor aún.';
  }

  String labelToSpeak;
  switch (label) {
    case "10bs":
      labelToSpeak = "10 bolivianos";
      break;
    case "10bsBack":
      labelToSpeak = "10 bolivianos (reverso)";
      break;
    default:
      labelToSpeak = label;
  }

  final now = DateTime.now();
  final isToday = time.year == now.year && time.month == now.month && time.day == now.day;

  final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  final formattedDate = '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}';

  return isToday
    ? 'Último valor detectado: $labelToSpeak a las $formattedTime'
    : 'Último valor detectado: $labelToSpeak a las $formattedTime del $formattedDate';
}
