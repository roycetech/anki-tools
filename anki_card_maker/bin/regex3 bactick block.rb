# Convert tripple backticks to well

re = /(```)([a-zA-Z]*)([\d\D]*?)(\1)/

string = %q(
Example `code`  this line is none of your business, must not have a highlight
```
  Well
```
Example 2:
```
  Second well
```)

output = string.gsub(re) do |token|
  # puts "token: [#{}], 1[#{$1}], 2[#{$2}], 3[#{$3}]"
  "<code>" + token[re,3] + token[re, 4] = '</code>'
  # token.gsub()
end

puts "Output: #{output}"

