import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'services/theme_service.dart';
import 'theme.dart';

class EceuhApp extends StatelessWidget {
  const EceuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    return MaterialApp.router(
      title: 'ECEUH',
      debugShowCheckedModeBanner: false,
      themeMode: themeService.mode,
      theme: EceuhTheme.light(),
      darkTheme: EceuhTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
