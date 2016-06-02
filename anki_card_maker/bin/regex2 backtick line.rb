# Print back ticks on the same line

re = /([`])((?:\\\1|[^\1])*?)(\1)/

# string = "`print` me `dont\\`t` do it "
string = 'Wrap the code with backticks `\`\``'

tag = false
output = string.gsub(re) do |token|
  # puts "token: [#{}], 1[#{$1}], 2[#{$2}], 3[#{$3}]"
  "<code>" + token[re,2].gsub('\`', '`') + token[re, 3] = '</code>'
  # token.gsub()
end

puts "Output: #{output}"

