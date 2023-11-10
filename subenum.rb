require 'net/http'

def banner
  banner_text = <<-'BANNER'
____ _  _ ___  ____ _  _ _  _ _  _ 
[__  |  | |__] |___ |\ | |  | |\/|     Written by Bunjo.
___] |__| |__] |___ | \| |__| |  |     Github: https://github.com/thebunjo
                               
  BANNER
end

puts banner

print "\033[35mEnter target (ex: google.com): \033[0m"
$domain = gets.chomp.to_s

$file_path = "subdomains.txt"
$file = File.open($file_path)
$content = $file.read
$subdomains = $content.split("\n")

def find(subdomain)
  url = "http://#{subdomain}.#{$domain}"
  begin
    response = Net::HTTP.get_response(URI(url))
  rescue Exception
    # Ignored
  else
    puts "[+] Discovered subdomain: #{url}\033[32m"
  end
end

threads = []

$subdomains.each do |subdomain|
  threads << Thread.new { find(subdomain) }
end

threads.each(&:join)
