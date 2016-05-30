require './lib/obj_util'


class KeywordHighlighter


  @@html_class = '<span class="keyword">%{word}</span>'
  class << @@html_class
    def keyword(word) self % {word: word}; end
  end


  def initialize(keywords, comment_prefix)    
    raise 'Keywords required' unless keywords and not keywords.empty? and 
      not comment_prefix.empty?
    @keywords = keywords
    @comment_prefix = comment_prefix
    
  end


  def highlight(input_string)
    
    incode_string = input_string.gsub('<code>', 'kode_s ').gsub('</code>', ' kode_e')

    kw_re_str = @keywords.inject('') do |result, keyword|
      result += '|'  unless result.empty?
      result += keyword
    end

    kw_re = Regexp.new("\\b(?<!\\.)(#{kw_re_str})(?!=|[\\w])")

      has_keyword = (incode_string[kw_re] != nil)


      # $logger.debug("has_keyword: #{has_keyword} \nincode_string[re]: #{incode_string[kw_re]}\nincode_string: #{incode_string}")

      # favor readability over slight efficiency hit
      # if non_comment and has_keyword
      if has_keyword
        keyword = incode_string[kw_re]
        # $logger.debug keyword
        incode_string.gsub!(kw_re) do |token|
            # $logger.debug token
            @@html_class.keyword(token)
        end
      end

    input_string.replace(incode_string.gsub('kode_s ', '<code>').gsub(' kode_e', '</code>'))
    return input_string
  end

end