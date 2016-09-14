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

    # return Regexp.new("(?<!\\.|-|(?:[\\w]))(?:#{ kw_re_str })\\b")
                        /(?<!\.|-|(?:[\w]))(?:#{ kw_re_str })\b/
  end


end