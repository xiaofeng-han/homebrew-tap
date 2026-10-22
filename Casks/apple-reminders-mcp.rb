cask "apple-reminders-mcp" do
  version "0.3.0"
  sha256 "74692f797f01980797128278d20e92eeae8ada238658302c5fab7b7f287442a8"

  url "https://github.com/xiaofeng-han/apple-reminders-mcp/releases/download/v#{version}/AppleRemindersMCP-#{version}.pkg"
  name "Apple Reminders MCP"
  desc "MCP server that gives AI agents native read and write access to Reminders"
  homepage "https://github.com/xiaofeng-han/apple-reminders-mcp"

  livecheck do
    url :url
    strategy :github_latest
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
