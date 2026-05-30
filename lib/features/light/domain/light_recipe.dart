import 'package:flutter/cupertino.dart';

class LightRecipe {
  const LightRecipe({
    required this.id,
    required this.nameKey,
    required this.scenarioKey,
    required this.color,
    required this.recommendedBrightness,
    required this.isPro,
  });

  final String id;
  final String nameKey;
  final String scenarioKey;
  final Color color;
  final double recommendedBrightness;
  final bool isPro;
}
