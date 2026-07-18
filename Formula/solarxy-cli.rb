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
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8fe4824ae6d7c210f7e3d27fa509d48ae66d4f0dace978360d8bd70e45ed58be"
    end
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "555229d00405ae29e22caceeec0296f2dd0b2d837b35009305613011f2ee86d7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cfa9c76f2087f19f739b601e3edc9b77ce200b6dd164ad5532afc60da1e98d6d"
    end
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f32b1570ed541a77a53b1b1e90dd7d0cce226ba8847d81cc6b84b52a289e1af"
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
