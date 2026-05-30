import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../l10n/app_strings.dart';
import '../state/light_controller.dart';
import 'creator_glow_page.dart';
import 'widgets/light_canvas.dart';
import 'widgets/mode_strip.dart';
import 'widgets/palette_sheet.dart';
import 'widgets/timer_sheet.dart';

enum _PanAxis { undecided, horizontal, vertical }

class SoftLightHomePage extends StatefulWidget {
  const SoftLightHomePage({super.key});

  @override
  State<SoftLightHomePage> createState() => _SoftLightHomePageState();
}

class _SoftLightHomePageState extends State<SoftLightHomePage>
    with WidgetsBindingObserver {
  late final LightController _controller;
  _PanAxis _panAxis = _PanAxis.undecided;
  double _panDx = 0;
  double _panDy = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = LightController()..initialize();
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

  void _onLightPanStart(DragStartDetails details) {
    _panAxis = _PanAxis.undecided;
    _panDx = 0;
    _panDy = 0;
  }

  void _onLightPanUpdate(DragUpdateDetails details) {
    _panDx += details.delta.dx;
    _panDy += details.delta.dy;

    if (_panAxis == _PanAxis.undecided) {
      final double distance = _panDx.abs() + _panDy.abs();
      if (distance < 5) {
        return;
      }
      if (_panDx.abs() > _panDy.abs() * 1.15) {
        _panAxis = _PanAxis.horizontal;
      } else if (_panDy.abs() > _panDx.abs() * 1.15) {
        _panAxis = _PanAxis.vertical;
      } else {
        return;
      }
    }

    if (_panAxis == _PanAxis.horizontal) {
      while (_panDx <= -30) {
        _controller.switchMode(1);
        _panDx += 30;
      }
      while (_panDx >= 30) {
        _controller.switchMode(-1);
        _panDx -= 30;
      }
      return;
    }

    _controller.adjustBrightnessByDrag(details.delta.dy);
  }

  void _onLightPanEnd(DragEndDetails details) {
    _panAxis = _PanAxis.undecided;
    _panDx = 0;
    _panDy = 0;
  }

  Future<void> _openPaletteSheet() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return PaletteSheet(
          initialColor: _controller.effectiveColor,
          onApply: _controller.applyManualColor,
          onSave: (Color color) async {
            await _controller.applyManualColor(color);
            final String? name = await _showSavePresetDialog();
            if (!mounted || name == null || name.trim().isEmpty) {
              return;
            }
            await _controller.saveCurrentColorAsPreset(name.trim());
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  Future<void> _openTimerSheet() async {
    final String? remainingText = _formattedRemainingTime();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return TimerSheet(
          options: LightController.timerOptions,
          remainingText: remainingText,
          onSelect: _controller.startTimer,
          onPermanent: _controller.clearTimer,
          onClear: _controller.clearTimer,
        );
      },
    );
  }

  Future<void> _openCreatorGlow() async {
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => const CreatorGlowPage(),
      ),
    );
  }

  Future<String?> _showSavePresetDialog() async {
    final AppStrings s = AppStrings.of(context);
    final TextEditingController controller = TextEditingController(
      text:
          '${s.myLightPrefix} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    return showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(s.saveModeTitle),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CupertinoTextField(
              controller: controller,
              autofocus: true,
              placeholder: s.modeNamePlaceholder,
              maxLength: 18,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(s.cancel),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(s.save),
            ),
          ],
        );
      },
    );
  }

  String? _formattedRemainingTime() {
    final Duration? remaining = _controller.remainingDuration;
    if (remaining == null || remaining == Duration.zero) {
      return null;
    }
    final int minutes = remaining.inMinutes;
    final int seconds = remaining.inSeconds % 60;
    final int hours = minutes ~/ 60;
    final int restMinutes = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${restMinutes.toString().padLeft(2, '0')}m';
    }
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final List<String> builtInNames = s.defaultModeNames;
        final List<Color> builtInCardColors = _controller.builtInPresets
            .asMap()
            .entries
            .map((entry) {
              final int index = entry.key;
              final preset = entry.value;
              final double brightness =
                  _controller.selectedCustomIndex == null &&
                      _controller.selectedBuiltInIndex == index
                  ? _controller.brightness
                  : preset.recommendedBrightness;
              return LightController.renderOutputColor(
                preset.color,
                brightness,
              );
            })
            .toList(growable: false);
        final List<Color> customCardColors = _controller.customPresets
            .asMap()
            .entries
            .map((entry) {
              final int index = entry.key;
              final preset = entry.value;
              final double brightness = _controller.selectedCustomIndex == index
                  ? _controller.brightness
                  : preset.recommendedBrightness;
              return LightController.renderOutputColor(
                preset.color,
                brightness,
              );
            })
            .toList(growable: false);
        final String modeName = _controller.isUsingManualColor
            ? s.manualModeName
            : _controller.currentModeName(context, builtInNames);
        final Color liveColor = _controller.isLightOn
            ? _controller.tonedColor()
            : const Color(0xFF05070D);
        final String? remainingText = _formattedRemainingTime();

        return CupertinoPageScaffold(
          backgroundColor: const Color(0xFF070A11),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF111624),
                  Color(0xFF070A11),
                  Color(0xFF0D0E16),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                        child: Row(
                          children: <Widget>[
                            Text(
                              s.appTitle,
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const Spacer(),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _controller.toggleLight,
                              child: Icon(
                                _controller.isLightOn
                                    ? CupertinoIcons.lightbulb_fill
                                    : CupertinoIcons.lightbulb,
                                color: const Color(0xFF8DBAFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: LightCanvas(
                          color: liveColor,
                          brightnessText: s.lightBrightnessPercent(
                            (100 * _controller.brightness).round(),
                          ),
                          modeName: modeName,
                          gestureHint: s.gestureHint,
                          timerText: remainingText == null
                              ? null
                              : s.timerEndsInShort(remainingText),
                          onPanStart: _onLightPanStart,
                          onPanUpdate: _onLightPanUpdate,
                          onPanEnd: _onLightPanEnd,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        flex: 5,
                        child: ModeStrip(
                          builtInNames: builtInNames,
                          builtInPresets: _controller.builtInPresets,
                          builtInCardColors: builtInCardColors,
                          customPresets: _controller.customPresets,
                          customCardColors: customCardColors,
                          selectedBuiltInIndex:
                              _controller.selectedBuiltInIndex,
                          selectedCustomIndex: _controller.selectedCustomIndex,
                          isLoading: _controller.isLoading,
                          timerStatus: remainingText == null
                              ? s.permanentTimer
                              : s.timerEndsInShort(remainingText),
                          screenBrightness: _controller.screenBrightness,
                          supportsScreenBrightness: !kIsWeb,
                          onSelectBuiltIn: _controller.selectBuiltInPreset,
                          onSelectCustom: _controller.selectCustomPreset,
                          onDeleteCustom: _controller.deleteCustomPreset,
                          onOpenCreator: _openCreatorGlow,
                          onOpenTimer: _openTimerSheet,
                          onOpenPalette: _openPaletteSheet,
                          onSetScreenBrightness:
                              _controller.setScreenBrightness,
                        ),
                      ),
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
