
# Code Store for tagging bold and italic from card text.  Bold is used for 
# non-code, while italic can be used for both code, and non-code.


module Markdown

  include HtmlUtils

  BOLD = {
    regexp: /(_{2}|\*{2})(.*?)\1/,
    lambda: ->(token, regexp) { "<b>#{ token[regexp, 2] }</b>" }
  }

  ITALIC = {
    regexp: /(?<!\\)([_*])((?:(?:\\\1)|[^\1])+?)\1/,
    lambda: ->(token, regexp) { "<i>#{ token[regexp, 2] }</i>" }
  }

  # NUMBER = {               
  #   regexp: /(?<=\s|\()[+-]?(?:[1-9]\d*|0)(?:\.\d+)?(?!-|\.|\d|,\d)/,
  #   # lambda: ->(token, regexp) { %(<span class="num">#{ token }</span>) }
  #   lambda: ->(token, regexp) { self.wrap(:span, :num, token) }
  # }

  def NUMBER(key=nil)
    hash = {
      regexp: /(?<=\s|\()[+-]?(?:[1-9]\d*|0)(?:\.\d+)?(?!-|\.|\d|,\d)/,
      lambda: ->(token, regexp) { self.wrap(:num, token) }
    }

    return hash[key] if key
    hash
  end

  # def remove_backslash!(input_string)
  #   parser = SourceParser.new
  #   parser.regexter('escaped', /\\(.)/, ->(token, regexp) { $1 })
  #   input_string.replace(parser.parse(input_string))
  # end

end