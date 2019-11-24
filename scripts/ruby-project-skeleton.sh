#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

# ######## Init the project with auto-defaults, add Parcel.
# yarn init -y
# yarn add parcel-bundler --dev
# yarn add parcel-plugin-clean-dist --dev


######## Do some processing of package.json to add build scrips & title.

# # change the name property of package.json (need to save temp file first)
# tmp=$(mktemp) 
# JQVAR=".name = \"$PROJECTNAME\""
# jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# # add some build scripts to package.json
# tmp=$(mktemp) 
# JQVAR='.scripts |= .+ { "serve": "parcel src/index.html --open", "build": "parcel build src/index.html" }'
# jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# # add author
# tmp=$(mktemp) 
# JQVAR='.author |= .+ "dwkns"'
# jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json
cat >README.md <<'EOL'
##Read Me File
EOL
cat >Gemfile <<'EOL'
source 'https://rubygems.org'
gem 'rspec'
gem 'awesome_print'
EOL
######## Add source folder and files. 
mkdir 'src'
mkdir 'bin'
mkdir 'spec'

cat >src/run.rb <<'EOL'
#!/usr/bin/env ruby
require 'awesome_print'

def say_something
  data = "Here's Johnny"
  ap data
  return data
end

say_something
EOL

cat >spec/run_spec.rb <<'EOL'
require './src/run.rb'

describe 'Say Something > ' do  
    it "Should be Here's Johnny" do
      expect(say_something).to eq("Here's Johnny")
    end
    it "Shouldn't be There's Johnny" do
      expect(say_something).not_to eq("There's Johnny")
    end 
end
EOL

cat >bin/s <<'EOL'
#!/usr/bin/env bash
./src/run.rb
EOL

cat >bin/t <<'EOL'
#!/usr/bin/env bash
rspec
EOL

chmod +x bin/s
chmod +x bin/t
chmod +x src/run.rb




# cat >src/index.js <<'EOL'
# import './main.scss';
# const paragraph = document.createElement('p');
# paragraph.innerText = 'This is a paragraph added from JS which shows bundling is working.';
# document.body.appendChild(paragraph); 
# EOL

# cat >src/main.scss <<'EOL'
# $brand: #4A90E2;
# $brand-alternate: #F5A623;

# body {
#     font-family: -apple-system, Sans-Serif;
#     color: $brand;
# }

# h1 {
#     font-size: 24pt;
#     color: $brand-alternate;
# }
# EOL

# ######## Put the project name into the HTML Title. 
# sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./src/index.html

######## Initialize git.
git init
git add .
git commit -m "Initial commit"


bundle install

# ######## Open a new iTerm tab at the project root. 
# ######## Required because server will run in current tab.
# osascript  <<EOL > /dev/null 2>&1
# tell application "iTerm"
#   set currentWindow to current window 
#   tell currentWindow
#     create tab with default profile
#     delay 0.5
#     tell current session of currentWindow
#       write text "cd $PROJECTNAME"
#     end tell
#   end tell
# end tell
# EOL



######## Open project in Sublime
subl .

success "Project created"
note "Use : "
note "bin/s to run"
note "bin/t to test"

# ######## Format sublimes windows to my favorite layout.
# subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}]]}'


# ######## Start the server.
# yarn serve