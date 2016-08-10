
# 
class StyleBuilder


  # Colorizer is an object that determines the actual color to use 
  def initialize(html_builder = nil, colorizer=nil)
    @html_builder = html_builder
    @colorizer = colorizer

    # these two used per selectors
    @prop_hash  = {}
    @prop_names  = []
    @current_selector = nil

    @values = []  # holds all the styles
  end

  def merge(style_builder)
    style_builder.each do |value|
      @values.push(value)
    end
    return self
  end

  def select(selector)
    @current_selector = selector
    @values.push(selector + ' {')
    return self
  end

  def select_e
    @current_selector = nil
    @prop_names.sort!
    @prop_names.each do |name|
      value = @prop_hash[name]
      @values.push '  %s: %s;' % [name, value]
    end

    @values.push '}'
    @prop_hash.clear
    @prop_names.clear

    return self
  end

  def style_e
    raise 'End style must originate from html builder only. ' if @html_builder.nil?
    @html_builder.merge(self)
    return @html_builder
  end

  def value
    return @values.inject('') do |result, element|
      result += '  ' + element + "\n"
    end
  end

  def build
    return @values.inject('') do |result, value|
      result += value + "\n"
    end
  end


  def display(param)
    method_name = 'display'
    @prop_hash[method_name] = param
    @prop_names.push(method_name)
    return self
  end


  def method_missing(meth, *args, &block)
    if args.length == 1
      name = meth.to_s.gsub('_', '-')

      @prop_names.push(name)
      if @colorizer 
        @prop_hash[name] = @colorizer.convert(@current_selector, name, args[0])
      else
        @prop_hash[name] = args[0]
      end

      return self
    else
      super
    end
  end

  def each
    @values.each do |value|
      yield value
    end
  end

  def to_s
    return @values.inject("\n" + 
      self.class.to_s + 
      '------------------------------------' + 
      "\n  HtmlBuilder[%s]" % (@html_builder ? 'Y' : 'n') + "\n") do
      |result, value|
      result += "#{value}\n"
    end
  end

end
