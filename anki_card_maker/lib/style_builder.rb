
# 
class StyleBuilder


  def initialize(html_builder = nil)
    @html_builder = html_builder

    # these two used per selectors
    @prop_hash  = {}
    @prop_names  = []

    @values = []  # holds all the styles
  end

  def merge(style_builder)
    style_builder.each do |value|
      @values.push(value)
    end
    return self
  end

  def select(selector)
    @values.push (selector + ' {')
    return self
  end

  def select_e
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
    return @html_builder.merge(self)
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

  def method_missing(meth, *args, &block)
    if args.length == 1
      name = meth.to_s.gsub('_', '-')
      @prop_hash[name] = args[0]
      @prop_names.push(name)
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
    return @values.inject("\n" + self.class.to_s + '------------------------------------' +
      "\n  HtmlBuilder[%s]" % (@html_builder ? 'Y' : 'n') + "\n") do
      |result, value|
      result += '    ' + value + "\n"
    end
  end

end

# red = StyleBuilder.new
#   .select('.tag')
#     .background_color('red')
#   .select_e

# puts StyleBuilder.new(nil)
#   .select('span')
#     .color('black')
#   .select_e
#   .merge_style(red).to_s
# .build