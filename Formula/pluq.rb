class Pluq < Formula
  desc "Snipe one file out of a huge cloud ZIP/RAR without downloading the whole archive"
  homepage "https://github.com/stefandekanski/pluq"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-aarch64-apple-darwin.tar.xz"
      sha256 "f3ec667b75f59fa0b8272baae6fc11222df7b0cf1d07a5144c883fb48025bf5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-x86_64-apple-darwin.tar.xz"
      sha256 "4d94f687a7d41a20e9664587e3f7e28f09d72ff02c3cccb7d98ace249616873d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79b3feae5d70370d37655feeacaac80b70b56b6b2fe17b9a25471d89f3961b3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stefandekanski/pluq/releases/download/v0.1.0/pluq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc9d6d9cb8f66cd27c5c023bd6ac14ae85da389dc913218d0679244d9e1e2db7"
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
