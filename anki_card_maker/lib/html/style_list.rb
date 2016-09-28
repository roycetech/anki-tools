require './lib/dsl/style_dsl'


class StyleList 

  def initialize(tags, theme=nil, element_name='span')
    @element_name = element_name
    @list = []
    @tags = tags || []
  end

  def add(klass_name, prop_name, value)
    @list << select("#{@element_name}.#{klass_name}", prop_name, value) if @tags.include? klass_name
  end

  def each
    @list.each { |item| yield item }
  end

end
