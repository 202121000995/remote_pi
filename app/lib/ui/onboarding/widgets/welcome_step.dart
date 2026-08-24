import 'package:app/l10n/l10n.dart';
import 'package:app/ui/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Onboarding step 1 — welcome. Static, no animations (per plan 14 D2 —
/// "Welcome conservador (sem animações)").
class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(LucideIcons.terminal, color: colors.accent, size: 64),
          const SizedBox(height: 32),
          Text(
            context.l10n.appTitle,
            textAlign: TextAlign.center,
            style: brandTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colors.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.onboardingTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: kMonoFamily,
              fontSize: 13,
              color: colors.muted,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            context.l10n.onboardingBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: kMonoFamily,
              fontSize: 12,
              color: colors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: colors.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            child: Text(
              context.l10n.onboardingGetStarted,
              style: const TextStyle(
                fontFamily: kMonoFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
