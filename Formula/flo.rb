class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.18"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.18/flo-aarch64-macos.tar.gz"
      sha256 "613b245bdde4b407bfaa62903261f80d93750cc58961e9f3ddd849658ac80d49"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.18/flo-x86_64-macos.tar.gz"
      sha256 "57e7aef212c1781b94c85e13621d8fa1f093b08f428cb3a42c21d4149592b259"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.18/flo-aarch64-linux.tar.gz"
      sha256 "7361bdfb0cc762ef2493eec0d42aa77c5b6c45f75659fe645544e9a11b37516c"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.18/flo-x86_64-linux.tar.gz"
      sha256 "8e71d271ddafde9715050d5cb8377124ed15f7f258034386a3fed9a32df62198"
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
