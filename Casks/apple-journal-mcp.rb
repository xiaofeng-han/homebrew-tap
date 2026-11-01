cask "apple-journal-mcp" do
  version "0.1.0"
  sha256 "896664b0d6c60bb4dc29443362209ae5c8e5a31c9fe00b05f1c05971c4ec259f"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/journal-v#{version}/AppleJournalMCP-#{version}.zip"
  name "Apple Journal MCP"
  desc "MCP server that gives AI agents native read and write access to Journal"
  homepage "https://github.com/xiaofeng-han/apple-mcp/blob/main/docs/journal.md"

  livecheck do
    url "https://github.com/xiaofeng-han/apple-mcp"
    regex(/^journal-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  # Journal 3.0, whose data model the app works with, comes with macOS 27.2.
  depends_on macos: :golden_gate

  app "AppleJournalMCP.app"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold Full Disk Access itself.
  command_wrapper "apple-journal-mcp",
                  executable: "#{appdir}/AppleJournalMCP.app/Contents/MacOS/AppleJournalMCP"

  # The app is signed with a self-signed certificate, not a Developer ID, so Gatekeeper refuses to
  # start it while it carries the quarantine Homebrew puts on downloads; the release package never
  # had that attribute. Removing it lets the app start as it does from the package.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AppleJournalMCP.app"]
  end

  zap trash: [
    "~/Library/Application Support/AppleJournalMCP",
    "~/Library/Preferences/com.xiaofeng.apple-journal-mcp.plist",
  ]

  caveats <<~EOS
    Give Apple Journal MCP Full Disk Access (this shows where):
      apple-journal-mcp setup

    Then register this command with your agents:
      #{HOMEBREW_PREFIX}/bin/apple-journal-mcp --stdio
  EOS
end
