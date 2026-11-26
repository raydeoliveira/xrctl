class Xrctl < Formula
  desc "Control AR glasses display modes and read motion sensors via CLI or MCP"
  homepage "https://github.com/raydeoliveira/xrctl"
  url "https://github.com/raydeoliveira/xrctl/releases/download/v0.1.0/xrctl-0.1.0-macos-arm64.tar.gz"
  version "0.1.0"
  sha256 "0d9dca7be08825a470fbdf4760da2b99cb23bd4bcc78565b25c50b12b91f7df0"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    bin.install "xrctl"
    doc.install "README.md", "LICENSE", "SECURITY.md", "SKILL.md", "server.json"
  end

  test do
    assert_match "xrctl 0.1.0", shell_output("#{bin}/xrctl --version")
    describe_json = shell_output("#{bin}/xrctl --describe")
    assert_match "\"schema_version\":1", describe_json
    assert_match "0x3318", shell_output("#{bin}/xrctl profiles --vendor xreal --json")
    assert_match "XREAL Air", shell_output("#{bin}/xrctl probe --fixture xreal-air --json")
  end
end
