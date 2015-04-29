#!/bin/bash
echo -e "$PG Ruby & RVM"

#-------------------- Install RVM and Ruby --------------------
echo -e "$PG Installing RVM and Ruby"
curl -sSL https://get.rvm.io | bash -s stable --ruby

source $HOME/.rvm/scripts/rvm

if [ $? -eq 0 ]; then
   echo -e "$PG RVM and Ruby installed successfully"
else
   echo -e  "$PR Something went wrong installing RVM and Ruby "
fi

# Print out the Ruby and RVM versions
echo -e "$PG Check RVM and Ruby versions"
rvm -v
ruby -v