# Install xcode command line tool
xcode-select --install

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi
fi

sudo -v

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew doctor
brew update
brew upgrade --all

# Install brew packages
brew install axel
brew install ctags
brew install doxygen
brew install fish
brew install fisherman
brew install freetype
brew install gdbm
brew install git
brew install graphicsmagick
brew install highlight
brew install icu4c
brew install wget  --with-iri
brew install jpeg
brew install libevent
brew install libpng
brew install libtiff
brew install libtool
brew install libyaml
brew install lua
brew install mas
brew install mysql
brew install node
brew install nodebrew
brew install neovim
brew install openssl
brew install pcre
brew install peco
brew install perl
brew install python
brew install readline
brew install ruby
brew install sqlite
brew install tmux
brew install utf8proc
brew install vim --with-lua --devel --with-override-system-vi
brew install nvim
brew install wget
brew install zplug
brew install zsh
brew install zsh-completions

brew tap universal-ctags/universal-ctags
brew cleanup

# Set login shell
chmod +x ~/etc/shells
sudo echo /usr/local/bin/zsh >> /etc/shells
chsh -s /usr/local/bin/zsh

# install plugin manager for zsh
git clone https://github.com/b4b4r07/zplug ~/.zplug
