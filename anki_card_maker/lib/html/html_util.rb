module HtmlUtil


  @@htmlcustom_words = nil


  def detect_tokens(regex, string)
    string.scan(regex).sort
  end


  def self.span(classname, text)
    "<span class=\"#{classname}\">#{text}</span>"
  end  


  # Will escape unknown tags only.
  def self.escape(input_string)
    return input_string if 
      ['<div class="well"><code>', '</code></div>'].include? input_string.strip

    @@htmlcustom_words = get_html_keywords unless @@htmlcustom_words
    
    # $logger.debug(input_string)

    # Must deal with left first, then right angle.
    # left angle
    input_string.gsub!(/(<)(\/?)(\w+)?/) do |token|
      if $3 and @@htmlcustom_words.include? $3
        token
      else
        "&lt;#{$2}#{$3}"
      end
    end

    # left angle
    input_string.gsub!(/(\w+)?(>)/) do |token|
      if $1 and @@htmlcustom_words.include? $1
        token
      else
        "#{$1}&gt;"
      end
    end


    # $logger.debug(input_string)

    input_string
  end

end


private

def get_html_keywords
  File.read('./data/keywords_customhtml.txt')
    .lines.collect {|line|  line.chomp}
end



# <(\w+)| (?<!<|\w)(?:([\w-]+)(?:=(['"])(.*)?\3)?)