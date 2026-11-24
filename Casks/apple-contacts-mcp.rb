cask "apple-contacts-mcp" do
  version "0.1.0"
  sha256 "dbb62cdfe7837c3ec0c06a8d0ee25d1f79f3ef59072bc5f55625fc4d2b07fde0"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/contacts-v#{version}/AppleContactsMCP-#{version}.zip"
  name "Apple Contacts MCP"
  desc "MCP server that gives AI agents native read and write access to Contacts"
  homepage "https://github.com/xiaofeng-han/apple-mcp/blob/main/docs/contacts.md"

  livecheck do
    url "https://github.com/xiaofeng-han/apple-mcp"
    regex(/^contacts-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "AppleContactsMCP.app"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold its permissions itself.
  command_wrapper "apple-contacts-mcp",
                  executable: "#{appdir}/AppleContactsMCP.app/Contents/MacOS/AppleContactsMCP"

  # The app is signed with a self-signed certificate, not a Developer ID, so Gatekeeper refuses to
  # start it while it carries the quarantine Homebrew puts on downloads; the release package never
  # had that attribute. Removing it lets the app start as it does from the package.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AppleContactsMCP.app"]
  end

  zap trash: [
    "~/Library/Application Support/AppleContactsMCP",
    "~/Library/Preferences/com.xiaofeng.apple-contacts-mcp.plist",
  ]

  caveats <<~EOS
    Give Apple Contacts MCP Contacts access and allow it to control Contacts:
      apple-contacts-mcp setup

    Then register this command with your agents:
      #{HOMEBREW_PREFIX}/bin/apple-contacts-mcp --stdio
  EOS
end
