# escape angle brackets of unknown tags/

keywords = %w(print if)
re = /<\?=|<\?php|\?>/

string = %Q{
<?= "Hello World"?><br>print
<?php if echo print 'This is a test1' ?><br>
<?php echo if 'This is a test2' ?><br>
<?php echo print 'This is a test3';
<?php 
  echo print 'This is a test3';
?>
<?php 
  echo print 'This is a test3';
}

lines = string.strip.lines

lines.collect do |line|
  line.gsub!(re) do |token|
    "<span>#{token}</span>"
  end
end

lines.each do |line|
  puts line
end
