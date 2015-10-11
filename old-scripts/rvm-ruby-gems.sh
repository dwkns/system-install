#!/bin/bash
msg "Installing RVM & Ruby"

curl -sSL https://get.rvm.io | bash -s stable --ruby

source $HOME/.rvm/scripts/rvm

if [ $? -eq 0 ]; then
  echo "RVM and Ruby installed successfully"
  echo `type rvm | head -n 1`
else
   warn "Something went wrong installing RVM and Ruby "
fi
note "done"

# Print out the Ruby and RVM versions
msg "Check RVM and Ruby versions"
rvm -v
ruby -v
note "done"


msg "Installing some gems"

  for pkg in "${GEMS[@]}"
do
  gem install $pkg
done
note "done"

