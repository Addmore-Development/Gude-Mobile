import 'package:flutter/material.dart';
import 'package:gude_mobile/core/router/app_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

void main() {
  runApp(const GudeApp());
}

class GudeApp extends StatelessWidget {
  const GudeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gude',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}

