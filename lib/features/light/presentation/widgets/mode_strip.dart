import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_strings.dart';
import '../../domain/light_preset.dart';

class ModeStrip extends StatelessWidget {
  const ModeStrip({
    super.key,
    required this.builtInNames,
    required this.builtInPresets,
    required this.builtInCardColors,
    required this.customPresets,
    required this.customCardColors,
    required this.selectedBuiltInIndex,
    required this.selectedCustomIndex,
    required this.isLoading,
    required this.timerStatus,
    required this.screenBrightness,
    required this.supportsScreenBrightness,
    required this.onSelectBuiltIn,
    required this.onSelectCustom,
    required this.onDeleteCustom,
    required this.onOpenCreator,
    required this.onOpenTimer,
    required this.onOpenPalette,
    required this.onSetScreenBrightness,
  });

  final List<String> builtInNames;
  final List<LightPreset> builtInPresets;
  final List<Color> builtInCardColors;
  final List<LightPreset> customPresets;
  final List<Color> customCardColors;
  final int selectedBuiltInIndex;
  final int? selectedCustomIndex;
  final bool isLoading;
  final String timerStatus;
  final double screenBrightness;
  final bool supportsScreenBrightness;
  final ValueChanged<int> onSelectBuiltIn;
  final ValueChanged<int> onSelectCustom;
  final ValueChanged<int> onDeleteCustom;
  final VoidCallback onOpenCreator;
  final VoidCallback onOpenTimer;
  final VoidCallback onOpenPalette;
  final ValueChanged<double> onSetScreenBrightness;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xCC171E31),
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.13),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _InfoActionCard(
                          icon: CupertinoIcons.camera_fill,
                          title: s.creatorTitle,
                          value: s.creatorCardValue,
                          onTap: onOpenCreator,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoActionCard(
                          icon: CupertinoIcons.timer_fill,
                          title: s.timerTitle,
                          value: timerStatus,
                          onTap: onOpenTimer,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: supportsScreenBrightness
                            ? _ScreenBrightnessCard(
                                title: s.screenBrightnessTitle,
                                percentText: s.screenBrightnessPercent(
                                  (screenBrightness * 100).round(),
                                ),
                                value: screenBrightness,
                                onChanged: onSetScreenBrightness,
                              )
                            : _WebLightCard(
                                title: s.webModeTitle,
                                value: s.webModeValue,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SectionTitle(label: s.defaultModesTitle),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: builtInPresets.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.0,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return _ModeCard(
                        name: builtInNames[index],
                        color: builtInCardColors[index],
                        selected:
                            selectedCustomIndex == null &&
                            selectedBuiltInIndex == index,
                        onTap: () => onSelectBuiltIn(index),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(label: s.myModesTitle),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: customPresets.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return _AddModeCard(
                            isLoading: isLoading,
                            label: s.addCustomMode,
                            onTap: onOpenPalette,
                          );
                        }
                        final int customIndex = index - 1;
                        final LightPreset preset = customPresets[customIndex];
                        return _ModeCard(
                          name: preset.name,
                          color: customCardColors[customIndex],
                          selected: selectedCustomIndex == customIndex,
                          onTap: () => onSelectCustom(customIndex),
                          onLongPress: () => onDeleteCustom(customIndex),
                          width: 138,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: CupertinoColors.white.withValues(alpha: 0.86),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _InfoActionCard extends StatelessWidget {
  const _InfoActionCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: CupertinoColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, size: 18, color: const Color(0xFF8DBAFF)),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CupertinoColors.white.withValues(alpha: 0.72),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebLightCard extends StatelessWidget {
  const _WebLightCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(CupertinoIcons.globe, size: 18, color: Color(0xFF8DBAFF)),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CupertinoColors.white.withValues(alpha: 0.72),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenBrightnessCard extends StatelessWidget {
  const _ScreenBrightnessCard({
    required this.title,
    required this.percentText,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String percentText;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CupertinoColors.white.withValues(alpha: 0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentText,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          CupertinoSlider(
            value: value,
            min: 0.18,
            max: 1,
            activeColor: const Color(0xFF8DBAFF),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
    this.onLongPress,
    this.width,
  });

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final Widget content = CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF376ED1)
              : CupertinoColors.systemGrey.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF79B0FF)
                : CupertinoColors.white.withValues(alpha: 0.08),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CupertinoColors.white.withValues(
                      alpha: selected ? 1 : 0.94,
                    ),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onLongPress == null) {
      return content;
    }
    return GestureDetector(onLongPress: onLongPress, child: content);
  }
}

class _AddModeCard extends StatelessWidget {
  const _AddModeCard({
    required this.isLoading,
    required this.label,
    required this.onTap,
  });

  final bool isLoading;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 104,
        decoration: BoxDecoration(
          color: const Color(0xFF244777),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: CupertinoColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isLoading
                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                : const Icon(
                    CupertinoIcons.add,
                    size: 24,
                    color: CupertinoColors.white,
                  ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
