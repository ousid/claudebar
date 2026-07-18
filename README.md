# ClaudeBar

A native macOS menu bar app that shows your Claude usage limits — session (5-hour), weekly, and weekly Opus — the same numbers the claude.ai dashboard and Claude Code's `/usage` command show.

![screenshot placeholder](docs/screenshot.png)

## Install

```bash
git clone https://github.com/YOURNAME/claudebar
cd claudebar
./scripts/build-app.sh
cp -r ClaudeBar.app /Applications/
open /Applications/ClaudeBar.app
```

Requires macOS 13+ and the Swift toolchain (`xcode-select --install` is enough — no Xcode needed).

## Connect your account

Click the ✳ icon → **Connect Claude Account**. Your browser opens claude.ai; approve access, copy the code shown, and paste it into the popover. That's it.

## How it works

- ClaudeBar signs in with its own OAuth token, requesting only the `user:profile` scope — it can read your usage numbers and nothing else. It cannot send messages or spend your quota.
- The token is stored in your macOS Keychain (`com.claudebar.oauth`) and never leaves your machine.
- The app talks only to Anthropic endpoints (`claude.ai`, `api.anthropic.com`, `console.anthropic.com`). No analytics, no third-party servers.
- Usage refreshes every 5 minutes and whenever you open the popover.

## License

MIT
