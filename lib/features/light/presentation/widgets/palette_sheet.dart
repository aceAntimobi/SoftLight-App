import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../l10n/app_strings.dart';

class PaletteSheet extends StatefulWidget {
  const PaletteSheet({
    super.key,
    required this.initialColor,
    required this.onApply,
    required this.onSave,
  });

  final Color initialColor;
  final ValueChanged<Color> onApply;
  final ValueChanged<Color> onSave;

  @override
  State<PaletteSheet> createState() => _PaletteSheetState();
}

class _PaletteSheetState extends State<PaletteSheet> {
  late Color _draftColor = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.72,
          color: const Color(0xCC0E111A),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          child: SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 6,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  s.manualPaletteTitle,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ColorPicker(
                          pickerColor: _draftColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              _draftColor = color;
                            });
                          },
                          enableAlpha: false,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsvWithHue,
                          pickerAreaBorderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          labelTypes: const <ColorLabelType>[],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: CupertinoColors.systemGrey.withValues(
                          alpha: 0.25,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(s.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: const Color(0xFF4D95FF),
                        onPressed: () {
                          widget.onApply(_draftColor);
                          Navigator.of(context).pop();
                        },
                        child: Text(s.apply),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  onPressed: () {
                    widget.onSave(_draftColor);
                  },
                  child: Text(
                    s.saveAsMyMode,
                    style: const TextStyle(
                      color: Color(0xFF8DBAFF),
                      fontWeight: FontWeight.w600,
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
