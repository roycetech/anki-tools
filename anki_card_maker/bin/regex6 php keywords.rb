# escape angle brackets of unknown tags/

keywords = %w(print if)
re = /(<\?.*)(print|if)(.*>)/

string = %Q{
<?= "Hello World"?><br>print
<?php if echo print 'This is a test1' ?><br>
<?php echo if 'This is a test2' ?><br>
<?php echo print 'This is a test3';
}

output = string.gsub(re) do |token|
  if keywords.include? $2
    puts "#{$1}<span>#{token}</span>#{$3}" + token
  else
    puts token
  end
end

# puts "Output: #{output}"

