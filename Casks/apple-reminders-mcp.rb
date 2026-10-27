cask "apple-reminders-mcp" do
  version "0.4.0"
  sha256 "ce99f5ae7bb3a80e9412ef219db1e8711b6d8947e1f510a89ac823ee88b2d000"

  url "https://github.com/xiaofeng-han/apple-mcp/releases/download/reminders-v#{version}/AppleRemindersMCP-#{version}.pkg"
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

  pkg "AppleRemindersMCP-#{version}.pkg"
  # A script that execs the app's executable, not a symlink to it: started through a symlink, the
  # app cannot find its bundle and so cannot hold the Reminders permission itself.
  command_wrapper "apple-reminders-mcp",
                  executable: "/Applications/AppleRemindersMCP.app/Contents/MacOS/AppleRemindersMCP"

  uninstall pkgutil: "com.xiaofeng.apple-reminders-mcp.pkg"

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
