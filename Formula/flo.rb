class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.22"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.22/flo-aarch64-macos.tar.gz"
      sha256 "af1fa6fbb84b705c8dc5ccfdcbc89065dad266d496e89d7b15ce28af21e5f1c0"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.22/flo-x86_64-macos.tar.gz"
      sha256 "1b54769c6b5f4cda82569689917e614a05e295947b9abdcbd5f8490617920440"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.22/flo-aarch64-linux.tar.gz"
      sha256 "9b6f729925c842b5644038e34076e604309a96d4ea135bc9b043c1400558eb31"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.22/flo-x86_64-linux.tar.gz"
      sha256 "87aedd22980892db758ed72bb10134f3ef7b3cb373e718c57650692c6006b3ed"
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
