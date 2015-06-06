require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::HTML(open("http://overapi.com/javascript/"))

def sanitize_filename(filename)
  # Split the name when finding a period which is preceded by some
  # character, and is followed by some character other than a period,
  # if there is no following period that is followed by something
  # other than a period (yeah, confusing, I know)
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

  # We now have one or two parts (depending on whether we could find
  # a suitable period). For each of these parts, replace any unwanted
  # sequence of characters with an underscore
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

  # Finally, join the parts with a period and return the result
  return fn.join '.'
end

boards = doc.css(".board")
boards.each do |board|
  title = board.css(".board-title").inner_text()
  filename = sanitize_filename(title) + ".json"
  f = File.open(filename, "w")
  card_array = []
  board_cards =  board.css(".board-card")
  board_cards.each do |board_card|
    anchors = board_card.css("a")
    spans = board_card.css("span")
    anchors.each do |a|
      card_array << {"front" => a.attr("title"), "back" => a.inner_text()}
    end
    spans.each do |s|
      card_array << {"front" => s.attr("title"), "back" => s.inner_text()}
    end
  end
  f.puts JSON.pretty_generate(card_array)
  f.close
end

