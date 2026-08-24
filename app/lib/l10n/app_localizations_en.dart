// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Remote Pi';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonPair => 'Pair';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get onboardingTagline => 'Control your Pi agent from anywhere';

  @override
  String get onboardingBody =>
      'Pair this app with the Pi running on your computer (Mac, Linux, or Windows) so you can chat with it even when you\'re away from home.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingChooseRelay => 'Choose a relay';

  @override
  String get onboardingRelaySubtitle => 'Where the app and your PC meet.';

  @override
  String get onboardingRecommended => 'recommended';

  @override
  String get onboardingCustomRelay => 'Use my own server';

  @override
  String get onboardingCustomRelayDesc => 'Self-hosted. Best privacy.';

  @override
  String get onboardingCommunityRelay => 'Community relay';

  @override
  String get onboardingCommunityRelayDesc => 'Hosted by us. Quick to start.';

  @override
  String get onboardingConnectDevice => 'Connect to your device';

  @override
  String get onboardingPairInstructions =>
      'On your computer (Mac, Linux, or Windows), open Pi and run:';

  @override
  String get onboardingScanQrHint => 'Scan the QR code that appears:';

  @override
  String get onboardingCantScan => 'Can\'t scan? Paste code instead';

  @override
  String get onboardingScanLater => 'Scan later';

  @override
  String get onboardingPairing => 'Pairing…';

  @override
  String get onboardingPaired => 'Paired!';

  @override
  String get pairingTitle => 'Pair device';

  @override
  String get pairingPointCamera =>
      'Point camera at the QR shown in your Mac terminal';

  @override
  String pairingConnectingTo(String name) {
    return 'Connecting to $name…';
  }

  @override
  String get pairingPasteTitle => 'Paste pairing code';

  @override
  String get pairingPasteBody =>
      'Can\'t scan the QR? Paste the text from your Mac terminal below. It starts with remotepi://pair?…';

  @override
  String get pairingPasteFromClipboard => 'Paste from clipboard';

  @override
  String get pairingNameThisPc => 'Name this PC';

  @override
  String get pairingNameThisPcHint =>
      'Pick a label so this Mac is easy to spot in your list. You can change it later from the home screen.';

  @override
  String get pairingQrExpired => 'QR expired — generate a new one on your Mac';

  @override
  String get pairingQrUsed => 'QR already used — generate a new one';

  @override
  String get pairingQrUnknown =>
      'QR not recognized by Mac — re-run /remote-pi pair';

  @override
  String get pairingTimeout =>
      'Timed out — make sure /remote-pi is running on your Mac';

  @override
  String pairingRelayMismatch(String qrUrl, String currentUrl) {
    return 'QR points to \"$qrUrl\", but the app is configured for \"$currentUrl\". Update the relay in settings or ask the Pi to generate a new QR.';
  }

  @override
  String pairingUnknownResponse(String type) {
    return 'Unknown response type: $type';
  }

  @override
  String get pairingAndroidDevice => 'Android device';

  @override
  String get pairingMobileDevice => 'Mobile';

  @override
  String get relayUrlInvalidScheme =>
      'Use http:// or https:// (not ws:// or wss:// — the app converts to WebSocket automatically).';

  @override
  String get relayUrlInvalidGeneric =>
      'Enter a valid URL starting with https:// (or http:// for local relays).';

  @override
  String get homeConnected => 'Connected';

  @override
  String get homeAwaitingPairing => 'Awaiting pairing';

  @override
  String get homeOffline => 'Offline';

  @override
  String get homeRelay => 'Relay';

  @override
  String get homeFilterAll => 'All';

  @override
  String get homeFilterOnline => 'Online';

  @override
  String get homeFilterOffline => 'Offline';

  @override
  String get homeNothingHere => 'Nothing here…';

  @override
  String get homeNothingHereSubtitle =>
      'When a paired Pi opens a session, it shows up here.';

  @override
  String get homeNoPairings => 'No pairings yet';

  @override
  String get homeNoPairingsHint => 'Scan a QR from your Mac to start.';

  @override
  String get homeScanQr => 'Scan QR';

  @override
  String get homeNoSessionsOnline => 'No sessions online';

  @override
  String get homeNoSessionsOnlineHint =>
      'Live sessions appear here when a paired Pi is active.';

  @override
  String get homeNoSessionsOffline => 'No offline sessions';

  @override
  String get homeNoSessionsOfflineHint =>
      'Sessions you’ve seen before that aren’t live show up here.';

  @override
  String get homeRenameSession => 'Rename session';

  @override
  String get homeDeleteSessionLocal => 'Delete session (local only)';

  @override
  String get homeDeleteSessionOnlyOffline =>
      'Only available when the room is offline';

  @override
  String get homeDeleteSessionTitle => 'Delete session?';

  @override
  String get homeDeleteSessionBody =>
      'Removes locally only. If the session comes back online on the Pi, it reappears in the list.';

  @override
  String homeLastPaired(String time) {
    return 'Last paired: $time';
  }

  @override
  String get homeJustNow => 'just now';

  @override
  String homeMinutesAgo(int n) {
    return '${n}m ago';
  }

  @override
  String homeHoursAgo(int n) {
    return '${n}h ago';
  }

  @override
  String homeDaysAgo(int n) {
    return '${n}d ago';
  }

  @override
  String get homeSession => 'Session';

  @override
  String get chatWorking => 'working…';

  @override
  String get chatReconnecting => 'reconnecting…';

  @override
  String get chatOnline => 'online';

  @override
  String get chatOffline => 'offline';

  @override
  String get chatSessionInfo => 'Session info';

  @override
  String get chatInfoName => 'Name';

  @override
  String get chatInfoPath => 'Path';

  @override
  String get chatInfoOwner => 'Owner';

  @override
  String get chatInfoModel => 'Model';

  @override
  String get chatInfoRoom => 'Room';

  @override
  String get chatInfoPaired => 'Paired';

  @override
  String get chatNoActiveDevice => 'No active device';

  @override
  String get chatConnecting => 'Connecting…';

  @override
  String get chatRePair => 'Re-pair';

  @override
  String get chatNothingHere => 'Nothing here';

  @override
  String get chatPairingRevoked =>
      'Pairing revoked by Mac — re-pair to continue';

  @override
  String get chatCameraPermission =>
      'Camera access is off — enable it in Settings to attach a photo.';

  @override
  String get chatAttachFailed => 'Couldn\'t attach that image.';

  @override
  String get chatHoldMic => 'Hold the mic to talk';

  @override
  String get chatMicPermission =>
      'Microphone access is off — enable it in Settings to dictate.';

  @override
  String get chatHintOffline => 'Offline…';

  @override
  String get chatHintSteer => 'Steer current response…';

  @override
  String get chatHintCaption => 'Add a caption…';

  @override
  String get chatHintSend => 'Send a message…';

  @override
  String get chatQueuedEdit => 'Queued. Tap to edit.';

  @override
  String get chatQueuedFollowup => 'Queued follow-up.';

  @override
  String get chatClearQueued => 'Clear queued message';

  @override
  String get chatAttachImage => 'Attach image';

  @override
  String get chatQuickActions => 'Quick actions';

  @override
  String get chatTranscribing => 'transcribing…';

  @override
  String get chatSteering => 'steering…';

  @override
  String get chatSending => 'sending…';

  @override
  String get chatNotDelivered => 'not delivered';

  @override
  String get chatContextCompacted => 'Context compacted';

  @override
  String chatTokensApprox(int count) {
    return '~$count tokens';
  }

  @override
  String get chatSelectSession => 'Select a session';

  @override
  String get chatSelectSessionHint =>
      'Pick a session on the left to open its chat.';

  @override
  String get chatCopyCode => 'Copy code';

  @override
  String chatCouldntOpenUrl(String url) {
    return 'Couldn\'t open $url';
  }

  @override
  String get chatSlideToCancel => 'slide to cancel';

  @override
  String get chatReleaseToCancel => 'release to cancel';

  @override
  String get chatCamera => 'Camera';

  @override
  String get chatPhotoLibrary => 'Photo Library';

  @override
  String get chatClarificationNeeded => 'Clarification needed';

  @override
  String get chatTypeYourOwn => 'Type your own…';

  @override
  String get chatPleaseConfirm => 'Please confirm.';

  @override
  String get chatNoResponseFromPi =>
      'No response from Pi yet — retry or cancel.';

  @override
  String get chatRequired => 'required';

  @override
  String get chatMulti => 'multi';

  @override
  String get chatCode => 'code';

  @override
  String get chatFailedToLoadModels => 'Failed to load models';

  @override
  String get chatChooseModel => 'Choose a model';

  @override
  String get chatNoModels => 'No models available';

  @override
  String get chatCompactContext => 'Compact context';

  @override
  String get chatCompactSubtitle => 'Summarize old turns to free room.';

  @override
  String get chatNewSession => 'New session';

  @override
  String get chatNewSessionSubtitle => 'Clears the conversation on the Pi.';

  @override
  String get chatNewSessionConfirmTitle => 'Start a new session?';

  @override
  String get chatNewSessionConfirmBody =>
      'This clears the Pi-side conversation history. The current thread cannot be resumed.';

  @override
  String get chatStartNew => 'Start new';

  @override
  String get chatSwitchingModel => 'Switching…';

  @override
  String get chatModel => 'Model';

  @override
  String get chatThinking => 'Thinking';

  @override
  String get chatThinkingOff => 'off';

  @override
  String get chatThinkingMin => 'min';

  @override
  String get chatThinkingLow => 'low';

  @override
  String get chatThinkingMed => 'med';

  @override
  String get chatThinkingHigh => 'high';

  @override
  String get chatThinkingXhigh => 'x';

  @override
  String get chatReasoning => 'reasoning';

  @override
  String get chatProviderAll => 'all';

  @override
  String get chatAnswerNotAccepted => 'Answer was not accepted.';

  @override
  String get chatNotConnected =>
      'Not connected — check the link to Pi and retry.';

  @override
  String get toolAwaiting => 'AWAITING';

  @override
  String get toolRunning => 'RUNNING';

  @override
  String get toolDone => 'DONE';

  @override
  String get toolFailed => 'FAILED';

  @override
  String get toolDenied => 'DENIED';

  @override
  String get toolExpired => 'EXPIRED';

  @override
  String get toolWaitingApproval => 'Waiting for approval…';

  @override
  String get toolRunningEllipsis => '⏳ Running…';

  @override
  String get toolOutcomeDone => '✓ Done';

  @override
  String toolOutcomeFailed(String error) {
    return '✗ $error';
  }

  @override
  String toolOutcomeDenied(String error) {
    return '✗ $error';
  }

  @override
  String get toolOutcomeExpired => '✗ Expired';

  @override
  String get toolAllow => 'Allow';

  @override
  String get toolAllowOnce => 'Allow once';

  @override
  String get toolAllowSession => 'Allow this session';

  @override
  String get toolAllowAlways => 'Always allow';

  @override
  String get toolDeny => 'Deny';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPairings => 'Pairings';

  @override
  String get settingsAddPairing => 'Add new pairing';

  @override
  String get settingsRelayUpdated => 'Relay updated';

  @override
  String get settingsRelayUrlRequired => 'Enter a relay URL.';

  @override
  String get actionOffline => 'Currently offline';

  @override
  String get actionDisconnected => 'Disconnected';

  @override
  String get actionTimeout => 'Timed out';

  @override
  String get actionFailed => 'Action failed';

  @override
  String settingsCurrentRelay(String url) {
    return 'Current: $url';
  }

  @override
  String get settingsUseDefaultRelay => 'Use default Relay';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsTextSize => 'Text size';

  @override
  String get settingsFontSmall => 'Small';

  @override
  String get settingsFontDefault => 'Default';

  @override
  String get settingsFontLarge => 'Large';

  @override
  String get settingsFontXl => 'XL';

  @override
  String get settingsHideToolCalls => 'Hide tool calls in chat';

  @override
  String get settingsHideToolCallsSubtitle =>
      'Only show your messages and the assistant replies.';

  @override
  String get settingsTapPlusToPair => 'Tap + to pair a new Mac.';

  @override
  String get settingsNickname => 'Nickname';

  @override
  String get settingsNicknameLocalOnly =>
      'Local only — the Mac is not notified.';

  @override
  String settingsNicknameDefault(String name) {
    return 'Default: $name';
  }

  @override
  String get settingsRemoveNickname => 'Remove nickname';

  @override
  String settingsRevokeTitle(String name) {
    return 'Revoke \"$name\"?';
  }

  @override
  String get settingsRevokeBody =>
      'You\'ll need to pair again from the PC or Mac to reconnect.';

  @override
  String get settingsRevoke => 'Revoke';

  @override
  String get settingsEditNickname => 'Edit nickname';

  @override
  String get settingsNoPairingsHint => 'Tap + to pair a new Mac.';

  @override
  String get updateAvailable => 'Update available';

  @override
  String updateTapToDownload(String version) {
    return 'v$version · tap to download the APK';
  }

  @override
  String get syncRequired => 'Sync required';

  @override
  String get syncWhyIos =>
      'Remote Pi keeps your Ed25519 owner key in iCloud Keychain so you can switch iPhones or pair your iPad without scanning a new QR.';

  @override
  String get syncWhyAndroid =>
      'Remote Pi keeps your Ed25519 owner key in Google Block Store so you can restore it on a new device through Google Backup without losing your paired Pis.';

  @override
  String get syncToEnable => 'To enable, on this device:';

  @override
  String get syncCheckAgain => 'Check again';

  @override
  String get syncAndroidLock => 'Set up a screen lock';

  @override
  String get syncAndroidLockPath => 'Settings › Security › Screen lock';

  @override
  String get syncAndroidLockNote =>
      'PIN, pattern or biometrics — required by Block Store.';

  @override
  String get syncAndroidBackup => 'Turn on Google Backup';

  @override
  String get syncAndroidBackupPath =>
      'Settings › System › Backup\n(Samsung: Settings › Accounts and backup › Backup data)';

  @override
  String get syncAndroidGoogle => 'Sign in to a Google account';

  @override
  String get syncAndroidGooglePath =>
      'Settings › Passwords & accounts › Add account › Google';

  @override
  String get syncIosIcloud => 'Sign in to iCloud';

  @override
  String get syncIosIcloudPath => 'Settings › [your name]';

  @override
  String get syncIosIcloudNote =>
      'If you see \"Sign in to your iPhone\" at the top, tap it.';

  @override
  String get syncIosKeychain => 'Turn on iCloud Keychain';

  @override
  String get syncIosKeychainPath =>
      'Settings › [your name] › iCloud › Passwords and Keychain';

  @override
  String get syncIosKeychainNote => 'Toggle \"Sync this iPhone\" on.';
}
