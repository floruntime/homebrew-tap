class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.11"

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.11/flo-aarch64-macos.tar.gz"
      sha256 "f077cdab704b86cc3c33cf2e02238aab3d270774281ee3cd5d76e09a12fc7895"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.11/flo-x86_64-macos.tar.gz"
      sha256 "964d3f80fb9a9e99c2886128b487e32dcf21022b340b8a19d2f18f41bf7a00a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.11/flo-aarch64-linux.tar.gz"
      sha256 "2f1de560ba1e414eb3a9f5a5015f72c1231925458e87a82c5e044def3954f5b5"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.11/flo-x86_64-linux.tar.gz"
      sha256 "44175b6bae15084314ab042a6811f874767100b551cb77564691aa1813b6e5bc"
    end
  end

  def install
    bin.install "flo"
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
