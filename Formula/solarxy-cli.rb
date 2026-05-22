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
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1b23d44896048eb689eff69c4cc33e195bd236c0e9b959477e06d9718c712e2b"
    end
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2f849387404597dad565f20167797fa33ce11942baccec30054bb11c040137f5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edc3d069cf9ec090cc19ed37686cbee5b55ac6f1da483e54c55749a8c3860325"
    end
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "421a7f94a089b13ca05975d42ababd2736d61e5810295d0daff70c393b3af09b"
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
