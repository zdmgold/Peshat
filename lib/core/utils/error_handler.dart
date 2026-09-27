import 'package:flutter/material.dart';

class FullScreenErrorFallback extends StatelessWidget {
  final FlutterErrorDetails details;
  const FullScreenErrorFallback({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'An unexpected error occurred.',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

void installGlobalErrorHandling() {
  FlutterError.onError = (details) => debugPrint(details.exceptionAsString());
  ErrorWidget.builder = (details) => FullScreenErrorFallback(details: details);
}
