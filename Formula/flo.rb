class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.14"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.14/flo-aarch64-macos.tar.gz"
      sha256 "7929c94580c3e68b6c97201a0f162632c2a4570a1b81168db286d6fce37c4d1b"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.14/flo-x86_64-macos.tar.gz"
      sha256 "8bd080b6968fe2d24ad8c59f64a4704f9e2e77208e77ff8b6e7ff50fe12b1688"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.14/flo-aarch64-linux.tar.gz"
      sha256 "e9840d409eb67206f4a4d86f8e9644d658718b2951aff011cfb41436842f4a67"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.14/flo-x86_64-linux.tar.gz"
      sha256 "fc21fbf11b11dca511fe25a2e96a78271a9b8698e7121d1a77de1af99db7e0a9"
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
