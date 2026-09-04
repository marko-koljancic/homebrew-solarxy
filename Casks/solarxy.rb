# Solarxy GUI cask. Lives in the marko-koljancic/homebrew-solarxy tap.
#
# Usage:
#   brew install --cask marko-koljancic/solarxy/solarxy
#
# This cask handles the macOS Gatekeeper friction that the bare DMG
# download cannot. The `postflight` block strips
# com.apple.quarantine from the installed .app and writes the
# install-source marker so the GUI's "Check for Updates" suggests
# `brew upgrade --cask` rather than the GitHub releases page.
#
# Note: stripping quarantine via postflight is rare in cask but
# legitimate here — Solarxy is ad-hoc signed (not Apple-Developer-ID
# signed), and the alternative is requiring users to right-click-Open
# every time they install or upgrade. Cask is the only distribution
# channel where we can do this without a separate user gesture.
#
# The per-arch sha256 values are filled by the release pipeline
# (.github/workflows/homebrew-bump.yml in the solarxy repo) from the
# `.dmg.sha256` companions that native-bundle publishes beside each DMG.
# They replaced `sha256 :no_check`, which was not a free simplification: with
# no integrity gate, a download or staging failure surfaces only while moving
# the app artifact, which is after the installed app has already been removed.
# That is how a 0.6.0 -> 0.7.0 upgrade left a machine with no Solarxy at all.

cask "solarxy" do
  version "0.9.0"
  sha256 arm:   "3011873ac0ffa633af1485fd69cb2fa7ab0402b3b4a975616e25b259ace92f17",
         intel: "f09791782ed9a317a118bf2aa8708f25a3bd635c86e088b0f8e51b2fc29d0ee6"

  on_arm do
    url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/Solarxy-#{version}-aarch64.dmg"
  end

  on_intel do
    url "https://github.com/marko-koljancic/solarxy/releases/download/v#{version}/Solarxy-#{version}-x86_64.dmg"
  end

  name "Solarxy"
  desc "3D model viewer and validator (Rust + wgpu)"
  homepage "https://github.com/marko-koljancic/solarxy"

  # Matches LSMinimumSystemVersion in the .app's Info.plist (see
  # .github/actions/native-bundle/action.yml). Naming the per-arch sha256
  # values declares this cask macOS-only, so the bound is now explicit rather
  # than implied: an unsupported host gets a clear refusal instead of an app
  # that installs and will not launch.
  depends_on macos: :big_sur

  app "Solarxy.app"

  postflight do
    require "fileutils"
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Solarxy.app"],
                   sudo: false

    marker_dir = "#{Dir.home}/Library/Application Support/Solarxy"
    FileUtils.mkdir_p(marker_dir)
    File.write("#{marker_dir}/install-source", "homebrew-cask\n")
  end

  # No `uninstall delete:` stanza: the `app` stanza above already installs AND
  # uninstalls Solarxy.app. The redundant `delete:` ran a sudo `rm` (the only
  # reason this cask ever prompted for a password) and removed the old app
  # unconditionally, so a failed upgrade left nothing behind instead of
  # rolling back to the working version.

  zap trash: [
    "~/Library/Application Support/Solarxy",
    "~/Library/Preferences/dev.koljam.solarxy.plist",
    "~/Library/Saved Application State/dev.koljam.solarxy.savedState",
    "~/.config/solarxy",
  ]
end
