
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
      'span.opt{color' => '#AAAAAA',
      'div.well{background-color' => 'black',
      'div.well{color' => 'white',
      'code.inline{background-color' => 'black',
      'code.inline{color' => 'white'
    }
  end

  attr_reader :mapping

  # def get_mapping() 
  #   @mapping
  # end
end


class LightColorizer < ColorizerTemplate 

  def initialize
    @mapping = {}
  end

  attr_reader :mapping

  # def get_mapping() 
  #   @mapping
  # end

end


# <style>
#   code {
#     background-color: black;
#     color: white
#   }
  
#   .opt {
#     color: #AAAAAA;
#   }
#   .quote {
#     color: #66CC33;
#   }
  
#   .keyword {
#     color: #CC7833;
#     font-weight: bold;
#   }
  
# </style>
# <div class="well">
#   <code>
#     $ <span class="keyword">git</span> <span class="keyword">commit</span> <span class="opt">-m</span> <span class="quote">"DEV"</span>
#   </code>
# </div>
