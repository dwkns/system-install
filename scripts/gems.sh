#!/bin/sh
echo -e "$PG Gems"

#-------------------- Install some Ruby gems --------------------
echo -e "$PG Installing some gems"

gems=( "bundler" )
gems=( "bundler" "rails" )
for pkg in "${gems[@]}"
do
  gem install $pkg

done

