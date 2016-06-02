# escape angle brackets of unknown tags/

keywords = %w(print if)
# re1 = /(\/\/.*)(?:\?>)?/

re1 = /(\/\/.*)(?:(?:\?>)|[^\2])/
re2 = /(#.*)(?:\?>)?/
re3 = /(\/\*.*\*\/)/

re_all = /(\/\/.*)(?=\?>)|(\/\/.*)|(#.*)(?=\?>)|(#.*)|\/\*.*\*\//

string = %Q{
text // comment?>HELLO
text // comment
text # comment
text # comment?> HI
text /* COMMENT */ text
}

lines = string.strip.lines
lines.collect! do |line|
  line.gsub!(re_all) do |token|
    "<span>#{$1}</span>"
  end
  line
end

lines.each do |line|
  puts line
end

