
# Code Store for tagging bold and italic from card text.  Bold is used for 
# non-code, while italic can be used for both code, and non-code.

module Markdown

  BOLD = {
    :regexp => /(_{2}|\*{2})(.*?)\1/,
    :lambda => lambda{ |token, regexp| "<b>#{token[regexp, 2]}</b>" }
  }

  ITALIC = {
    :regexp => /\b([_\*í])(?!\1)((?:\\\1|[^\1])+?)\1/,
    :lambda => lambda{ |token, regexp| "<i>#{token[regexp, 2]}</i>" }
  }

end