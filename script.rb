require 'yaml'
require 'json'
require 'byebug'

@thing = YAML.load_file('index.yml')

def process_section section_name
  array = []
  @thing[section_name]["sections"].each do |section|
    puts section['title']
    section['items'].each do |item|
      puts item['text']
      puts item['title']
      array << {"front" => item["text"], "back" => item["title"]}
    end
  end
  return array
end

%w(selectors attributes manipulation traversing events effects ajax core).each do |section_name|
  section_array = process_section section_name  
  f = File.open("jquery_#{section_name}.json", "w")
  f.puts JSON.pretty_generate(section_array);
  f.close
end

