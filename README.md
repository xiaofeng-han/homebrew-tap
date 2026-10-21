# xiaofeng-han/tap

Homebrew casks for Xiaofeng Han's macOS tools.

| Cask | What it is |
|---|---|
| `apple-reminders-mcp` | [Apple Reminders MCP](https://github.com/xiaofeng-han/apple-reminders-mcp): an MCP server that lets AI agents fully read and write Reminders |
| `apple-notes-mcp` | [Apple Notes MCP](https://github.com/xiaofeng-han/apple-notes-mcp): an MCP server that lets AI agents read and edit Notes with native formatting |

## Install

```bash
brew install --cask xiaofeng-han/tap/apple-reminders-mcp
brew install --cask xiaofeng-han/tap/apple-notes-mcp
```

Naming the cask in full adds this tap and trusts only that cask. Since Homebrew 6, items from taps outside Homebrew have to be trusted before Homebrew loads them (see [Tap Trust](https://docs.brew.sh/Tap-Trust)). After that, `brew upgrade` picks up new versions.

`apple-reminders-mcp` installs the release package with the macOS installer, so Homebrew asks for an administrator password. The app goes into `/Applications`, and the command `apple-reminders-mcp` starts it. The [project's README](https://github.com/xiaofeng-han/apple-reminders-mcp#install) explains the rest of the setup.

## Maintenance

After a release is published, `scripts/update-cask.sh` in the apple-reminders-mcp repository sets the new version and checksum here, then commits and pushes. Before changing a cask's structure, check it:

```bash
brew style --cask Casks/apple-reminders-mcp.rb
brew audit --cask --strict --online xiaofeng-han/tap/apple-reminders-mcp
```

`brew audit` reads the tapped copy (`brew --repository xiaofeng-han/tap`), not this checkout. Both are developer commands, and running one switches on Homebrew's developer mode; `brew developer off` switches it off again. `brew audit --new` is not meant for this tap: it requires notarized packages and a well-known repository, which only apply to Homebrew's own casks.

---

**中文**：`brew install --cask xiaofeng-han/tap/apple-reminders-mcp` 安装 [Apple Reminders MCP](https://github.com/xiaofeng-han/apple-reminders-mcp/blob/main/README.zh-CN.md)。写全名会自动添加本 tap 并只信任这一个 cask（Homebrew 6 起，第三方 tap 的内容要先信任才会加载）。安装时 Homebrew 用 macOS 的安装器装发布包，所以会要管理员密码；App 装到 `/Applications`，命令 `apple-reminders-mcp` 用来启动它。
