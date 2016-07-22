require './lib/obj_util'


class KeywordHighlighter


  @@html_class = '<span class="keyword">%{word}</span>'
  class << @@html_class
    def keyword(word) self % {word: word}; end
  end


  def initialize(keywords_file)
    raise 'Keywords required' unless keywords_file
    @keywords = get_keywords(keywords_file)
    raise 'Keywords required' if @keywords.empty?    
  end


  def get_keywords(keywords_file)
    return File.read('./data/' + keywords_file).lines.collect do |line|
      line.chomp
    end
  end


  def keyword_regex
    kw_re_str = @keywords.inject('') do |result, keyword|
      result += '|'  unless result.empty?
      result += keyword
    end

    return Regexp.new("(?<!\\.|-|(?:[\\w]))(?:#{kw_re_str})\\b")
                       # (?<!\.|-|(?:[\w]))(?:@interface|interface|var|global)\b

    # return Regexp.new("(?<!\\.|-)\\b(?:#{kw_re_str})\\b")
  end


  # def highlight(input_string)
  #   input_string.gsub!(kw_re) do |token|
  #     @@html_class.keyword(token)
  #   end    
  #   input_string.replace!(html_class.keyword(input_string))
  #   return input_string
  # end

end