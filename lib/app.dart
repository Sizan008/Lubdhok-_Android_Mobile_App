import 'package:flutter/material.dart';
import 'package:lubdhok/core/router/app_router.dart';
import 'package:lubdhok/core/theme/app_theme.dart';

class LubdhokApp extends StatelessWidget {
  const LubdhokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lubdhok',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}