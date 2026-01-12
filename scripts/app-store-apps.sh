# Installs App Store software.
# https://github.com/mas-cli/mas

# EXECUTION
# Homebrew
if ! command -v mas > /dev/null; then
  printf "ERROR: Mac App Store CLI (mas) can't be found.\n"
  printf "       Please ensure Homebrew and mas (i.e. brew install mas) have been installed first."
  exit 1
fi

# mas install 1508732804 # Soulver 3 (3.4.7) — Download from Soulver and use:
# dwkns@me.com &CAAFCF60-E2FDF2D2-578E4508-8F34DA76-9A0CA1B8

mas install 904280696  # Things (3.9.1)

# mas install 1289583905 # Pixelmator Pro (1.3.4)
# mas install 414209656  # Better Rename 9 (9.52)
# mas install 824171161  # Affinity Designer (1.7.1)
# mas install 1055273043 # PDF Expert (2.5.4)
# mas install 424389933  # Final Cut Pro (10.4.6)

mas install 409183694  # Keynote (9.1)
 mas install 409203825  # Numbers (6.1)
 mas install 409201541  # Pages (8.1)

