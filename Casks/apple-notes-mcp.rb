cask "apple-notes-mcp" do
  version "0.4.1"
  sha256 "7b4c2f537d1614d83fb24843159dd03789e542428e54c03aa28cc0e879ed6a84"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/notes-v#{version}/AppleNotesMCP-#{version}.zip"
  name "Apple Notes MCP"
  desc "MCP server that gives AI agents native read and write access to Notes"
  homepage "https://github.com/xiaofeng-han/apple-mcp/blob/main/docs/notes.md"

  livecheck do
    url "https://github.com/xiaofeng-han/apple-mcp"
    regex(/^notes-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "AppleNotesMCP.app"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold its permissions itself.
  command_wrapper "apple-notes-mcp",
                  executable: "#{appdir}/AppleNotesMCP.app/Contents/MacOS/AppleNotesMCP"

  # The app is signed with a self-signed certificate, not a Developer ID, so Gatekeeper refuses to
  # start it while it carries the quarantine Homebrew puts on downloads. The release package it was
  # installed from before never had that attribute; removing it keeps the app starting as it did.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AppleNotesMCP.app"]
  end

  zap trash: [
    "~/Library/Application Support/AppleNotesMCP",
    "~/Library/Preferences/com.xiaofeng.apple-notes-mcp.plist",
  ]

  caveats <<~EOS
    Give Apple Notes MCP Full Disk Access and allow it to control Notes:
      apple-notes-mcp setup

    Then register this command with your agents:
      #{HOMEBREW_PREFIX}/bin/apple-notes-mcp --stdio
  EOS
end
