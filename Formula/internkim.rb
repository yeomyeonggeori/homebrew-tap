# typed: false
# frozen_string_literal: true

# Rendered by `internkim release brew` from internal/runtime/blueclaw.
# Edit that package, not this file: a hand edit here is a second
# declaration of the same dependency list.
class Internkim < Formula
  desc "Run your company's agent, messenger and web app on this computer"
  homepage "https://intern.kim"
  url "https://updates.intern.kim/brew/internkim-0.0.0+20260922.4e72add3d8cc.tar.gz"
  sha256 "e2eb99fcfb6aebcfc66be6dfc11a7703b7fba4cfb8564f92a31d0962de9f96ca"
  license "Apache-2.0"
  version "0.0.0+20260922.4e72add3d8cc"

  bottle do
    root_url "https://updates.intern.kim/brew"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "331af7dce3662a8a8205fe5fb31f17d86a4894e7aced78f3d6e9ff4a1dfbc113"
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
    venv = libexec/"document-venv"
    return if (venv/"bin/python").exist?

    system libexec/"uv", "venv", "--python", libexec/"python/bin/python3.13", venv
    system libexec/"uv", "pip", "install", "--python", venv/"bin/python", "--no-index", "--find-links", libexec/"document-wheels", "--requirements", libexec/"document-requirements.txt"
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

      A formula cannot depend on a cask, so these are yours to install:
        brew install --cask google-chrome — the skills that render slides and print documents drive a browser; without one they are withheld. The chromium cask cannot be installed at all: it does not pass the macOS Gatekeeper check (disabled upstream on 2026-09-01)
    EOS
  end

  test do
    assert_predicate libexec/"blueclaw-posix-helper", :exist?
    assert_predicate libexec/"skills", :directory?
    system libexec/"document-venv/bin/python", "-c", "import plistlib, platform, xml.etree.ElementTree, docx, openpyxl, fpdf, pptx, lxml, PIL, pypdf, yaml, xlsxwriter, fontTools"
    assert_match "internkim", shell_output("#{bin}/internkim --help 2>&1", 1)
  end
end
