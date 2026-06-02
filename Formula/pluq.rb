class Pluq < Formula
  desc "Surgical archive extraction from local and cloud storage — snipe one file out of a huge ZIP/RAR without downloading the whole thing."
  homepage "https://github.com/stefandekanski/pluq"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-aarch64-apple-darwin.tar.xz"
      sha256 "bded48dd7bd384357a3c73e2e00e5385c75b4cb3978d6c97cb856eaa9ede98e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-x86_64-apple-darwin.tar.xz"
      sha256 "940e32957828b3b3174eab237b833c317f2d17275dde3bc2c0343c9dcf7d54f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bb8fdee67de863aa44b384fdd66cc9c90d43caf81f2bbfb105c98d61e5c4dfb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02fd6b9bc05621ee907f7ee90b000fb220c68a4a17b13c332b199aeea0a7a215"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pluq" if OS.mac? && Hardware::CPU.arm?
    bin.install "pluq" if OS.mac? && Hardware::CPU.intel?
    bin.install "pluq" if OS.linux? && Hardware::CPU.arm?
    bin.install "pluq" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
