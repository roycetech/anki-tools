class List

  include Markdown

  def initialize(highlighter)
    @highlighter = highlighter;
  end


  def execute(html_builder, array, ordered)
    html_builder.send(ordered ? :ol : :ul).lf

    array.each do |element|

      Inline.new(@highlighter).execute!(element)
      escape_spaces!(element)

      parser = SourceParser.new
      parser.regexter('bold', BOLD[:regexp], BOLD[:lambda]);
      parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda]);  
      html_builder.li.text(parser.parse(element)).li_e.lf
    end


    html_builder.__send__(ordered ? :ol_e : :ul_e).lf
  end

end
