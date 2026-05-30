import 'package:flutter_test/flutter_test.dart';
import 'package:soft_light/features/light/domain/creator_glow_session_state.dart';
import 'package:soft_light/features/light/state/creator_glow_controller.dart';

void main() {
  test('creator recipes ship as six free MVP recipes', () {
    expect(CreatorGlowController.recipes, hasLength(6));
    expect(
      CreatorGlowController.recipes.every((recipe) => recipe.isPro == false),
      isTrue,
    );
    expect(
      CreatorGlowController.recipes.every(
        (recipe) =>
            recipe.recommendedBrightness >=
                CreatorGlowController.minBrightness &&
            recipe.recommendedBrightness <= CreatorGlowController.maxBrightness,
      ),
      isTrue,
    );
  });

  test('classifies local preview brightness into exposure states', () {
    expect(
      CreatorGlowController.classifyLuma(0),
      CreatorExposureStatus.unknown,
    );
    expect(
      CreatorGlowController.classifyLuma(40),
      CreatorExposureStatus.tooDim,
    );
    expect(
      CreatorGlowController.classifyLuma(120),
      CreatorExposureStatus.balanced,
    );
    expect(
      CreatorGlowController.classifyLuma(230),
      CreatorExposureStatus.tooBright,
    );
  });

  test('creator session serializes selected recipe and brightness', () {
    const CreatorGlowSessionState state = CreatorGlowSessionState(
      selectedRecipeId: 'soft-pink',
      brightness: 0.84,
      useCompanionMode: true,
    );

    final CreatorGlowSessionState restored = CreatorGlowSessionState.fromMap(
      state.toMap(),
    );

    expect(restored.selectedRecipeId, 'soft-pink');
    expect(restored.brightness, 0.84);
    expect(restored.useCompanionMode, isTrue);
  });
}
