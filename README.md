# Configuration files

## Setup
Dotfile repository used to store all configuration files.

```
git clone https://nicovince@github.com/nicovince/dotfiles.git ${HOME}/.dotfiles
cd $HOME/.dotfiles
./init_config.sh
```

## Hooks
Install `pre-commit`:
```
pip install pre-commit
cd $HOME/.dotfiles
pre-commit install --hook-type pre-commit --hook-type commit-msg
```
