# escape angle brackets of unknown tags/

known_tags = %w(known html)
re = /<\/?([a-zA-Z]+)>/

string = 'This <known>Hello</known> is <identifier>, yes?'

output = string.gsub(re) do |token|
  if known_tags.include? $1
    token
  else
    '&lt;' + $1 + '&gt;'
  end
end

puts "Output: #{output}"

