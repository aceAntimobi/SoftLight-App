import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_strings.dart';
import '../../domain/light_recipe.dart';
import '../../state/light_controller.dart';

class RecipeStrip extends StatelessWidget {
  const RecipeStrip({
    super.key,
    required this.recipes,
    required this.selectedIndex,
    required this.brightness,
    required this.onSelect,
  });

  final List<LightRecipe> recipes;
  final int selectedIndex;
  final double brightness;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final LightRecipe recipe = recipes[index];
          final bool selected = selectedIndex == index;
          final Color color = LightController.renderOutputColor(
            recipe.color,
            selected ? brightness : recipe.recommendedBrightness,
          );
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 156,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF315FAD)
                    : CupertinoColors.systemGrey.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF8DBAFF)
                      : CupertinoColors.white.withValues(alpha: 0.09),
                  width: selected ? 1.2 : 1,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          s.recipeName(recipe.nameKey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.recipeScenario(recipe.scenarioKey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CupertinoColors.white.withValues(alpha: 0.7),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
