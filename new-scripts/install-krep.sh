 source "$HOME/.system-config/scripts/colours.sh"

msg "Installing Krep"

  ps cax | grep Krep > /dev/null # Is Krep running?

  if [ $? -eq 0 ]; then # yep, killing it
    warn "Krep is running. Killing it"
    killall -9 Krep
  fi

  if [  -d "/Applications/Krep.app" ]; then # is Krep installed
    warn "Krep is installed, skipping"
  else
    mkdir -p /tmp/krep
    curl -L https://github.com/dwkns/krep/archive/master.zip -o  "/tmp/krep/Krep.zip"

    unzip -o -q "/tmp/krep/Krep.zip" -d "/tmp/krep"
    cp -rf "/tmp/krep/krep-master/Krep.app" "/Applications"
    rm -rf "/tmp/krep/krep-master"
    rm -rf "/tmp/krep/Downloads/Krep.zip"

    # dockutil --add "/Applications/Krep.app" --no-restart

  fi
  note "done"