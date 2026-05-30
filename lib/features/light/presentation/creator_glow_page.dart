import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../../l10n/app_strings.dart';
import '../state/creator_glow_controller.dart';
import '../state/light_controller.dart';
import 'widgets/recipe_strip.dart';

class CreatorGlowPage extends StatefulWidget {
  const CreatorGlowPage({super.key});

  @override
  State<CreatorGlowPage> createState() => _CreatorGlowPageState();
}

class _CreatorGlowPageState extends State<CreatorGlowPage>
    with WidgetsBindingObserver {
  late final CreatorGlowController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = CreatorGlowController()..initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.onAppLifecycleChanged(state);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final Color glowColor = LightController.renderOutputColor(
          _controller.selectedRecipe.color,
          _controller.brightness,
        );
        return CupertinoPageScaffold(
          backgroundColor: const Color(0xFF070A11),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF121827),
                  Color(0xFF070A11),
                  Color(0xFF111018),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: <Widget>[
                      _CreatorHeader(
                        title: s.creatorTitle,
                        subtitle: s.creatorSubtitle,
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
                          child: _PreviewStage(
                            glowColor: glowColor,
                            cameraController: _controller.cameraController,
                            status: _controller.cameraStatus,
                            hasPreview: _controller.hasCameraPreview,
                            exposureText: s.exposureStatus(
                              _controller.exposureStatus,
                            ),
                            statusText: s.creatorCameraStatus(
                              _controller.cameraStatus,
                            ),
                            companionText: s.companionLightText,
                            retryText: s.retryCamera,
                            lightOnlyText: s.lightOnly,
                            onPanUpdate: (DragUpdateDetails details) {
                              _controller.adjustBrightnessByDrag(
                                details.delta.dy,
                              );
                            },
                            onRetry: _controller.retryCamera,
                            onCompanion: _controller.enableCompanionMode,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
                        child: _BrightnessControl(
                          label: s.brightnessPercent(
                            (_controller.brightness * 100).round(),
                          ),
                          value: _controller.brightness,
                          onChanged: _controller.setBrightness,
                        ),
                      ),
                      RecipeStrip(
                        recipes: CreatorGlowController.recipes,
                        selectedIndex: _controller.selectedRecipeIndex,
                        brightness: _controller.brightness,
                        onSelect: _controller.selectRecipe,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CreatorHeader extends StatelessWidget {
  const _CreatorHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 18, 10),
      child: Row(
        children: <Widget>[
          CupertinoButton(
            padding: const EdgeInsets.all(10),
            onPressed: onBack,
            child: const Icon(
              CupertinoIcons.chevron_left,
              color: CupertinoColors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CupertinoColors.white.withValues(alpha: 0.64),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewStage extends StatelessWidget {
  const _PreviewStage({
    required this.glowColor,
    required this.cameraController,
    required this.status,
    required this.hasPreview,
    required this.exposureText,
    required this.statusText,
    required this.companionText,
    required this.retryText,
    required this.lightOnlyText,
    required this.onPanUpdate,
    required this.onRetry,
    required this.onCompanion,
  });

  final Color glowColor;
  final CameraController? cameraController;
  final CreatorCameraStatus status;
  final bool hasPreview;
  final String exposureText;
  final String statusText;
  final String companionText;
  final String retryText;
  final String lightOnlyText;
  final GestureDragUpdateCallback onPanUpdate;
  final VoidCallback onRetry;
  final VoidCallback onCompanion;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: onPanUpdate,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: glowColor,
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: ColoredBox(color: glowColor)),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: hasPreview
                        ? CameraPreview(cameraController!)
                        : _CompanionPanel(
                            status: status,
                            statusText: statusText,
                            companionText: companionText,
                            retryText: retryText,
                            lightOnlyText: lightOnlyText,
                            onRetry: onRetry,
                            onCompanion: onCompanion,
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: _GlassTag(label: exposureText),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: _GlassTag(label: statusText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanionPanel extends StatelessWidget {
  const _CompanionPanel({
    required this.status,
    required this.statusText,
    required this.companionText,
    required this.retryText,
    required this.lightOnlyText,
    required this.onRetry,
    required this.onCompanion,
  });

  final CreatorCameraStatus status;
  final String statusText;
  final String companionText;
  final String retryText;
  final String lightOnlyText;
  final VoidCallback onRetry;
  final VoidCallback onCompanion;

  @override
  Widget build(BuildContext context) {
    final bool canRetry = status != CreatorCameraStatus.companion;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoColors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                canRetry ? CupertinoIcons.camera : CupertinoIcons.sparkles,
                color: CupertinoColors.white,
                size: 34,
              ),
              const SizedBox(height: 12),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                companionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.white.withValues(alpha: 0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (canRetry)
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      color: const Color(0xFF355C97),
                      borderRadius: BorderRadius.circular(14),
                      onPressed: onRetry,
                      child: Text(retryText),
                    ),
                  if (canRetry) const SizedBox(width: 10),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(14),
                    onPressed: onCompanion,
                    child: Text(lightOnlyText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrightnessControl extends StatelessWidget {
  const _BrightnessControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xCC171E31),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoSlider(
                    value: value,
                    min: CreatorGlowController.minBrightness,
                    max: CreatorGlowController.maxBrightness,
                    activeColor: const Color(0xFF8DBAFF),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTag extends StatelessWidget {
  const _GlassTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoColors.black.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Text(
              label,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
