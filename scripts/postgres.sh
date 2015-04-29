#!/bin/bash
######################## POSTGRES ########################

############ FUNCTIONS ############


install_postgres () {

    echo -e "$PG Installing postgres..."
    brew install "postgresql"

    echo -e "$PG ...and configure"
    # the wrong permissions get set on the db folder
    rm -rf /usr/local/var/postgres # remove the old.
    mkdir /usr/local/var/postgres # create a new
    chmod 0700 /usr/local/var/postgres # set the permissions
    initdb -D /usr/local/var/postgres # create a new db folder

    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents #lauch at start up
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist #launch now

}

############ SCRIPT ############
echo -e "$PG Configuring Postgres"

install_postgres




