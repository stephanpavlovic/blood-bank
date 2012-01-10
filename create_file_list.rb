require 'json'
File.open('file_list.json', 'w+') do |file|
  file.write(Dir['*/**'].to_json)
end
