#!/bin/sh
echo "$PR Ruby & RVM"

# #-------------------- Install RVM and Ruby --------------------
# echo -e "$PG Installing RVM and Ruby"
# curl -sSL https://get.rvm.io | bash -s stable --ruby

# source $HOME/.rvm/scripts/rvm

# if [ $? -eq 0 ]; then
#    echo -e "$PG RVM and Ruby installed successfully"
# else
#    echo -e  "$PR Somethihng went wrong installing RVM and Ruby "
# fi

# echo -e "$PG  load bash profile into shell"
# source $HOME/.bash_profile

# # Print out the Ruby and RVM versions
# echo -e "$PG Check RVM and Ruby versions"
# rvm -v
# ruby -v