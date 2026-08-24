# Remote Pi（本 fork）安装说明

一条命令，在笔记本或 Linux 服务器上装好 **Pi + 本仓库的扩展 + 常驻 supervisor**，然后用可复制的配对 URI 在 SSH 里配对。二维码在 SSH 下没用。

**不要**用上游的 `pi install npm:remote-pi`。那个包仍会自动跑受审批门控的工具；本 fork 的扩展才是你要的。

## 一条命令

在已经 clone 的仓库里：

```bash
./packaging/install.sh
```

指定自建 / Tailscale 中继：

```bash
./packaging/install.sh --relay https://relay.example.ts.net
# 或
REMOTE_PI_RELAY=https://relay.example.ts.net ./packaging/install.sh
```

还没有 clone、在 VPS 上从零开始：

```bash
curl -fsSL https://raw.githubusercontent.com/202121000995/remote_pi/main/packaging/install.sh | bash
```

带中继、从管道传入参数：

```bash
curl -fsSL https://raw.githubusercontent.com/202121000995/remote_pi/main/packaging/install.sh \
  | bash -s -- --relay https://your-relay.example
```

已有本仓库的 tarball（`npm pack` 或源码包）：

```bash
./packaging/install.sh --from /path/to/remote-pi-0.7.0.tgz
```

看全部选项：`./packaging/install.sh --help`

默认把首次向导配置写到 `$HOME/.pi/remote-pi/config.json`（避免弄脏仓库）。要装到某个项目目录：

```bash
REMOTE_PI_CWD=/home/you/project ./packaging/install.sh
```

脚本是幂等的：再跑一遍不会拆掉已经配对的设备（不改 `peers.json` / `identity.json`）。

## 笔记本 vs VPS

| | 笔记本（有桌面） | VPS / 无桌面 Linux |
|---|---|---|
| 身份密钥 | 系统钥匙串（Keychain / libsecret） | 没有 D-Bus 钥匙串时落到 `~/.pi/remote/identity.json`（权限 `0600`）。这是正常的，别删。 |
| Supervisor | macOS：`remote-pi install` 写 launchd；Linux：systemd `--user` | 同样是 `remote-pi install`。SSH 注销后 user 服务会停，VPS 上需要 linger：`sudo loginctl enable-linger $USER` |
| 配对 | 可以扫终端里的二维码，也可以粘贴 URI | **只粘贴 URI**。SSH 里的二维码扫不了。 |

Windows 请用 WSL，在 Linux 壳里再跑安装脚本。

## 中继（社区 / Tailscale / 自建）

解析顺序和上游一样：

1. 环境变量 `REMOTE_PI_RELAY`
2. `~/.pi/remote/config.json` 的 `relay` 字段（`remote-pi set-relay` 或安装脚本写入）
3. 社区默认 `https://relay-rp1.jacobmoura.work`

存的是 `http://` / `https://`。`wss://` 可以传给 `--relay`，脚本会改成 `https://`。

- 笔记本和手机在同一 Tailscale 网：把 `--relay` 设成你中继的 MagicDNS / 内网 HTTPS 地址。
- 敏感流量：自己跑一份 `relay/`（见仓库 `relay/README.md`），不要走公共中继。
- 公共中继的运营者看得到报文内容（当前没有端到端加密）。

装好以后改中继：

```bash
remote-pi set-relay https://your-relay.example
```

然后重启 Pi / daemon，或 `/remote-pi relay stop` 再 `/remote-pi relay start`。

## 加载本 fork 的扩展（不要装上游）

安装脚本会 `pi install <本仓库>/pi-extension`（本地路径，不复制到 npm）。仍建议你明确用 `-e`，以免哪天又装回上游包：

```bash
pi -e /path/to/remote_pi/pi-extension/dist/index.js
```

路径以脚本结束时打印的为准。若 `pi list` 里还出现 `npm:remote-pi`：

```bash
pi remove npm:remote-pi
```

确认加载的是 fork：

```text
/remote-pi config
```

## 在 SSH 里配对（粘贴 URI）

二维码在 SSH 会话里没法拿手机扫。用复制粘贴：

1. 服务器上打开 Pi（带上本扩展）：

   ```bash
   pi -e /path/to/remote_pi/pi-extension/dist/index.js
   ```

2. 输入：

   ```text
   /remote-pi pair
   ```

3. 终端会打出一行 **`remotepi://pair?…`**（没有 TTY 也会打，不只出二维码）。整行复制。

4. 手机打开 Remote Pi → 配对页 → **「扫不了？改为粘贴」** / **Can't scan? Paste code instead** → 粘贴 → 配对。

URI 大约 60 秒过期。过期了再跑一次 `/remote-pi pair`。已经配对过的设备不用再配；重装脚本不会撤销它们。

## 装完自检（Linux 盒子）

```bash
./packaging/install.sh --help          # 应打印 Usage 并以 0 退出
command -v pi && command -v remote-pi
pi -e "$HOME/.local/src/remote_pi/pi-extension/dist/index.js"   # 若你是 curl 安装
# 在 Pi 里：
#   /remote-pi pair
# 应看到 remotepi://pair? 开头的一行
```

VPS 上确认 user systemd 还活着：

```bash
systemctl --user status remote-pi-supervisord.service
loginctl show-user "$USER" -p Linger
```
