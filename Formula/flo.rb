class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.17"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.17/flo-aarch64-macos.tar.gz"
      sha256 "7f965bdb9009c47f6533e27a5d861c1a0c35e2fad3e3f5edeb0ce3f8c6a394be"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.17/flo-x86_64-macos.tar.gz"
      sha256 "95adb180b7adfb6d70da6d244685396ee63d0cc6462a3e597dc246905023b08c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.17/flo-aarch64-linux.tar.gz"
      sha256 "3cd959d7bb7f4e1f8c92ef69551e47c2f97cfc163169203cb9d2e7f0f4f059d6"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.17/flo-x86_64-linux.tar.gz"
      sha256 "93f8dc8c80da9eb8b892cbc4f3d3b8b2ffe493363dbf2d381d19e7acbadaa3dd"
    end
  end

  def install
    check_cpu_floor if OS.linux?
    bin.install "flo"
  end

  # The binaries need hardware CRC32C: x86-64-v2, or ARMv8 with CRC. Below that
  # flo stops with an illegal instruction, so refuse here. The same check is in
  # flo's scripts/install.sh and packaging/scripts/preinstall.sh.
  def check_cpu_floor
    flags = Hardware::CPU.flags || []
    needed, own_flag = if Hardware::CPU.arm?
      [%w[crc32], "fp"]
    else
      [%w[cx16 lahf_lm pni popcnt sse4_1 sse4_2 ssse3], "fpu"]
    end
    # Empty, or another arch's line (under emulation cpuinfo describes the host).
    unless flags.include?(own_flag)
      opoo "Could not read this CPU's flags; flo needs an x86-64-v2 CPU or ARMv8 with CRC."
      return
    end
    missing = needed - flags
    return if missing.empty?

    odie "flo needs an x86-64-v2 CPU or ARMv8 with CRC; this CPU lacks: #{missing.join(" ")}."
  end

  def caveats
    <<~EOS
      Start a server:
        flo server start
      Clients connect on port 9000 (set FLO_ENDPOINT to point the CLI elsewhere);
      the dashboard listens on http://127.0.0.1:9002.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flo version")
  end
end
