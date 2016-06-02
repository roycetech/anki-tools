text = "hello world"


text.gsub!(/[a-zA-Z]+/) do |token|
  "[#{token}]"
end

puts text