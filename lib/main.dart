import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/app.dart';
import 'package:provider/provider.dart';
import 'providers/detection_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DetectionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

