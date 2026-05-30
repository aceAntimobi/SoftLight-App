import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LightCanvas extends StatelessWidget {
  const LightCanvas({
    super.key,
    required this.color,
    required this.brightnessText,
    required this.modeName,
    required this.gestureHint,
    required this.timerText,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final Color color;
  final String brightnessText;
  final String modeName;
  final String gestureHint;
  final String? timerText;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.02),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    color: color,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _GlassTag(label: modeName),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _GlassTag(label: brightnessText),
                ),
                if (timerText != null)
                  Positioned(
                    bottom: 44,
                    left: 12,
                    child: _GlassTag(label: timerText!),
                  ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      gestureHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CupertinoColors.white.withValues(alpha: 0.72),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
            color: CupertinoColors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Text(
              label,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
