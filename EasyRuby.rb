require 'open-uri'
require 'nokogiri'


class EasyRuby
def download_images
p "Enter URL"
url_string = gets.chomp
p url_string
Nokogiri::HTML(open(url_string)).xpath("//img/@src").each do |src|
  uri = URI.join(url_string, src ).to_s # make absolute uri
  dest ="Images/"+File.basename(uri)
  File.open(dest,'wb'){ |f| f.write(open(uri).read) }
end

p "Downloading successful!"

end
end
