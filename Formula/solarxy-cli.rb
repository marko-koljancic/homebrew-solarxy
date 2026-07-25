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
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6b2128a7bf6aa3398d8802bf2c584372c60c474868e96cdabbebed605533e924"
    end
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "491b5fc4a397dbfd8da02fe5d32010b85fe036d6ff1f57a1db4b664ee74a5eb4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18b7f10d51aee0c207e81dcc0c9b99de448c7c2190444fa1c248074dfccd358e"
    end
    on_arm do
      url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/solarxy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cbecdd1a66dd363d646d3b14c91313a282a6aebbde669ee75b76c9c05065fc61"
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
