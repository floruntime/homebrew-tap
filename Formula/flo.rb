class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.16"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.16/flo-aarch64-macos.tar.gz"
      sha256 "1943b5eede13bdda0861d341132b77f130ad044a4b074823c76a507f337204b0"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.16/flo-x86_64-macos.tar.gz"
      sha256 "77cbf38f5fd8320071ba776476d2cd58ff8182b89d4926f0ea70cccd2e979242"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.16/flo-aarch64-linux.tar.gz"
      sha256 "9d3ebeb134c59359b1d60725562e2324ed79cb92b181dd3c6f1691eae70d27e1"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.16/flo-x86_64-linux.tar.gz"
      sha256 "a4e7304506f699aab8bb2dd1b5a36edc1c9602a288c4af1d28bb48603f9ca6e4"
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
