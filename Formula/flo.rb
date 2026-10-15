class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.13"
  license "Apache-2.0"

  depends_on macos: :sequoia

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.13/flo-aarch64-macos.tar.gz"
      sha256 "11528205531f78b5cca556523abf33822296b4ef06cb0eea3796121423ad1660"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.13/flo-x86_64-macos.tar.gz"
      sha256 "447033a0d197811dca8f48131d207a8fef5bc23f130979e143d347097a547fc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.13/flo-aarch64-linux.tar.gz"
      sha256 "d96a3cc2d1e7ed0f4f9777701d8656c68950fea14979db8e7709835cdb297f46"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.13/flo-x86_64-linux.tar.gz"
      sha256 "7b682ecce787f30e8abaca9602df8f63f1ea4a4a9ccead083f4cf79447dd5566"
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
