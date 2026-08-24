import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Forced UI locale. The running app always shows Chinese unless a test
/// overrides [MaterialApp.locale].
const Locale kAppLocale = Locale('zh');

/// Localizations for widgets. Falls back to Chinese when the tree has no
/// [AppLocalizations] delegate (bare widget tests).
extension L10nX on BuildContext {
  AppLocalizations get l10n {
    final found = Localizations.of<AppLocalizations>(this, AppLocalizations);
    return found ?? lookupAppLocalizations(kAppLocale);
  }
}

/// Localizations for ViewModels / non-widget code. Always the app default.
AppLocalizations get appL10n => lookupAppLocalizations(kAppLocale);

/// Maps repository action-failure codes to user-facing copy.
/// Unknown / Pi-sent messages pass through unchanged.
String localizeActionError(String raw) {
  return switch (raw) {
    'offline' => appL10n.actionOffline,
    'disconnected' => appL10n.actionDisconnected,
    'timeout' => appL10n.actionTimeout,
    'action failed' || 'disposed' => appL10n.actionFailed,
    _ => raw,
  };
}
