class CreatorGlowSessionState {
  const CreatorGlowSessionState({
    required this.selectedRecipeId,
    required this.brightness,
    required this.useCompanionMode,
  });

  final String selectedRecipeId;
  final double brightness;
  final bool useCompanionMode;

  factory CreatorGlowSessionState.fromMap(Map<String, dynamic> map) {
    return CreatorGlowSessionState(
      selectedRecipeId: map['selectedRecipeId'] as String? ?? 'natural-glow',
      brightness: (map['brightness'] as num?)?.toDouble() ?? 0.88,
      useCompanionMode: map['useCompanionMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedRecipeId': selectedRecipeId,
      'brightness': brightness,
      'useCompanionMode': useCompanionMode,
    };
  }
}
