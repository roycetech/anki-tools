
# Few choices so we use template method.
class ColorizerTemplate

  def convert(selector, style_name, style_value)
    key = "#{selector}{#{style_name}"
    
    converted = mapping()[key]
    if converted
      converted
    else
      style_value
    end
  end


  # @Abstract
  # def get_mapping() end

end


class DarkColorizer < ColorizerTemplate

  def initialize
    @mapping = {
      'span.quote{color' => '#66CC33',
      'span.keyword{color' => '#CC7833',
      'span.cmd{color' => '#CC7833',
      'span.opt{color' => '#AAAAAA',
      'div.well{background-color' => 'black',
      'div.well{color' => 'white',
      'code.inline{background-color' => 'black',
      'code.inline{color' => 'white'
    }
  end

  attr_reader :mapping

end


class LightColorizer < ColorizerTemplate 

  def initialize
    @mapping = {}
  end

  attr_reader :mapping

end

