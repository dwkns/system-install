require 'pp'
require 'net/http'

home_dir = ENV['HOME']
def msg text
	pp text
end
def download_and_write_file url, file_name
	#downloads text from a URL and writes it to file
	uri = URI(url)
	script = Net::HTTP.get(uri)
	somefile = File.open(file_name, "w")
	somefile.puts script
	somefile.close
end
msg "Start up"


if `command -v brew` == ""
    p "No brew"
end

msg "Downloading iTerm2 Nightly"
url = "https://iterm2.com/nightly/latest"
url = "http://www.iterm2.com/nightly/iTerm2-2_9_20150425-nightly.zip"
file_name = "/Applications/iTerm2.zip"

download_and_write_file url, file_name
`unzip -o /Applications/iTerm2.zip -d /Applications`
`rm /Applications/iTerm2.zip`