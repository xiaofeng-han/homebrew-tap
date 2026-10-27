cask "apple-reminders-mcp" do
  version "0.4.1"
  sha256 "84584c97e92cde8f3ec6116bd36105a428850669a33948c63a67c398c7bcbba0"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/reminders-v#{version}/AppleRemindersMCP-#{version}.zip"
  name "Apple Reminders MCP"
  desc "MCP server that gives AI agents native read and write access to Reminders"
  homepage "https://github.com/xiaofeng-han/apple-mcp/blob/main/docs/reminders.md"

  livecheck do
    url "https://github.com/xiaofeng-han/apple-mcp"
    regex(/^reminders-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "AppleRemindersMCP.app"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold the Reminders permission itself.
  command_wrapper "apple-reminders-mcp",
                  executable: "#{appdir}/AppleRemindersMCP.app/Contents/MacOS/AppleRemindersMCP"

  # The app is signed with a self-signed certificate, not a Developer ID, so Gatekeeper refuses to
  # start it while it carries the quarantine Homebrew puts on downloads. The release package it was
  # installed from before never had that attribute; removing it keeps the app starting as it did.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AppleRemindersMCP.app"]
  end

  zap trash: [
    "~/Library/Application Support/AppleRemindersMCP",
    "~/Library/Preferences/com.xiaofeng.apple-reminders-mcp.plist",
  ]

  caveats <<~EOS
    To allow access to Reminders, run:
      apple-reminders-mcp setup

    Then register this command with your agents:
      #{HOMEBREW_PREFIX}/bin/apple-reminders-mcp --stdio
  EOS
end
