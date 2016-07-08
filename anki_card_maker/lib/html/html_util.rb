module HtmlUtil


  @@htmlcustom_words = nil


  # def detect_tokens(regex, string)
  #   string.scan(regex).sort
  # end


  # def self.span(classname, text)
  #   "<span class=\"#{classname}\">#{text}</span>"
  # end


  # "</span> <span>" will become </span>&nbsp;<span>
  def self.escape_spaces_between_angle!(string)
    re = />( *)</
    string.gsub!(re) { |token| '>' + '&nbsp;' * token[re,1].length + '<'}
  end


  # Will escape unknown tags only.
  def self.escape(input_string)

    return input_string if 
      ['<div class="well"><code>', '</code></div>'].include? input_string.strip

    parser = SourceParser.new
    parser.regexter('inline code', /<code class="inline">/, 
      lambda {|token, regexp|
        token
      }
    )

    @@htmlcustom_words = get_html_keywords unless @@htmlcustom_words
    parser.regexter('known tags', 
      Regexp.new("<\\/?(?:#{@@htmlcustom_words.join('|')})>"),
      lambda {|token, regexp|
        token
      }
    )

    parser.regexter('left angle', 
      /(<)(\/?)(\w+)?/,
      lambda {|token, regexp|
        "&lt;#{token[regexp,2]}#{token[regexp,3]}"
      }
    )

    parser.regexter('right angle', 
      /(\w+)?(>)/,
      lambda {|token, regexp|
        "#{token[regexp,1]}&gt;"
      }
    )

    parser.parse(input_string)
  end

end


private

def get_html_keywords
  File.read('./data/keywords_customhtml.txt')
    .lines.collect {|line|  line.chomp}
end