#!/bin/bash
######################## NODE ########################

############ CONFIG ############
NODE_PACKAGES=( "jshint" "http-server" "gulp" )

############ FUNCTIONS ############
install_node () {
   if brew list -1 | grep -q "^node\$"; then
       echo -e "$PY Node is installed, skipping it..."
     else
       echo -e "$PG Installing node..."
       brew install "node"
    fi

}

install_node_packages () {
  for pkg in "${NODE_PACKAGES[@]}"
  do
       echo -e "$PG Installing '$pkg'..."
       npm install -g  $pkg
   done
}

############ SCRIPT ############
echo -e "$PG Configuring Node"


install_node;
install_node_packages

