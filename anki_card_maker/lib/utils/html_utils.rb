# Version 2.
module HtmlUtils


  BR = '<br>'

  # Escaped tokens
  ESP = '&nbsp;'
  ELT = '&lt;'
  EGT = '&gt;'


  # Wraps a text inside html tags, 'span' by default.
  def wrap(tag = :span, class_names, text)
    %(<#{ tag } class="#{ class_names }">#{ text }</#{ tag }>)
  end

  def escape_angles(input_string)
    input_string.gsub('<', ELT).gsub('>', EGT)
  end

  # Will change spaces starting a line, and in between >  and <, to &nbsp;
  def escape_spaces(input_string)
    parser = SourceParser.new
    func = lambda { |token, regexp| token.gsub(/\s/, ESP) }
    parser.regexter('starting spaces', /^\s+</, func)
    parser.regexter('spaces between tags', />\s+</, func)
    # parser.regexter('double spaces', /\s{2}/, lambda do 
    #   |token, regexp| token.gsub(regexp, ESP * 2) 
    # end)
    parser.parse(input_string)
  end

  def escape_spaces!(input_string)
    input_string.replace(escape_spaces(input_string))
  end

end