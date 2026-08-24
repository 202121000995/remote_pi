// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Remote Pi';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonClose => '关闭';

  @override
  String get commonBack => '返回';

  @override
  String get commonRetry => '重试';

  @override
  String get commonTryAgain => '重试';

  @override
  String get commonSettings => '设置';

  @override
  String get commonContinue => '继续';

  @override
  String get commonSkip => '跳过';

  @override
  String get commonDelete => '删除';

  @override
  String get commonSubmit => '提交';

  @override
  String get commonPair => '配对';

  @override
  String get commonDismiss => '关闭';

  @override
  String get commonRefresh => '刷新';

  @override
  String get onboardingTagline => '随时随地控制你的 Pi 智能体';

  @override
  String get onboardingBody =>
      '把这个 App 和电脑上运行的 Pi 配对（Mac、Linux 或 Windows），出门也能继续对话。';

  @override
  String get onboardingGetStarted => '开始使用';

  @override
  String get onboardingChooseRelay => '选择中继';

  @override
  String get onboardingRelaySubtitle => 'App 和电脑在这里会合。';

  @override
  String get onboardingRecommended => '推荐';

  @override
  String get onboardingCustomRelay => '使用自己的服务器';

  @override
  String get onboardingCustomRelayDesc => '自托管，隐私最好。';

  @override
  String get onboardingCommunityRelay => '社区中继';

  @override
  String get onboardingCommunityRelayDesc => '我们托管，马上就能用。';

  @override
  String get onboardingConnectDevice => '连接设备';

  @override
  String get onboardingPairInstructions =>
      '在电脑上（Mac、Linux 或 Windows）打开 Pi，然后运行：';

  @override
  String get onboardingScanQrHint => '扫描出现的二维码：';

  @override
  String get onboardingCantScan => '扫不了？改为粘贴配对码';

  @override
  String get onboardingScanLater => '稍后再扫';

  @override
  String get onboardingPairing => '正在配对…';

  @override
  String get onboardingPaired => '已配对！';

  @override
  String get pairingTitle => '配对设备';

  @override
  String get pairingPointCamera => '将相机对准终端里显示的二维码';

  @override
  String pairingConnectingTo(String name) {
    return '正在连接 $name…';
  }

  @override
  String get pairingPasteTitle => '粘贴配对码';

  @override
  String get pairingPasteBody => '扫不了二维码？把电脑终端里的文本粘到下面。以 remotepi://pair? 开头。';

  @override
  String get pairingPasteFromClipboard => '从剪贴板粘贴';

  @override
  String get pairingNameThisPc => '给这台电脑起名';

  @override
  String get pairingNameThisPcHint => '起个好认的名字，方便在列表里找到。之后可以在主页改。';

  @override
  String get pairingQrExpired => '二维码已过期 — 请在电脑上重新生成';

  @override
  String get pairingQrUsed => '二维码已用过 — 请重新生成';

  @override
  String get pairingQrUnknown => '电脑无法识别这个二维码 — 请重新运行 /remote-pi pair';

  @override
  String get pairingTimeout => '超时了 — 请确认电脑上正在运行 /remote-pi';

  @override
  String pairingRelayMismatch(String qrUrl, String currentUrl) {
    return '二维码指向“$qrUrl”，但 App 当前使用“$currentUrl”。请在设置里改中继，或让 Pi 重新生成二维码。';
  }

  @override
  String pairingUnknownResponse(String type) {
    return '未知响应类型：$type';
  }

  @override
  String get pairingAndroidDevice => '安卓设备';

  @override
  String get pairingMobileDevice => '手机';

  @override
  String get relayUrlInvalidScheme =>
      '请用 http:// 或 https://（不要用 ws:// 或 wss:// — App 会自动转成 WebSocket）。';

  @override
  String get relayUrlInvalidGeneric =>
      '请输入以 https:// 开头的有效网址（本地中继可以用 http://）。';

  @override
  String get homeConnected => '已连接';

  @override
  String get homeAwaitingPairing => '等待配对';

  @override
  String get homeOffline => '离线';

  @override
  String get homeRelay => '中继';

  @override
  String get homeFilterAll => '全部';

  @override
  String get homeFilterOnline => '在线';

  @override
  String get homeFilterOffline => '离线';

  @override
  String get homeNothingHere => '这里还是空的…';

  @override
  String get homeNothingHereSubtitle => '配对的 Pi 打开会话后，会出现在这里。';

  @override
  String get homeNoPairings => '还没有配对';

  @override
  String get homeNoPairingsHint => '扫描电脑上的二维码即可开始。';

  @override
  String get homeScanQr => '扫描二维码';

  @override
  String get homeNoSessionsOnline => '没有在线会话';

  @override
  String get homeNoSessionsOnlineHint => '配对的 Pi 活跃时，实时会话会出现在这里。';

  @override
  String get homeNoSessionsOffline => '没有离线会话';

  @override
  String get homeNoSessionsOfflineHint => '以前见过、现在不在线的会话会出现在这里。';

  @override
  String get homeRenameSession => '重命名会话';

  @override
  String get homeDeleteSessionLocal => '删除会话（仅本地）';

  @override
  String get homeDeleteSessionOnlyOffline => '仅在会话离线时可用';

  @override
  String get homeDeleteSessionTitle => '删除会话？';

  @override
  String get homeDeleteSessionBody => '只从本机移除。如果 Pi 上这个会话重新上线，它会再出现在列表里。';

  @override
  String homeLastPaired(String time) {
    return '上次配对：$time';
  }

  @override
  String get homeJustNow => '刚刚';

  @override
  String homeMinutesAgo(int n) {
    return '$n 分钟前';
  }

  @override
  String homeHoursAgo(int n) {
    return '$n 小时前';
  }

  @override
  String homeDaysAgo(int n) {
    return '$n 天前';
  }

  @override
  String get homeSession => '会话';

  @override
  String get chatWorking => '工作中…';

  @override
  String get chatReconnecting => '重连中…';

  @override
  String get chatOnline => '在线';

  @override
  String get chatOffline => '离线';

  @override
  String get chatSessionInfo => '会话信息';

  @override
  String get chatInfoName => '名称';

  @override
  String get chatInfoPath => '路径';

  @override
  String get chatInfoOwner => '设备';

  @override
  String get chatInfoModel => '模型';

  @override
  String get chatInfoRoom => '房间';

  @override
  String get chatInfoPaired => '配对时间';

  @override
  String get chatNoActiveDevice => '没有活跃设备';

  @override
  String get chatConnecting => '正在连接…';

  @override
  String get chatRePair => '重新配对';

  @override
  String get chatNothingHere => '这里还是空的';

  @override
  String get chatPairingRevoked => '电脑已撤销配对 — 重新配对后才能继续';

  @override
  String get chatCameraPermission => '相机权限已关闭 — 请到设置里打开，才能附加照片。';

  @override
  String get chatAttachFailed => '这张图片没法附加。';

  @override
  String get chatHoldMic => '按住麦克风说话';

  @override
  String get chatMicPermission => '麦克风权限已关闭 — 请到设置里打开，才能语音输入。';

  @override
  String get chatHintOffline => '离线…';

  @override
  String get chatHintSteer => '给当前回复加点指示…';

  @override
  String get chatHintCaption => '加个说明…';

  @override
  String get chatHintSend => '发一条消息…';

  @override
  String get chatQueuedEdit => '已排队。点一下可改。';

  @override
  String get chatQueuedFollowup => '已排队的后续消息。';

  @override
  String get chatClearQueued => '清除排队消息';

  @override
  String get chatAttachImage => '附加图片';

  @override
  String get chatQuickActions => '快捷操作';

  @override
  String get chatTranscribing => '识别中…';

  @override
  String get chatSteering => '引导中…';

  @override
  String get chatSending => '发送中…';

  @override
  String get chatNotDelivered => '未送达';

  @override
  String get chatContextCompacted => '上下文已压缩';

  @override
  String chatTokensApprox(int count) {
    return '约 $count tokens';
  }

  @override
  String get chatSelectSession => '选择一个会话';

  @override
  String get chatSelectSessionHint => '在左侧点一个会话，打开对应聊天。';

  @override
  String get chatCopyCode => '复制代码';

  @override
  String chatCouldntOpenUrl(String url) {
    return '打不开 $url';
  }

  @override
  String get chatSlideToCancel => '左滑取消';

  @override
  String get chatReleaseToCancel => '松手取消';

  @override
  String get chatCamera => '相机';

  @override
  String get chatPhotoLibrary => '相册';

  @override
  String get chatClarificationNeeded => '需要你确认一下';

  @override
  String get chatTypeYourOwn => '自己输入…';

  @override
  String get chatPleaseConfirm => '请确认。';

  @override
  String get chatNoResponseFromPi => 'Pi 还没回应 — 重试或取消。';

  @override
  String get chatRequired => '必填';

  @override
  String get chatMulti => '多选';

  @override
  String get chatCode => '代码';

  @override
  String get chatFailedToLoadModels => '加载模型失败';

  @override
  String get chatChooseModel => '选择模型';

  @override
  String get chatNoModels => '没有可用模型';

  @override
  String get chatCompactContext => '压缩上下文';

  @override
  String get chatCompactSubtitle => '总结旧对话，腾出空间。';

  @override
  String get chatNewSession => '新会话';

  @override
  String get chatNewSessionSubtitle => '清空 Pi 上的对话。';

  @override
  String get chatNewSessionConfirmTitle => '开始新会话？';

  @override
  String get chatNewSessionConfirmBody => '这会清空 Pi 端的对话记录。当前线程无法恢复。';

  @override
  String get chatStartNew => '开始新会话';

  @override
  String get chatSwitchingModel => '切换中…';

  @override
  String get chatModel => '模型';

  @override
  String get chatThinking => '思考';

  @override
  String get chatThinkingOff => '关';

  @override
  String get chatThinkingMin => '最低';

  @override
  String get chatThinkingLow => '低';

  @override
  String get chatThinkingMed => '中';

  @override
  String get chatThinkingHigh => '高';

  @override
  String get chatThinkingXhigh => '极高';

  @override
  String get chatReasoning => '推理';

  @override
  String get chatProviderAll => '全部';

  @override
  String get chatAnswerNotAccepted => '这个回答没被接受。';

  @override
  String get chatNotConnected => '还没连上 — 检查和 Pi 的连接后再试。';

  @override
  String get toolAwaiting => '等待中';

  @override
  String get toolRunning => '运行中';

  @override
  String get toolDone => '完成';

  @override
  String get toolFailed => '失败';

  @override
  String get toolDenied => '已拒绝';

  @override
  String get toolExpired => '已超时';

  @override
  String get toolWaitingApproval => '等待批准…';

  @override
  String get toolRunningEllipsis => '⏳ 运行中…';

  @override
  String get toolOutcomeDone => '✓ 完成';

  @override
  String toolOutcomeFailed(String error) {
    return '✗ $error';
  }

  @override
  String toolOutcomeDenied(String error) {
    return '✗ $error';
  }

  @override
  String get toolOutcomeExpired => '✗ 已超时';

  @override
  String get toolAllow => '允许';

  @override
  String get toolAllowOnce => '允许一次';

  @override
  String get toolAllowSession => '本次允许';

  @override
  String get toolAllowAlways => '总是允许';

  @override
  String get toolDeny => '拒绝';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsPairings => '配对';

  @override
  String get settingsAddPairing => '添加配对';

  @override
  String get settingsRelayUpdated => '中继已更新';

  @override
  String get settingsRelayUrlRequired => '请输入中继网址。';

  @override
  String get actionOffline => '当前离线';

  @override
  String get actionDisconnected => '连接已断开';

  @override
  String get actionTimeout => '操作超时';

  @override
  String get actionFailed => '操作失败';

  @override
  String settingsCurrentRelay(String url) {
    return '当前：$url';
  }

  @override
  String get settingsUseDefaultRelay => '使用默认中继';

  @override
  String get settingsDisplay => '显示';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsTextSize => '字号';

  @override
  String get settingsFontSmall => '小';

  @override
  String get settingsFontDefault => '默认';

  @override
  String get settingsFontLarge => '大';

  @override
  String get settingsFontXl => '特大';

  @override
  String get settingsHideToolCalls => '在聊天里隐藏工具调用';

  @override
  String get settingsHideToolCallsSubtitle => '只显示你的消息和助手回复。';

  @override
  String get settingsTapPlusToPair => '点 + 配对一台新电脑。';

  @override
  String get settingsNickname => '备注名';

  @override
  String get settingsNicknameLocalOnly => '仅本机 — 不会通知电脑。';

  @override
  String settingsNicknameDefault(String name) {
    return '默认：$name';
  }

  @override
  String get settingsRemoveNickname => '移除备注名';

  @override
  String settingsRevokeTitle(String name) {
    return '撤销“$name”？';
  }

  @override
  String get settingsRevokeBody => '之后需要在电脑上重新配对才能连上。';

  @override
  String get settingsRevoke => '撤销';

  @override
  String get settingsEditNickname => '编辑备注名';

  @override
  String get settingsNoPairingsHint => '点 + 配对一台新电脑。';

  @override
  String get updateAvailable => '有新版本';

  @override
  String updateTapToDownload(String version) {
    return 'v$version · 点一下下载 APK';
  }

  @override
  String get syncRequired => '需要同步';

  @override
  String get syncWhyIos =>
      'Remote Pi 把你的 Ed25519 所有者密钥存在 iCloud 钥匙串里，换 iPhone 或配对 iPad 时不用重新扫码。';

  @override
  String get syncWhyAndroid =>
      'Remote Pi 把你的 Ed25519 所有者密钥存在 Google Block Store 里，换机通过 Google 备份就能恢复，配对过的 Pi 不会丢。';

  @override
  String get syncToEnable => '在这台设备上这样打开：';

  @override
  String get syncCheckAgain => '再检查一次';

  @override
  String get syncAndroidLock => '设置锁屏';

  @override
  String get syncAndroidLockPath => '设置 › 安全 › 屏幕锁定';

  @override
  String get syncAndroidLockNote => 'PIN、图案或生物识别 — Block Store 需要这个。';

  @override
  String get syncAndroidBackup => '打开 Google 备份';

  @override
  String get syncAndroidBackupPath => '设置 › 系统 › 备份\n（三星：设置 › 账号和备份 › 备份数据）';

  @override
  String get syncAndroidGoogle => '登录 Google 账号';

  @override
  String get syncAndroidGooglePath => '设置 › 密码和账号 › 添加账号 › Google';

  @override
  String get syncIosIcloud => '登录 iCloud';

  @override
  String get syncIosIcloudPath => '设置 › [你的名字]';

  @override
  String get syncIosIcloudNote => '如果顶部显示“登录 iPhone”，点一下。';

  @override
  String get syncIosKeychain => '打开 iCloud 钥匙串';

  @override
  String get syncIosKeychainPath => '设置 › [你的名字] › iCloud › 密码与钥匙串';

  @override
  String get syncIosKeychainNote => '打开“同步此 iPhone”。';
}
