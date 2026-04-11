# LLVM / Clang Configuration
# Homebrew installs LLVM to a specific location to avoid Apple's version
if test -d /opt/homebrew/opt/llvm/bin
    # This prepends the path so Neovim finds Brew's clangd/clang-format FIRST
    fish_add_path /opt/homebrew/opt/llvm/bin
    
    # set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
    # set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
end
