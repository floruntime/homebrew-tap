class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.20"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.20/flo-aarch64-macos.tar.gz"
      sha256 "ac76b693b961850fa443670207045c7dbc66dc74e97a25c96cd4d475a2185be0"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.20/flo-x86_64-macos.tar.gz"
      sha256 "19d6cd8b7e04e86ee0e4564487916b933856d6f26cb642fc4df683dc2ddc04c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.20/flo-aarch64-linux.tar.gz"
      sha256 "14d65354845ed42b0d9c7b191dcaa1df3bc48f509b4b1c3d2ab325aa42c981f0"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.20/flo-x86_64-linux.tar.gz"
      sha256 "a4ad145a3a13b790921d0dedc97714fc2f85e3d5907bf4cd11ac23251df699f8"
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
