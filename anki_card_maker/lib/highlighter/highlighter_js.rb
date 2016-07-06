

class JsHighlighter < BaseHighlighter


  def initialize() super; end
  def keywords_file() return 'keywords_js.txt'; end

  def comment_regex_string() return '(?:\\/\\/ .*|\\/\\*.*\\*\\/)(?=<br>)'; end

  # Index dependent on base class.
  def string_regex
    quote_both_regex
  end


  def highlight_lang_specific(string_input)
    string_input.gsub!(/(\/\*[\d\D]\*\/)/, '<span class="comment">\1</span>')
    return string_input    
  end


end
