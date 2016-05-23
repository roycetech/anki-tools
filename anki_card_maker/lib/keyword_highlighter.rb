require './lib/obj_util'


class KeywordHighlighter


  COLOR_KEYWORD = '#7E0854'


  @@html_color = '<span style="color: %{color}">%{word}</span>'
  class << @@html_color
    def keyword(word) self % {color: COLOR_KEYWORD, word: word}; end
  end


  def initialize(keywords, comment_prefix)    
    raise 'Keywords required' unless keywords and not keywords.empty? and 
      not comment_prefix.empty?
    @keywords = keywords
    @comment_prefix = comment_prefix
    
  end


  def highlight(input_string)
    
    incode_string = input_string.gsub('<code>', 'kode_s ').gsub('</code>', ' kode_e')

    # $logger.debug(incode_string)
    @keywords.each do |keyword|
      comment_index = ObjUtil.nvl(incode_string.index(@comment_prefix), 10_000)  # Dummy max value.
      keyword_index = ObjUtil.nvl(incode_string.index(keyword), -1)

      non_comment = keyword_index <= comment_index
      
      pattern = Regexp.new("\b" + Regexp.quote(keyword) + "(?![^<]*>|[^<>]*<\/)")  # ERROR: does not highlight
      # pattern = Regexp.new("\b" + keyword + Regexp.quote("(?![^<]*>|[^<>]*<\/)"))  # ERROR: does not highlight
      
      # pattern = Regexp.new(keyword)  ERROR: keyword within keyword
      # pattern = Regexp.new('\b' + Regexp.quote(keyword) + '\b')  # ERROR: highlights html class
      # pattern = Regexp.new('^[^#]*(' + Regexp.quote(keyword) + ')')  # ERROR: highlights html class also

      pattern = Regexp.new("\\b" + keyword + "\\b(?![\\.\\[\\(=])")  # Keyword must not be followed by =.[(=

      has_keyword = (pattern =~ incode_string)

      # favor readability over slight efficiency hit
      if non_comment and has_keyword

        incode_string.gsub!(pattern, @@html_color.keyword(keyword))
      end
    end

    input_string.replace(incode_string.gsub('kode_s ', '<code>').gsub(' kode_e', '</code>'))
    return input_string
  end

end