import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class FullScreenErrorFallback extends StatelessWidget {
  final FlutterErrorDetails details;
  const FullScreenErrorFallback({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: AppColors.bgPrimaryLight,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'An unexpected error occurred.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.errorLight,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void installGlobalErrorHandling() {
  FlutterError.onError = (details) => debugPrint(details.exceptionAsString());
  ErrorWidget.builder = (details) => FullScreenErrorFallback(details: details);
}
