# typed: false
# frozen_string_literal: true

# Rendered by `internkim release host` from internal/runtime/blueclaw.
# Edit that package, not this file: a hand edit here is a second
# declaration of the same dependency list.
class Internkim < Formula
  desc "Run your company's agent, messenger and web app on this computer"
  homepage "https://intern.kim"
  url "https://github.com/yeomyeonggeori/internkim/releases/download/v2026.10.03.045216/internkim-macos-arm64.tar.gz"
  sha256 "6273495b31ef91562ffea72b28bfa2ebbad25c5ba6527decd5d586e27f9489e5"
  license "Apache-2.0"
  version "2026.10.03.045216"

  bottle do
    root_url "https://github.com/yeomyeonggeori/internkim/releases/download/v2026.10.03.045216"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cabd6160fd0d62cbadf5942927213d02de079c15b996f8ee2fdf99f8b7a65ec8"
  end

  depends_on "postgresql@17"
  depends_on "redis"
  depends_on "git"
  depends_on "openssl@3"
  depends_on "jq"
  depends_on "fontconfig"
  depends_on :macos

  def install
    bin.install Dir["bin/*"]
    libexec.install Dir["libexec/*"]
  end

  def post_install
    system "env", "UV_PYTHON_INSTALL_DIR=#{HOMEBREW_PREFIX}/opt/internkim/libexec/python", "UV_PYTHON_BIN_DIR=#{HOMEBREW_PREFIX}/opt/internkim/libexec/python/bin", "#{HOMEBREW_PREFIX}/opt/internkim/libexec/uv", "--no-cache", "python", "install", "--default", "--preview-features", "python-install-default", "3.13.13"
    system "#{HOMEBREW_PREFIX}/opt/internkim/libexec/uv", "--no-cache", "venv", "--clear", "--no-python-downloads", "--python", "#{HOMEBREW_PREFIX}/opt/internkim/libexec/python/bin/python3", "#{HOMEBREW_PREFIX}/opt/internkim/libexec/document-venv"
    system "#{HOMEBREW_PREFIX}/opt/internkim/libexec/uv", "--no-cache", "pip", "sync", "--require-hashes", "--no-build", "--python", "#{HOMEBREW_PREFIX}/opt/internkim/libexec/document-venv/bin/python", "#{HOMEBREW_PREFIX}/opt/internkim/libexec/document-conversion/requirements.txt"
    system "#{HOMEBREW_PREFIX}/opt/internkim/libexec/document-venv/bin/python", "-c", "import plistlib, platform, xml.etree.ElementTree, anydoc, bs4, markdownify, pypdf, pypdfium2"
    system "#{HOMEBREW_PREFIX}/opt/internkim/bin/internkim", "prepare-skills"
    if File.exist?("/var/lib/internkim/current")
      odie "this release is installed and the company's server did not come back on it. Once that is fixed, run: sudo internkim refresh" unless system "sudo", "#{HOMEBREW_PREFIX}/opt/internkim/bin/internkim", "refresh"
    end
  end

  def caveats
    <<~EOS
      This installed the programs. It did not start anything: every service stays
      idle until this computer has a company.

      Give it one with the connection file you downloaded from company setup:
        sudo internkim install ~/Downloads/internkim-host.json

      That step needs administrator rights because it creates the service accounts,
      makes the POSIX helper setuid root, and writes the LaunchDaemons into
      /Library/LaunchDaemons.
    EOS
  end

  test do
    assert_predicate libexec/"blueclaw-posix-helper", :exist?
    assert_predicate libexec/"skills", :directory?
    assert_match "internkim", shell_output("#{bin}/internkim --help 2>&1", 1)
  end
end
