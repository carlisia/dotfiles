#!/usr/bin/bash

# install brew
if ! hash brew
then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 else
  printf "\e[93m%s\e[m\n" "You already have brew installed."
fi 

brew update



