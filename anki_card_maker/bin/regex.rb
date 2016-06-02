re = /<[^<>]*>|("[^"\\]*(?:\\.[^"\\]*)*"|'[^'\\]*(?:\\.[^'\\]*)*')/

# re = %r{((["'])(\\\1|[^\1]*?)\1)(?![^<]*>|[^<>]*<\/)}

# re = %r{(["'])(\\\1|[^\1]*?)\1}

string = 'hello "right"<div class="right">"right"</div>"right" not met'

tag = false
output = string.gsub(re) do |token|
  puts "token: [#{token}]"
  if tag
    if token[0,1] == '<'
      tag = false;
    end 
    token
  elsif token[0,1] == '<'
    tag = true;
    token
  else
    "*" + $1 + "*"
  end
end

puts "Output: #{output}"

# var car = ['Toyota', 'Honda']  // Using array literal, recommended.

