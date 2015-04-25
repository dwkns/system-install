#!/usr/lib/ruby
require 'net/http'
require 'open-uri'

module Tty extend self
  def blue; bold 34; end
  def white; bold 39; end
  def green; bold 92; end
  def red; underline 31; end
  def reset; escape 0; end
  def bold n; escape "1;#{n}" end
  def underline n; escape "4;#{n}" end
  def escape n; "\033[#{n}m" if STDOUT.tty? end
end

def success args
 puts "#{Tty.green}====>#{args}#{Tty.reset}"
end

def msg args
  puts "#{Tty.green}====>#{Tty.white} #{args}#{Tty.reset}"
end

def warn warning
  puts "#{Tty.red}Warning#{Tty.reset}: #{warning.chomp}"
end

def clean quick
  
  if quick then
        msg "Quick clean has started"
      else
       msg "Full clean has started"
  end
  
#  begin
#       `rvm use system`
#      rescue
#         msg "rvm wasn't found - assuming system ruby"
#         msg `ruby -v`
#  end


delete_array = [
   "/usr/local",
   "/Library/Caches/Homebrew",
   "/opt/homebrew-cask",
   "/usr/bin/motion",
   "/Library/RubyMotion",
   "/tmp/homebrew.rb",
   "/tmp/krep",
   "/Applications/Krep.app",
   "~/.bash_profile",
   "~/.git*",
   "~/.rspec",
   "~/.profile",
   "~/.zshrc",
   "~/.zlogin",
   "~/.bashrc",
   "~/.rvm",
   "~/.gem",
   "~/.dropbox",
   "~/.subversion",
   "~/.bash_profile",
   "~/Library/'Application Support/Sublime Text 3'"
 ]


 delete_array.each do |location|
  do_command_print_output "sudo rm -rf #{location}"
		# do_command_print_output "sudo rm -rfv #{location}" #verbose
  end
	#remove symlinks from Application folder - anoying escaping at end.
	

	#show the dashboard
	`defaults write com.apple.dashboard mcx-disabled -boolean false`

	`touch ~/.bash_profile`
    
    
	`source ~/.bash_profile`
    `unset PATH`
    `unset MY_RUBY_HOME`
    `unset GEM_HOME`
    `unset IRBRC`
    `unset OLDPWD`
    `unset rvm_path`
    `unset GEM_PATH`
    `unset RUBY_VERSION`
 
 `export PATH=/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`
    

	#reboot the dock
	`killall Dock`
	msg "Clean has finished"
end

def download_and_write_file url, file_name
	#downloads text from a URL and writes it to file
    encoded_url = URI::encode(url)
	uri = URI(encoded_url)
	script = Net::HTTP.get(uri)
	somefile = File.open(file_name, "w")
	somefile.puts script
	somefile.close
end

def do_command_print_output command
	#runs a command in the terminal and prints out each line of output.
	output = []
	IO.popen(command) do |f|
		f.each do |line|
			puts line.chomp
			output << line.chomp
		end
	end
end

#-------------------- Set things up --------------------

debug = true

# check to see if a '--quick' flag is passed.
if ARGV.any?
  quick = true if ARGV[0].include? "quick"
end


#define some variables
current_path = File.expand_path(File.dirname(__FILE__))
home_dir = ENV['HOME']


#start of the script
success "Starting install from : #{Tty.white}#{current_path}"
msg "Doing a quick install" if quick


#ensure that we're runing everything under sudo
`sudo -v`


#-------------------- Clean the system --------------------
clean quick




# #-------------------- Configure Terminal --------------------


if !quick
    # dowload terminal styles dwkns-dark.terminal
 url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/dwkns-dark.terminal"
 file_name = "#{home_dir}/Downloads/dwkns-dark.terminal"
 download_and_write_file url, file_name

 url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/dwkns-light.terminal"
 file_name = "#{home_dir}/Downloads/dwkns-light.terminal"
 download_and_write_file url, file_name

 # opening the terminal style file loads it into the preferences.
 `open "#{home_dir}/Downloads/dwkns-dark.terminal"`
 `open "#{home_dir}/Downloads/dwkns-light.terminal"`

 # set the default style
 `osascript -e 'tell application "Terminal" to set default settings to settings set "dwkns-dark"'`

 # set the current terminal window the the (new) default style
 `osascript -e 'tell application "Terminal" to set current settings of every tab of (every window whose visible is true) to settings set named "dwkns-dark"'`

 # load the terminal styles in
 `osascript -e 'tell application "Terminal" to close the front window'`
 `osascript -e 'tell application "Terminal" to close the front window'`

 `rm -rf #{home_dir}/Downloads/dwkns-light.terminal`
 `rm -rf #{home_dir}/Downloads/dwkns-dark.terminal`


msg "Downloading iTerm2 Nightly"
url = "https://iterm2.com/nightly/latest"
url = "http://www.iterm2.com/nightly/iTerm2-2_9_20150425-nightly.zip"
file_name = "/Applications/iTerm2.zip"

download_and_write_file url, file_name
`unzip -o /Applications/iTerm2.zip -d /Applications`
`rm /Applications/iTerm2.zip`
end

#-------------------- Set the Hostname --------------------
input = "dwkns-mbp"

#if !quick
#  msg "--- Setting your computer name (as done via System Preferences & Sharing)"
#  puts "What would you like it to be?"
#  input = gets.chomp
#end


#-------------------- Install Homebrew --------------------


#download the homebrew install script and write it to a tmp file
homebrew_uri = URI('https://raw.githubusercontent.com/Homebrew/install/master/install')
homebrew_script = Net::HTTP.get(homebrew_uri)
File.write('/tmp/homebrew.rb', homebrew_script)

#run the script. The yes '' command supresses the need to press 'Enter'
do_command_print_output "yes '' | ruby /tmp/homebrew.rb"
msg "homebrew : #{Tty.green}is now installed"


#check homebrew with brew doctor
output = `brew doctor`
msg "brew doctor : #{Tty.green}#{output}"


#install cask and the version tap
msg "installing cask"
`brew install caskroom/cask/brew-cask`
`brew tap caskroom/versions`
`brew tap caskroom/fonts`


#-------------------- Install Homebrew Packages--------------------
brew_packages = [
	"wget",
	"git",
	"python",
	"node",
	"postgresql",
	"ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265 --with-faac"
]


brew_packages = [
	"git",
	"python"
  ] if quick

  brew_packages.each do |package|
   msg "installing #{package}"
   do_command_print_output "brew install #{package}"
 end

#-------------------- Install nodejs Packages--------------------
if !quick
  nodejs_packages = [
    "jshint",
    "http-server",
    "gulp",
    "bower"
  ]
  nodejs_packages.each do |package|
    msg "installing #{package}"
    do_command_print_output "npm install -g #{package}"
  end
end

#-------------------- Install Cask Applications --------------------
casks = [
 "dropbox",
 "sublime-text3",
 "things",
 "flash",
 "handbrake",
 "omnigraffle",
 "transmission",
 "mplayerx",
 "charles",
 "lightpaper",
 "fluid",
 "codekit",
"font-source-code-pro"

]


casks = ["sublime-text3"] if quick


 casks.each do |cask|
  do_command_print_output "brew cask install --force --appdir='/Applications' #{cask}"

  msg "that should be the install of #{cask}"

  output = `brew cask info #{cask}`
  # will extract the next line after the regex match.
  # The App name / type is after the ==> Contents

  found = false
  data = []
  output.each_line do |line|
    data << line if found
    found = true if line.include? "==> Contents"
  end

  #turn array into string and strip any leading spaces
  app_name_line = data.join.strip


  #Is it an app (not a pkg)
  if app_name_line.include? "(app)"
    #The app is an an (not a pkg)

    #regex everything upto the '.app' whcih leaves the full app name
    app_name = /^(.*?\.app)/.match(app_name_line)

    puts "#{app_name} is the app_name"

    appNameAndPath="/Applications/#{app_name}"
    `defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>#{appNameAndPath}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'`

  elsif app_name_line.include? "(pkg)"
    puts "#{app_name_line} is a package"
  end
end

#-------------------- Configure Postgres --------------------
if !quick
	#configure postgres
	`ln -sfv /usr/local/opt/postgresql/*.plist #{home_dir}/Library/LaunchAgents`
	`launchctl load #{home_dir}/Library/LaunchAgents/homebrew.mxcl.postgresql.plist`
end


#-------------------- Install dotfiles --------------------
#install .rspec
url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/bash.rspec"
file_name = "#{home_dir}/.rspec"
download_and_write_file url, file_name


#install .gitignore_global
url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/bash.gitignore_global"
file_name = "#{home_dir}/.gitignore_global"
download_and_write_file url, file_name


#install .gitconfig
url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/bash.gitconfig"
file_name = "#{home_dir}/.gitconfig"
download_and_write_file url, file_name


#install .gemrc
url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/bash.gemrc"
file_name = "#{home_dir}/.gemrc"
download_and_write_file url, file_name


#install .bash_profile
url = "https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/bash.bash_profile"
file_name = "#{home_dir}/.bash_profile"
download_and_write_file url, file_name


#configure git
msg "Configuring git"
`git config --global core.excludesfile #{home_dir}/.gitignore_global`


#-------------------- Random other configurations --------------------
msg "Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
`sudo spctl --master-disable`
`sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no`
`defaults write com.apple.LaunchServices LSQuarantine -bool false`

msg "Increasing the window resize speed for Cocoa applications"
`defaults write NSGlobalDomain NSWindowResizeTime -float 0.001`

msg "Saving to disk (not to iCloud) by default"
`defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false`

msg "Setting a blazingly fast keyboard repeat rate"
`defaults write NSGlobalDomain KeyRepeat -int 0`

msg "Turn off keyboard illumination when computer is not used for 5 minutes"
`defaults write com.apple.BezelServices kDimTime -int 300`

msg "Showing all filename extensions in Finder by default"
`defaults write NSGlobalDomain AppleShowAllExtensions -bool true`

msg "Displaying full POSIX path as Finder window title"
`defaults write com.apple.finder _FXShowPosixPathInTitle -bool true`

msg "Disabling the warning when changing a file extension"
`defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false`

msg "Use column view in all Finder windows by default"
`defaults write com.apple.finder FXPreferredViewStyle Clmv`

msg "Avoiding the creation of .DS_Store files on network volumes"
`defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true`

msg "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
`defaults write com.apple.dock tilesize -int 36`

msg "Hiding dashboard"
`defaults write com.apple.dashboard mcx-disabled -boolean true`

msg "Showing Library & ~Library"
`chflags nohidden ~/Library`
`chflags nohidden /Library`


#-------------------- Install RVM and Ruby --------------------
 msg "Installing RVM and Ruby"
 do_command_print_output "curl -sSL https://get.rvm.io | bash -s stable --ruby"


 # Reload the bash and .rvm profiles
 msg "Doing source"

 msg "source ~/.bash_profile"
 `source ~/.bash_profile`

 msg "source ~/.rvm/scripts/rvm"
`source $HOME/.rvm/scripts/rvm`


 # Print out the Ruby and RVM versions
 do_command_print_output "rvm -v"
 do_command_print_output "ruby -v"


#-------------------- Install some Ruby gems --------------------
 msg "Installing some gems"
 gemlist = [
  "bundler",
  "rails"
 ]

 gemlist = [
  "bundler"
  ] if quick

  gemlist.each do |this_gem|
    do_command_print_output "gem install #{ this_gem }"
  end


#-------------------- Configure sublime --------------------
msg "configuring sublime"
puts "-------- configuring sublime"

puts "-------- Ensure the directories we need are there"

sublime_dir = "#{home_dir}/Library/Application Support/Sublime Text 3"

`mkdir -p '#{sublime_dir}/Local'`
`mkdir -p '#{sublime_dir}/Packages/User'`
`mkdir -p '#{sublime_dir}/Installed Packages'`

msg "-------- intalling Package Control"
url = "http://sublime.wbond.net/Package Control.sublime-package"
file_name = "#{sublime_dir}/Installed Packages/Package Control.sublime-package"
download_and_write_file url, file_name


if debug then
    msg "-------- intalling console opener"
    url = base_url+"sublime-config-files/pin_console.py"
    file_name = "#{sublime_dir}/Packages/pin_console.py"
    download_and_write_file url, file_name
end

base_url = "https://raw.githubusercontent.com/dwkns/system-install/master/"

msg "-------- intalling license"
url = base_url+"sublime-config-files/License.sublime_license"
file_name = "#{sublime_dir}/Local/License.sublime_license"
download_and_write_file url, file_name


msg "-------- installing sublime preferences"
url = base_url+"sublime-config-files/Preferences.sublime-settings"
file_name = "#{sublime_dir}/Packages/User/Preferences.sublime-settings"
download_and_write_file url, file_name

msg "-------- installing sublime Package Control Settings"
url = base_url+"sublime-config-files/Package Control.sublime-settings"
file_name = "#{sublime_dir}/Packages/User/Package Control.sublime-settings"
download_and_write_file url, file_name

msg "-------- installing sublime theme dwkns.tmTheme"
url = base_url+"sublime-config-files/dwkns.tmTheme"
file_name = "#{sublime_dir}/Packages/User/dwkns.tmTheme"
download_and_write_file url, file_name

msg "-------- installing sublime keymap"
url = base_url+"sublime-config-files/Default (OSX).sublime-keymap"
file_name = "#{sublime_dir}/Packages/User/Default (OSX).sublime-keymap"
download_and_write_file url, file_name


msg "-------- intalling ruby-terminal build system"
`git clone https://github.com/dwkns/ruby-iTerm2.git '#{sublime_dir}/Packages/ruby-iTerm2'`
`chmod u+x '#{sublime_dir}/Packages/ruby-iTerm2/ruby-iterm2.sh'`
`ln -s '#{sublime_dir}/Packages/ruby-iTerm2/ruby-iterm2.sh' /usr/local/bin`




# #-------------------- Install Krep and Ruby Motion --------------------
if !quick
  msg "-------- Installing Krep"
  `git clone https://github.com/dwkns/krep.git '/tmp/krep'`
  `cp -rf /tmp/krep/Krep.app /Applications`
  appNameAndPath="/Applications/Krep.app"
  `defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>#{appNameAndPath}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"`

  `rm -rf /tmp/krep`

  msg "-------- Intalling RubyMotion"
  url =  "http://www.rubymotion.com/files/RubyMotion%20Installer.zip"
  file_name = "#{home_dir}/Downloads/RubyMotionInstaller.zip"
  download_and_write_file url, file_name

  `unzip -o #{file_name} -d #{home_dir}/Downloads`
  `open '#{home_dir}/Downloads/RubyMotion Installer.app'`
  `rm -rf #{file_name}`
end


#-------------------- Clean up --------------------
msg "restarting the dock"
`killall Dock`

msg "Loading bash profile into this terminal window."
`source ~/.bash_profile`

msg "Opening Dropbox"
`open /Applications/Dropbox.app`

msg "Opening sublime"
`open "/Applications/Sublime Text.app"`

sleep 10

msg "Quitting sublime as it needs to reboot"
`osascript -e 'tell application "Sublime Text" to quit'`

sleep 3

msg "Opening sublime again"
`open "/Applications/Sublime Text.app"`



