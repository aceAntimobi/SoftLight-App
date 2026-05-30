import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_strings.dart';
import '../../domain/timer_option.dart';

class TimerSheet extends StatelessWidget {
  const TimerSheet({
    super.key,
    required this.options,
    required this.remainingText,
    required this.onSelect,
    required this.onPermanent,
    required this.onClear,
  });

  final List<TimerOption> options;
  final String? remainingText;
  final ValueChanged<int> onSelect;
  final VoidCallback onPermanent;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = AppStrings.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
        child: Container(
          color: const Color(0xE6171E31),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 56,
                  height: 6,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  s.timerTitle,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (remainingText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      s.timerEndsIn(remainingText!),
                      style: TextStyle(
                        color: CupertinoColors.white.withValues(alpha: 0.82),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: const Color(0xFF355C97),
                      borderRadius: BorderRadius.circular(14),
                      onPressed: () {
                        onPermanent();
                        Navigator.of(context).pop();
                      },
                      child: Text(s.permanentTimer),
                    ),
                    ...options.map(
                      (TimerOption option) => CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        color: CupertinoColors.systemGrey.withValues(
                          alpha: 0.22,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () {
                          onSelect(option.minutes);
                          Navigator.of(context).pop();
                        },
                        child: Text(s.timerMinutes(option.minutes)),
                      ),
                    ),
                  ],
                ),
                if (remainingText != null) ...<Widget>[
                  const SizedBox(height: 12),
                  CupertinoButton(
                    onPressed: () {
                      onClear();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      s.cancelTimer,
                      style: const TextStyle(color: Color(0xFF8DBAFF)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
