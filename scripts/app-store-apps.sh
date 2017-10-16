#! /usr/bin/env bash

# DESCRIPTION
# Installs App Store software.

# EXECUTION
# Homebrew
if ! command -v mas > /dev/null; then
  printf "ERROR: Mac App Store CLI (mas) can't be found.\n"
  printf "       Please ensure Homebrew and mas (i.e. brew install mas) have been installed first."
  exit 1
fi



mas install 424389933  # Final Cut Pro (10.3.4)
mas install 904280696  # Things3 (3.2)
mas install 409183694  # Keynote (7.3)
mas install 584653203  # Paw (2.3.4)
mas install 407963104  # Pixelmator (3.7)
mas install 443987910  # 1Password (6.8.2)
mas install 434290957  # Motion (5.3.2)
mas install 403388562  # Transmit (4.4.13)
mas install 1147396723 #  WhatsApp (0.2.5863)
mas install 1016288391 #  My Controller for BOSE SoundTouch devices (1.8.1)
mas install 409201541  # Pages (6.3)
mas install 1031280567 #  Postico (1.2.1)
mas install 413965349  # Soulver (2.6.4)
mas install 402383384  # Base (2.4.12)
mas install 1176895641 #  Spark (1.5.1)
mas install 803453959  # Slack (2.8.1)
mas install 824171161  # Affinity Designer (1.5.5)
mas install 414209656  # Better Rename 9 (9.52)
