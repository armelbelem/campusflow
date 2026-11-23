import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/accueil/titre_screen.dart';

void main() => runApp(const CampusFlowApp());

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: campusTheme(),
      home: const TitreScreen(),
    );
  }
}
