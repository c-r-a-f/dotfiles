# Set SymbolicLink
for f in .??*; do
    [ "$f" = ".gitconfig.local.template" ] && continue
    [ "$f" = ".gitmodules" ] && continue
    [ "$f" = ".DS_Store" ] && continue

    ln -snfv ~/dotfiles/"$f" $HOME
done

# Set SymbolicLink for neovim
ln -snfv ~/dotfiles/.vim $HOME/.config/nvim
ln -snfv ~/dotfiles/.vimrc $HOME/.config/nvim/init.vim
