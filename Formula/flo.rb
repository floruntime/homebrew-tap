class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.23"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.23/flo-aarch64-macos.tar.gz"
      sha256 "fcfef398dc9b6c5dabe4f3ba4b3ba3c6cd74cbf5f907bd455b7bd5ba68ba6be9"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.23/flo-x86_64-macos.tar.gz"
      sha256 "e87e7b14db4c60365bbf37fc136ab00c4fd4c0a6bf2d2d7baf412f1f425870c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.23/flo-aarch64-linux.tar.gz"
      sha256 "cd08594e7878c73a730039feecf9b94cbd3a26a7929a70d6c59c99f7631b0350"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.23/flo-x86_64-linux.tar.gz"
      sha256 "9621bd025ca975432cdc79137fa1fa8c42dd8d7f5b44a38954d4ce128f697ca7"
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
