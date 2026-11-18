class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.19"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.19/flo-aarch64-macos.tar.gz"
      sha256 "5a47c6ad025e9a30e8f7ad48188df3470eaec90f63fe3107c1f045534a59bdb5"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.19/flo-x86_64-macos.tar.gz"
      sha256 "8dc9dd5481cc88d65adab6ea2837eb300e8bbb23ef3fb93cd70283ea8ddb78c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.19/flo-aarch64-linux.tar.gz"
      sha256 "e7c9b43a623a319f18ef46cee74e17d972f6c287d4ea41d99ce3f77b745fe7f5"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.19/flo-x86_64-linux.tar.gz"
      sha256 "882a06cbcbb6732a4230ea755809e04c625bda7c84e60c41a2d13a7a0d9e3e9f"
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
