cask "apple-notes-mcp" do
  version "0.4.1"
  sha256 "6577d47d821eb51c1e1396a684c35dc172b6f8a23ef0f51158d1e9088d507cf3"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/notes-v#{version}/AppleNotesMCP-#{version}.pkg"
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

  pkg "AppleNotesMCP-#{version}.pkg"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold its permissions itself.
  command_wrapper "apple-notes-mcp",
                  executable: "/Applications/AppleNotesMCP.app/Contents/MacOS/AppleNotesMCP"

  uninstall pkgutil: "com.xiaofeng.apple-notes-mcp.pkg"

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
