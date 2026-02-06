class AutocompleteRs < Formula
  desc "Fast, universal terminal autocomplete for all shells and terminals"
  homepage "https://github.com/jbabin91/autocomplete-rs"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jbabin91/autocomplete-rs/releases/download/v0.1.3/autocomplete-rs-aarch64-apple-darwin.tar.xz"
      sha256 "92712b6b3faad8e522ff170fa1b9e2c7af02ff764a02b3eb773f3ec029f11220"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jbabin91/autocomplete-rs/releases/download/v0.1.3/autocomplete-rs-x86_64-apple-darwin.tar.xz"
      sha256 "584da3b937e066abf9a6d3337359c1119dc5db8ada2326420854100c5b41736c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jbabin91/autocomplete-rs/releases/download/v0.1.3/autocomplete-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c8ee02c9094ed79e07c9930a0266b38dba951d780ac37f34a6064ed973c3c94f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jbabin91/autocomplete-rs/releases/download/v0.1.3/autocomplete-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "22bd02ff714db538caec9e35ad785d5f303943619a8abf8ffc9b768a3d511d0a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "autocomplete-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "autocomplete-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "autocomplete-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "autocomplete-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
