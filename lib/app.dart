import 'package:flutter/material.dart';
import 'package:flutter_bills_identifier/app_wrapper.dart';
import 'package:provider/provider.dart';
import 'providers/detection_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DetectionProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Bills Identifier',
        debugShowCheckedModeBanner: false,
        home: const AppWrapper(), // 👈 usa un wrapper con initState
      ),
    );
  }
}
