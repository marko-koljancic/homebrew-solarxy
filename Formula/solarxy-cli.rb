# Solarxy CLI formula. Lives in the marko-koljancic/homebrew-solarxy tap.
#
# Usage:
#   brew install marko-koljancic/solarxy/solarxy-cli
#
# Cross-platform: macOS arm64 + macOS x86_64 + Linux x86_64 + Linux
# aarch64. Each variant downloads the cargo-dist-produced tarball that
# matches the host triple. Sha256 values are auto-bumped per release by
# .github/workflows/homebrew-bump.yml.

class SolarxyCli < Formula
  desc "Solarxy CLI: terminal companion to the Solarxy 3D model viewer"
  homepage "https://github.com/marko-koljancic/solarxy"
  version "0.9.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "eb9a0bb706876e9571cf68158208a84989cb9eaff56fe5798605b98f20171080"
    end
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "77685c7296817650938556dece4afb3f31228e9a518207a35142f84412fc9dbc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d10104ca23fbae67196d017facc6064d0681472f9809b8283f15374773fed6ae"
    end
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81658c78c5fe9cbcbafc344d26553b49aed89215cdaea97a65344164885cd48c"
    end
  end

  def install
    bin.install "solarxy-cli"

    # Write the install-source marker so `solarxy-cli --update` refuses
    # to run axoupdater (which would corrupt this brew-managed install).
    marker_dir = if OS.mac?
      "#{Dir.home}/Library/Application Support/Solarxy"
    else
      "#{ENV.fetch("XDG_DATA_HOME", "#{Dir.home}/.local/share")}/solarxy"
    end
    mkdir_p marker_dir
    (Pathname.new(marker_dir) / "install-source").write("homebrew-formula\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/solarxy-cli --version")
  end
end
