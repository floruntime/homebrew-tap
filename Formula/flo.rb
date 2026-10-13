class Flo < Formula
  desc "Streams, queues, KV, workflows and processing in one runtime"
  homepage "https://github.com/floruntime/flo"
  version "0.1.0-dev.12"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.12/flo-aarch64-macos.tar.gz"
      sha256 "3f938fbe3d290c898cdd83c1bd87753178daf0ed38c345b01908d47c93f7d10c"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.12/flo-x86_64-macos.tar.gz"
      sha256 "297c7a0a08b763c4d45b44074d9705ffc4dc172e1ef14eec353b094ee7b6cfeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.12/flo-aarch64-linux.tar.gz"
      sha256 "feb2889cb3a2db14fd6a3acb4e268c75a1ff543086e448b9e379eb4338bc211d"
    end
    on_intel do
      url "https://github.com/floruntime/flo/releases/download/v0.1.0-dev.12/flo-x86_64-linux.tar.gz"
      sha256 "810a98cf53fbcaf3ac5fb19a48c03fcb4b4442ffde01ce49c29daaff8401b46b"
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
