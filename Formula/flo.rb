class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.15"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.15/flo-aarch64-macos.tar.gz"
      sha256 "206922b7eecd1f76387952e68db1991256cdb712c9f5a4569209660855c46d10"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.15/flo-x86_64-macos.tar.gz"
      sha256 "30f7ee15da8c2d1ff713ddcf9bfc0c217079688c867061ad289e747065c7874f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.15/flo-aarch64-linux.tar.gz"
      sha256 "092b00c4ce47d8d72d37446bf3a21b9eb75c353c1feff5e774885f86e5418062"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.15/flo-x86_64-linux.tar.gz"
      sha256 "d1e2275e17bb1fd79f153678943d18fad6543e630bd7595dfdbcacb62490eaf3"
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
