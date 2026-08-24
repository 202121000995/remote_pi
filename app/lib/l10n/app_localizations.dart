import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'Remote Pi'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// No description provided for @commonTryAgain.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonTryAgain;

  /// No description provided for @commonSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get commonSettings;

  /// No description provided for @commonContinue.
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get commonContinue;

  /// No description provided for @commonSkip.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get commonSkip;

  /// No description provided for @commonDelete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get commonDelete;

  /// No description provided for @commonSubmit.
  ///
  /// In zh, this message translates to:
  /// **'提交'**
  String get commonSubmit;

  /// No description provided for @commonPair.
  ///
  /// In zh, this message translates to:
  /// **'配对'**
  String get commonPair;

  /// No description provided for @commonDismiss.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get commonDismiss;

  /// No description provided for @commonRefresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get commonRefresh;

  /// No description provided for @onboardingTagline.
  ///
  /// In zh, this message translates to:
  /// **'随时随地控制你的 Pi 智能体'**
  String get onboardingTagline;

  /// No description provided for @onboardingBody.
  ///
  /// In zh, this message translates to:
  /// **'把这个 App 和电脑上运行的 Pi 配对（Mac、Linux 或 Windows），出门也能继续对话。'**
  String get onboardingBody;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingChooseRelay.
  ///
  /// In zh, this message translates to:
  /// **'选择中继'**
  String get onboardingChooseRelay;

  /// No description provided for @onboardingRelaySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'App 和电脑在这里会合。'**
  String get onboardingRelaySubtitle;

  /// No description provided for @onboardingRecommended.
  ///
  /// In zh, this message translates to:
  /// **'推荐'**
  String get onboardingRecommended;

  /// No description provided for @onboardingCustomRelay.
  ///
  /// In zh, this message translates to:
  /// **'使用自己的服务器'**
  String get onboardingCustomRelay;

  /// No description provided for @onboardingCustomRelayDesc.
  ///
  /// In zh, this message translates to:
  /// **'自托管，隐私最好。'**
  String get onboardingCustomRelayDesc;

  /// No description provided for @onboardingCommunityRelay.
  ///
  /// In zh, this message translates to:
  /// **'社区中继'**
  String get onboardingCommunityRelay;

  /// No description provided for @onboardingCommunityRelayDesc.
  ///
  /// In zh, this message translates to:
  /// **'我们托管，马上就能用。'**
  String get onboardingCommunityRelayDesc;

  /// No description provided for @onboardingConnectDevice.
  ///
  /// In zh, this message translates to:
  /// **'连接设备'**
  String get onboardingConnectDevice;

  /// No description provided for @onboardingPairInstructions.
  ///
  /// In zh, this message translates to:
  /// **'在电脑上（Mac、Linux 或 Windows）打开 Pi，然后运行：'**
  String get onboardingPairInstructions;

  /// No description provided for @onboardingScanQrHint.
  ///
  /// In zh, this message translates to:
  /// **'扫描出现的二维码：'**
  String get onboardingScanQrHint;

  /// No description provided for @onboardingCantScan.
  ///
  /// In zh, this message translates to:
  /// **'扫不了？改为粘贴配对码'**
  String get onboardingCantScan;

  /// No description provided for @onboardingScanLater.
  ///
  /// In zh, this message translates to:
  /// **'稍后再扫'**
  String get onboardingScanLater;

  /// No description provided for @onboardingPairing.
  ///
  /// In zh, this message translates to:
  /// **'正在配对…'**
  String get onboardingPairing;

  /// No description provided for @onboardingPaired.
  ///
  /// In zh, this message translates to:
  /// **'已配对！'**
  String get onboardingPaired;

  /// No description provided for @pairingTitle.
  ///
  /// In zh, this message translates to:
  /// **'配对设备'**
  String get pairingTitle;

  /// No description provided for @pairingPointCamera.
  ///
  /// In zh, this message translates to:
  /// **'将相机对准终端里显示的二维码'**
  String get pairingPointCamera;

  /// No description provided for @pairingConnectingTo.
  ///
  /// In zh, this message translates to:
  /// **'正在连接 {name}…'**
  String pairingConnectingTo(String name);

  /// No description provided for @pairingPasteTitle.
  ///
  /// In zh, this message translates to:
  /// **'粘贴配对码'**
  String get pairingPasteTitle;

  /// No description provided for @pairingPasteBody.
  ///
  /// In zh, this message translates to:
  /// **'扫不了二维码？把电脑终端里的文本粘到下面。以 remotepi://pair? 开头。'**
  String get pairingPasteBody;

  /// No description provided for @pairingPasteFromClipboard.
  ///
  /// In zh, this message translates to:
  /// **'从剪贴板粘贴'**
  String get pairingPasteFromClipboard;

  /// No description provided for @pairingNameThisPc.
  ///
  /// In zh, this message translates to:
  /// **'给这台电脑起名'**
  String get pairingNameThisPc;

  /// No description provided for @pairingNameThisPcHint.
  ///
  /// In zh, this message translates to:
  /// **'起个好认的名字，方便在列表里找到。之后可以在主页改。'**
  String get pairingNameThisPcHint;

  /// No description provided for @pairingQrExpired.
  ///
  /// In zh, this message translates to:
  /// **'二维码已过期 — 请在电脑上重新生成'**
  String get pairingQrExpired;

  /// No description provided for @pairingQrUsed.
  ///
  /// In zh, this message translates to:
  /// **'二维码已用过 — 请重新生成'**
  String get pairingQrUsed;

  /// No description provided for @pairingQrUnknown.
  ///
  /// In zh, this message translates to:
  /// **'电脑无法识别这个二维码 — 请重新运行 /remote-pi pair'**
  String get pairingQrUnknown;

  /// No description provided for @pairingTimeout.
  ///
  /// In zh, this message translates to:
  /// **'超时了 — 请确认电脑上正在运行 /remote-pi'**
  String get pairingTimeout;

  /// No description provided for @pairingRelayMismatch.
  ///
  /// In zh, this message translates to:
  /// **'二维码指向“{qrUrl}”，但 App 当前使用“{currentUrl}”。请在设置里改中继，或让 Pi 重新生成二维码。'**
  String pairingRelayMismatch(String qrUrl, String currentUrl);

  /// No description provided for @pairingUnknownResponse.
  ///
  /// In zh, this message translates to:
  /// **'未知响应类型：{type}'**
  String pairingUnknownResponse(String type);

  /// No description provided for @pairingAndroidDevice.
  ///
  /// In zh, this message translates to:
  /// **'安卓设备'**
  String get pairingAndroidDevice;

  /// No description provided for @pairingMobileDevice.
  ///
  /// In zh, this message translates to:
  /// **'手机'**
  String get pairingMobileDevice;

  /// No description provided for @relayUrlInvalidScheme.
  ///
  /// In zh, this message translates to:
  /// **'请用 http:// 或 https://（不要用 ws:// 或 wss:// — App 会自动转成 WebSocket）。'**
  String get relayUrlInvalidScheme;

  /// No description provided for @relayUrlInvalidGeneric.
  ///
  /// In zh, this message translates to:
  /// **'请输入以 https:// 开头的有效网址（本地中继可以用 http://）。'**
  String get relayUrlInvalidGeneric;

  /// No description provided for @homeConnected.
  ///
  /// In zh, this message translates to:
  /// **'已连接'**
  String get homeConnected;

  /// No description provided for @homeAwaitingPairing.
  ///
  /// In zh, this message translates to:
  /// **'等待配对'**
  String get homeAwaitingPairing;

  /// No description provided for @homeOffline.
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get homeOffline;

  /// No description provided for @homeRelay.
  ///
  /// In zh, this message translates to:
  /// **'中继'**
  String get homeRelay;

  /// No description provided for @homeFilterAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get homeFilterAll;

  /// No description provided for @homeFilterOnline.
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get homeFilterOnline;

  /// No description provided for @homeFilterOffline.
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get homeFilterOffline;

  /// No description provided for @homeNothingHere.
  ///
  /// In zh, this message translates to:
  /// **'这里还是空的…'**
  String get homeNothingHere;

  /// No description provided for @homeNothingHereSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'配对的 Pi 打开会话后，会出现在这里。'**
  String get homeNothingHereSubtitle;

  /// No description provided for @homeNoPairings.
  ///
  /// In zh, this message translates to:
  /// **'还没有配对'**
  String get homeNoPairings;

  /// No description provided for @homeNoPairingsHint.
  ///
  /// In zh, this message translates to:
  /// **'扫描电脑上的二维码即可开始。'**
  String get homeNoPairingsHint;

  /// No description provided for @homeScanQr.
  ///
  /// In zh, this message translates to:
  /// **'扫描二维码'**
  String get homeScanQr;

  /// No description provided for @homeNoSessionsOnline.
  ///
  /// In zh, this message translates to:
  /// **'没有在线会话'**
  String get homeNoSessionsOnline;

  /// No description provided for @homeNoSessionsOnlineHint.
  ///
  /// In zh, this message translates to:
  /// **'配对的 Pi 活跃时，实时会话会出现在这里。'**
  String get homeNoSessionsOnlineHint;

  /// No description provided for @homeNoSessionsOffline.
  ///
  /// In zh, this message translates to:
  /// **'没有离线会话'**
  String get homeNoSessionsOffline;

  /// No description provided for @homeNoSessionsOfflineHint.
  ///
  /// In zh, this message translates to:
  /// **'以前见过、现在不在线的会话会出现在这里。'**
  String get homeNoSessionsOfflineHint;

  /// No description provided for @homeRenameSession.
  ///
  /// In zh, this message translates to:
  /// **'重命名会话'**
  String get homeRenameSession;

  /// No description provided for @homeDeleteSessionLocal.
  ///
  /// In zh, this message translates to:
  /// **'删除会话（仅本地）'**
  String get homeDeleteSessionLocal;

  /// No description provided for @homeDeleteSessionOnlyOffline.
  ///
  /// In zh, this message translates to:
  /// **'仅在会话离线时可用'**
  String get homeDeleteSessionOnlyOffline;

  /// No description provided for @homeDeleteSessionTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除会话？'**
  String get homeDeleteSessionTitle;

  /// No description provided for @homeDeleteSessionBody.
  ///
  /// In zh, this message translates to:
  /// **'只从本机移除。如果 Pi 上这个会话重新上线，它会再出现在列表里。'**
  String get homeDeleteSessionBody;

  /// No description provided for @homeLastPaired.
  ///
  /// In zh, this message translates to:
  /// **'上次配对：{time}'**
  String homeLastPaired(String time);

  /// No description provided for @homeJustNow.
  ///
  /// In zh, this message translates to:
  /// **'刚刚'**
  String get homeJustNow;

  /// No description provided for @homeMinutesAgo.
  ///
  /// In zh, this message translates to:
  /// **'{n} 分钟前'**
  String homeMinutesAgo(int n);

  /// No description provided for @homeHoursAgo.
  ///
  /// In zh, this message translates to:
  /// **'{n} 小时前'**
  String homeHoursAgo(int n);

  /// No description provided for @homeDaysAgo.
  ///
  /// In zh, this message translates to:
  /// **'{n} 天前'**
  String homeDaysAgo(int n);

  /// No description provided for @homeSession.
  ///
  /// In zh, this message translates to:
  /// **'会话'**
  String get homeSession;

  /// No description provided for @chatWorking.
  ///
  /// In zh, this message translates to:
  /// **'工作中…'**
  String get chatWorking;

  /// No description provided for @chatReconnecting.
  ///
  /// In zh, this message translates to:
  /// **'重连中…'**
  String get chatReconnecting;

  /// No description provided for @chatOnline.
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get chatOnline;

  /// No description provided for @chatOffline.
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get chatOffline;

  /// No description provided for @chatSessionInfo.
  ///
  /// In zh, this message translates to:
  /// **'会话信息'**
  String get chatSessionInfo;

  /// No description provided for @chatInfoName.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get chatInfoName;

  /// No description provided for @chatInfoPath.
  ///
  /// In zh, this message translates to:
  /// **'路径'**
  String get chatInfoPath;

  /// No description provided for @chatInfoOwner.
  ///
  /// In zh, this message translates to:
  /// **'设备'**
  String get chatInfoOwner;

  /// No description provided for @chatInfoModel.
  ///
  /// In zh, this message translates to:
  /// **'模型'**
  String get chatInfoModel;

  /// No description provided for @chatInfoRoom.
  ///
  /// In zh, this message translates to:
  /// **'房间'**
  String get chatInfoRoom;

  /// No description provided for @chatInfoPaired.
  ///
  /// In zh, this message translates to:
  /// **'配对时间'**
  String get chatInfoPaired;

  /// No description provided for @chatNoActiveDevice.
  ///
  /// In zh, this message translates to:
  /// **'没有活跃设备'**
  String get chatNoActiveDevice;

  /// No description provided for @chatConnecting.
  ///
  /// In zh, this message translates to:
  /// **'正在连接…'**
  String get chatConnecting;

  /// No description provided for @chatRePair.
  ///
  /// In zh, this message translates to:
  /// **'重新配对'**
  String get chatRePair;

  /// No description provided for @chatNothingHere.
  ///
  /// In zh, this message translates to:
  /// **'这里还是空的'**
  String get chatNothingHere;

  /// No description provided for @chatPairingRevoked.
  ///
  /// In zh, this message translates to:
  /// **'电脑已撤销配对 — 重新配对后才能继续'**
  String get chatPairingRevoked;

  /// No description provided for @chatCameraPermission.
  ///
  /// In zh, this message translates to:
  /// **'相机权限已关闭 — 请到设置里打开，才能附加照片。'**
  String get chatCameraPermission;

  /// No description provided for @chatAttachFailed.
  ///
  /// In zh, this message translates to:
  /// **'这张图片没法附加。'**
  String get chatAttachFailed;

  /// No description provided for @chatHoldMic.
  ///
  /// In zh, this message translates to:
  /// **'按住麦克风说话'**
  String get chatHoldMic;

  /// No description provided for @chatMicPermission.
  ///
  /// In zh, this message translates to:
  /// **'麦克风权限已关闭 — 请到设置里打开，才能语音输入。'**
  String get chatMicPermission;

  /// No description provided for @chatHintOffline.
  ///
  /// In zh, this message translates to:
  /// **'离线…'**
  String get chatHintOffline;

  /// No description provided for @chatHintSteer.
  ///
  /// In zh, this message translates to:
  /// **'给当前回复加点指示…'**
  String get chatHintSteer;

  /// No description provided for @chatHintCaption.
  ///
  /// In zh, this message translates to:
  /// **'加个说明…'**
  String get chatHintCaption;

  /// No description provided for @chatHintSend.
  ///
  /// In zh, this message translates to:
  /// **'发一条消息…'**
  String get chatHintSend;

  /// No description provided for @chatQueuedEdit.
  ///
  /// In zh, this message translates to:
  /// **'已排队。点一下可改。'**
  String get chatQueuedEdit;

  /// No description provided for @chatQueuedFollowup.
  ///
  /// In zh, this message translates to:
  /// **'已排队的后续消息。'**
  String get chatQueuedFollowup;

  /// No description provided for @chatClearQueued.
  ///
  /// In zh, this message translates to:
  /// **'清除排队消息'**
  String get chatClearQueued;

  /// No description provided for @chatAttachImage.
  ///
  /// In zh, this message translates to:
  /// **'附加图片'**
  String get chatAttachImage;

  /// No description provided for @chatQuickActions.
  ///
  /// In zh, this message translates to:
  /// **'快捷操作'**
  String get chatQuickActions;

  /// No description provided for @chatTranscribing.
  ///
  /// In zh, this message translates to:
  /// **'识别中…'**
  String get chatTranscribing;

  /// No description provided for @chatSteering.
  ///
  /// In zh, this message translates to:
  /// **'引导中…'**
  String get chatSteering;

  /// No description provided for @chatSending.
  ///
  /// In zh, this message translates to:
  /// **'发送中…'**
  String get chatSending;

  /// No description provided for @chatNotDelivered.
  ///
  /// In zh, this message translates to:
  /// **'未送达'**
  String get chatNotDelivered;

  /// No description provided for @chatContextCompacted.
  ///
  /// In zh, this message translates to:
  /// **'上下文已压缩'**
  String get chatContextCompacted;

  /// No description provided for @chatTokensApprox.
  ///
  /// In zh, this message translates to:
  /// **'约 {count} tokens'**
  String chatTokensApprox(int count);

  /// No description provided for @chatSelectSession.
  ///
  /// In zh, this message translates to:
  /// **'选择一个会话'**
  String get chatSelectSession;

  /// No description provided for @chatSelectSessionHint.
  ///
  /// In zh, this message translates to:
  /// **'在左侧点一个会话，打开对应聊天。'**
  String get chatSelectSessionHint;

  /// No description provided for @chatCopyCode.
  ///
  /// In zh, this message translates to:
  /// **'复制代码'**
  String get chatCopyCode;

  /// No description provided for @chatCouldntOpenUrl.
  ///
  /// In zh, this message translates to:
  /// **'打不开 {url}'**
  String chatCouldntOpenUrl(String url);

  /// No description provided for @chatSlideToCancel.
  ///
  /// In zh, this message translates to:
  /// **'左滑取消'**
  String get chatSlideToCancel;

  /// No description provided for @chatReleaseToCancel.
  ///
  /// In zh, this message translates to:
  /// **'松手取消'**
  String get chatReleaseToCancel;

  /// No description provided for @chatCamera.
  ///
  /// In zh, this message translates to:
  /// **'相机'**
  String get chatCamera;

  /// No description provided for @chatPhotoLibrary.
  ///
  /// In zh, this message translates to:
  /// **'相册'**
  String get chatPhotoLibrary;

  /// No description provided for @chatClarificationNeeded.
  ///
  /// In zh, this message translates to:
  /// **'需要你确认一下'**
  String get chatClarificationNeeded;

  /// No description provided for @chatTypeYourOwn.
  ///
  /// In zh, this message translates to:
  /// **'自己输入…'**
  String get chatTypeYourOwn;

  /// No description provided for @chatPleaseConfirm.
  ///
  /// In zh, this message translates to:
  /// **'请确认。'**
  String get chatPleaseConfirm;

  /// No description provided for @chatNoResponseFromPi.
  ///
  /// In zh, this message translates to:
  /// **'Pi 还没回应 — 重试或取消。'**
  String get chatNoResponseFromPi;

  /// No description provided for @chatRequired.
  ///
  /// In zh, this message translates to:
  /// **'必填'**
  String get chatRequired;

  /// No description provided for @chatMulti.
  ///
  /// In zh, this message translates to:
  /// **'多选'**
  String get chatMulti;

  /// No description provided for @chatCode.
  ///
  /// In zh, this message translates to:
  /// **'代码'**
  String get chatCode;

  /// No description provided for @chatFailedToLoadModels.
  ///
  /// In zh, this message translates to:
  /// **'加载模型失败'**
  String get chatFailedToLoadModels;

  /// No description provided for @chatChooseModel.
  ///
  /// In zh, this message translates to:
  /// **'选择模型'**
  String get chatChooseModel;

  /// No description provided for @chatNoModels.
  ///
  /// In zh, this message translates to:
  /// **'没有可用模型'**
  String get chatNoModels;

  /// No description provided for @chatCompactContext.
  ///
  /// In zh, this message translates to:
  /// **'压缩上下文'**
  String get chatCompactContext;

  /// No description provided for @chatCompactSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'总结旧对话，腾出空间。'**
  String get chatCompactSubtitle;

  /// No description provided for @chatNewSession.
  ///
  /// In zh, this message translates to:
  /// **'新会话'**
  String get chatNewSession;

  /// No description provided for @chatNewSessionSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'清空 Pi 上的对话。'**
  String get chatNewSessionSubtitle;

  /// No description provided for @chatNewSessionConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'开始新会话？'**
  String get chatNewSessionConfirmTitle;

  /// No description provided for @chatNewSessionConfirmBody.
  ///
  /// In zh, this message translates to:
  /// **'这会清空 Pi 端的对话记录。当前线程无法恢复。'**
  String get chatNewSessionConfirmBody;

  /// No description provided for @chatStartNew.
  ///
  /// In zh, this message translates to:
  /// **'开始新会话'**
  String get chatStartNew;

  /// No description provided for @chatSwitchingModel.
  ///
  /// In zh, this message translates to:
  /// **'切换中…'**
  String get chatSwitchingModel;

  /// No description provided for @chatModel.
  ///
  /// In zh, this message translates to:
  /// **'模型'**
  String get chatModel;

  /// No description provided for @chatThinking.
  ///
  /// In zh, this message translates to:
  /// **'思考'**
  String get chatThinking;

  /// No description provided for @chatThinkingOff.
  ///
  /// In zh, this message translates to:
  /// **'关'**
  String get chatThinkingOff;

  /// No description provided for @chatThinkingMin.
  ///
  /// In zh, this message translates to:
  /// **'最低'**
  String get chatThinkingMin;

  /// No description provided for @chatThinkingLow.
  ///
  /// In zh, this message translates to:
  /// **'低'**
  String get chatThinkingLow;

  /// No description provided for @chatThinkingMed.
  ///
  /// In zh, this message translates to:
  /// **'中'**
  String get chatThinkingMed;

  /// No description provided for @chatThinkingHigh.
  ///
  /// In zh, this message translates to:
  /// **'高'**
  String get chatThinkingHigh;

  /// No description provided for @chatThinkingXhigh.
  ///
  /// In zh, this message translates to:
  /// **'极高'**
  String get chatThinkingXhigh;

  /// No description provided for @chatReasoning.
  ///
  /// In zh, this message translates to:
  /// **'推理'**
  String get chatReasoning;

  /// No description provided for @chatProviderAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get chatProviderAll;

  /// No description provided for @chatAnswerNotAccepted.
  ///
  /// In zh, this message translates to:
  /// **'这个回答没被接受。'**
  String get chatAnswerNotAccepted;

  /// No description provided for @chatNotConnected.
  ///
  /// In zh, this message translates to:
  /// **'还没连上 — 检查和 Pi 的连接后再试。'**
  String get chatNotConnected;

  /// No description provided for @toolAwaiting.
  ///
  /// In zh, this message translates to:
  /// **'等待中'**
  String get toolAwaiting;

  /// No description provided for @toolRunning.
  ///
  /// In zh, this message translates to:
  /// **'运行中'**
  String get toolRunning;

  /// No description provided for @toolDone.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get toolDone;

  /// No description provided for @toolFailed.
  ///
  /// In zh, this message translates to:
  /// **'失败'**
  String get toolFailed;

  /// No description provided for @toolDenied.
  ///
  /// In zh, this message translates to:
  /// **'已拒绝'**
  String get toolDenied;

  /// No description provided for @toolExpired.
  ///
  /// In zh, this message translates to:
  /// **'已超时'**
  String get toolExpired;

  /// No description provided for @toolWaitingApproval.
  ///
  /// In zh, this message translates to:
  /// **'等待批准…'**
  String get toolWaitingApproval;

  /// No description provided for @toolRunningEllipsis.
  ///
  /// In zh, this message translates to:
  /// **'⏳ 运行中…'**
  String get toolRunningEllipsis;

  /// No description provided for @toolOutcomeDone.
  ///
  /// In zh, this message translates to:
  /// **'✓ 完成'**
  String get toolOutcomeDone;

  /// No description provided for @toolOutcomeFailed.
  ///
  /// In zh, this message translates to:
  /// **'✗ {error}'**
  String toolOutcomeFailed(String error);

  /// No description provided for @toolOutcomeDenied.
  ///
  /// In zh, this message translates to:
  /// **'✗ {error}'**
  String toolOutcomeDenied(String error);

  /// No description provided for @toolOutcomeExpired.
  ///
  /// In zh, this message translates to:
  /// **'✗ 已超时'**
  String get toolOutcomeExpired;

  /// No description provided for @toolAllow.
  ///
  /// In zh, this message translates to:
  /// **'允许'**
  String get toolAllow;

  /// No description provided for @toolAllowOnce.
  ///
  /// In zh, this message translates to:
  /// **'允许一次'**
  String get toolAllowOnce;

  /// No description provided for @toolAllowSession.
  ///
  /// In zh, this message translates to:
  /// **'本次允许'**
  String get toolAllowSession;

  /// No description provided for @toolAllowAlways.
  ///
  /// In zh, this message translates to:
  /// **'总是允许'**
  String get toolAllowAlways;

  /// No description provided for @toolDeny.
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get toolDeny;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsPairings.
  ///
  /// In zh, this message translates to:
  /// **'配对'**
  String get settingsPairings;

  /// No description provided for @settingsAddPairing.
  ///
  /// In zh, this message translates to:
  /// **'添加配对'**
  String get settingsAddPairing;

  /// No description provided for @settingsRelayUpdated.
  ///
  /// In zh, this message translates to:
  /// **'中继已更新'**
  String get settingsRelayUpdated;

  /// No description provided for @settingsRelayUrlRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入中继网址。'**
  String get settingsRelayUrlRequired;

  /// No description provided for @actionOffline.
  ///
  /// In zh, this message translates to:
  /// **'当前离线'**
  String get actionOffline;

  /// No description provided for @actionDisconnected.
  ///
  /// In zh, this message translates to:
  /// **'连接已断开'**
  String get actionDisconnected;

  /// No description provided for @actionTimeout.
  ///
  /// In zh, this message translates to:
  /// **'操作超时'**
  String get actionTimeout;

  /// No description provided for @actionFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败'**
  String get actionFailed;

  /// No description provided for @settingsCurrentRelay.
  ///
  /// In zh, this message translates to:
  /// **'当前：{url}'**
  String settingsCurrentRelay(String url);

  /// No description provided for @settingsUseDefaultRelay.
  ///
  /// In zh, this message translates to:
  /// **'使用默认中继'**
  String get settingsUseDefaultRelay;

  /// No description provided for @settingsDisplay.
  ///
  /// In zh, this message translates to:
  /// **'显示'**
  String get settingsDisplay;

  /// No description provided for @settingsTheme.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get settingsThemeDark;

  /// No description provided for @settingsTextSize.
  ///
  /// In zh, this message translates to:
  /// **'字号'**
  String get settingsTextSize;

  /// No description provided for @settingsFontSmall.
  ///
  /// In zh, this message translates to:
  /// **'小'**
  String get settingsFontSmall;

  /// No description provided for @settingsFontDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get settingsFontDefault;

  /// No description provided for @settingsFontLarge.
  ///
  /// In zh, this message translates to:
  /// **'大'**
  String get settingsFontLarge;

  /// No description provided for @settingsFontXl.
  ///
  /// In zh, this message translates to:
  /// **'特大'**
  String get settingsFontXl;

  /// No description provided for @settingsHideToolCalls.
  ///
  /// In zh, this message translates to:
  /// **'在聊天里隐藏工具调用'**
  String get settingsHideToolCalls;

  /// No description provided for @settingsHideToolCallsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'只显示你的消息和助手回复。'**
  String get settingsHideToolCallsSubtitle;

  /// No description provided for @settingsTapPlusToPair.
  ///
  /// In zh, this message translates to:
  /// **'点 + 配对一台新电脑。'**
  String get settingsTapPlusToPair;

  /// No description provided for @settingsNickname.
  ///
  /// In zh, this message translates to:
  /// **'备注名'**
  String get settingsNickname;

  /// No description provided for @settingsNicknameLocalOnly.
  ///
  /// In zh, this message translates to:
  /// **'仅本机 — 不会通知电脑。'**
  String get settingsNicknameLocalOnly;

  /// No description provided for @settingsNicknameDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认：{name}'**
  String settingsNicknameDefault(String name);

  /// No description provided for @settingsRemoveNickname.
  ///
  /// In zh, this message translates to:
  /// **'移除备注名'**
  String get settingsRemoveNickname;

  /// No description provided for @settingsRevokeTitle.
  ///
  /// In zh, this message translates to:
  /// **'撤销“{name}”？'**
  String settingsRevokeTitle(String name);

  /// No description provided for @settingsRevokeBody.
  ///
  /// In zh, this message translates to:
  /// **'之后需要在电脑上重新配对才能连上。'**
  String get settingsRevokeBody;

  /// No description provided for @settingsRevoke.
  ///
  /// In zh, this message translates to:
  /// **'撤销'**
  String get settingsRevoke;

  /// No description provided for @settingsEditNickname.
  ///
  /// In zh, this message translates to:
  /// **'编辑备注名'**
  String get settingsEditNickname;

  /// No description provided for @settingsNoPairingsHint.
  ///
  /// In zh, this message translates to:
  /// **'点 + 配对一台新电脑。'**
  String get settingsNoPairingsHint;

  /// No description provided for @updateAvailable.
  ///
  /// In zh, this message translates to:
  /// **'有新版本'**
  String get updateAvailable;

  /// No description provided for @updateTapToDownload.
  ///
  /// In zh, this message translates to:
  /// **'v{version} · 点一下下载 APK'**
  String updateTapToDownload(String version);

  /// No description provided for @syncRequired.
  ///
  /// In zh, this message translates to:
  /// **'需要同步'**
  String get syncRequired;

  /// No description provided for @syncWhyIos.
  ///
  /// In zh, this message translates to:
  /// **'Remote Pi 把你的 Ed25519 所有者密钥存在 iCloud 钥匙串里，换 iPhone 或配对 iPad 时不用重新扫码。'**
  String get syncWhyIos;

  /// No description provided for @syncWhyAndroid.
  ///
  /// In zh, this message translates to:
  /// **'Remote Pi 把你的 Ed25519 所有者密钥存在 Google Block Store 里，换机通过 Google 备份就能恢复，配对过的 Pi 不会丢。'**
  String get syncWhyAndroid;

  /// No description provided for @syncToEnable.
  ///
  /// In zh, this message translates to:
  /// **'在这台设备上这样打开：'**
  String get syncToEnable;

  /// No description provided for @syncCheckAgain.
  ///
  /// In zh, this message translates to:
  /// **'再检查一次'**
  String get syncCheckAgain;

  /// No description provided for @syncAndroidLock.
  ///
  /// In zh, this message translates to:
  /// **'设置锁屏'**
  String get syncAndroidLock;

  /// No description provided for @syncAndroidLockPath.
  ///
  /// In zh, this message translates to:
  /// **'设置 › 安全 › 屏幕锁定'**
  String get syncAndroidLockPath;

  /// No description provided for @syncAndroidLockNote.
  ///
  /// In zh, this message translates to:
  /// **'PIN、图案或生物识别 — Block Store 需要这个。'**
  String get syncAndroidLockNote;

  /// No description provided for @syncAndroidBackup.
  ///
  /// In zh, this message translates to:
  /// **'打开 Google 备份'**
  String get syncAndroidBackup;

  /// No description provided for @syncAndroidBackupPath.
  ///
  /// In zh, this message translates to:
  /// **'设置 › 系统 › 备份\n（三星：设置 › 账号和备份 › 备份数据）'**
  String get syncAndroidBackupPath;

  /// No description provided for @syncAndroidGoogle.
  ///
  /// In zh, this message translates to:
  /// **'登录 Google 账号'**
  String get syncAndroidGoogle;

  /// No description provided for @syncAndroidGooglePath.
  ///
  /// In zh, this message translates to:
  /// **'设置 › 密码和账号 › 添加账号 › Google'**
  String get syncAndroidGooglePath;

  /// No description provided for @syncIosIcloud.
  ///
  /// In zh, this message translates to:
  /// **'登录 iCloud'**
  String get syncIosIcloud;

  /// No description provided for @syncIosIcloudPath.
  ///
  /// In zh, this message translates to:
  /// **'设置 › [你的名字]'**
  String get syncIosIcloudPath;

  /// No description provided for @syncIosIcloudNote.
  ///
  /// In zh, this message translates to:
  /// **'如果顶部显示“登录 iPhone”，点一下。'**
  String get syncIosIcloudNote;

  /// No description provided for @syncIosKeychain.
  ///
  /// In zh, this message translates to:
  /// **'打开 iCloud 钥匙串'**
  String get syncIosKeychain;

  /// No description provided for @syncIosKeychainPath.
  ///
  /// In zh, this message translates to:
  /// **'设置 › [你的名字] › iCloud › 密码与钥匙串'**
  String get syncIosKeychainPath;

  /// No description provided for @syncIosKeychainNote.
  ///
  /// In zh, this message translates to:
  /// **'打开“同步此 iPhone”。'**
  String get syncIosKeychainNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
