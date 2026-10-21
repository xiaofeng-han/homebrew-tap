cask "apple-notes-mcp" do
  version "0.1.0"
  sha256 "dfbd94aaea2c0726ed400e12ad28d19ae04e3e3f1110fa9ab9f0b2ebed650042"

  url "https://github.com/xiaofeng-han/apple-notes-mcp/releases/download/v#{version}/AppleNotesMCP-#{version}.pkg"
  name "Apple Notes MCP"
  desc "MCP server that gives AI agents native read and write access to Notes"
  homepage "https://github.com/xiaofeng-han/apple-notes-mcp"

  livecheck do
    url :url
    strategy :github_latest
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
