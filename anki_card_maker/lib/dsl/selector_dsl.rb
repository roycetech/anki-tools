# Terminology:
#   style - refers to the select block (selector and styles inside)

class SelectorDSL


  attr_accessor :selector, :styles_hash, :style_names


  def initialize(selector, name, value, &block)    
    @selector = selector
    @styles_hash = {}  # :symbol => string
    if block
      instance_eval(&block)
    else
      @styles_hash[name] = value
    end
  end


  def method_missing(method_name_symbol, *args)
    return if method_name_symbol == :to_ary
    method_name = method_name_symbol.to_s.gsub('_', '-')
    @styles_hash[method_name.to_sym] = args[0]
  end

  # bandaid
  def display(value)
    @styles_hash[:display] = value
  end


  def to_s
    if @styles_hash.length == 1
      array = @styles_hash.to_a[0]
      "  #{ @selector } { #{ array.to_a[0] }: #{array[1]}; }"
    else
      str = "  #{ @selector } {\n"
      @styles_hash.each_pair { |key, value| str += "    #{ key }: #{ value };\n" }
      str += "  }"
    end
  end


end  # class


# DSL Entry
def select(selector, name=nil, value=nil, &block)
  SelectorDSL.new(selector, name, value, &block)
end


# Example
# output = select 'div.main' do
#   text_align 'left'
#   font_size '16pt'
# end
# puts(output.to_s)

      # .select('div.main')
      #   .text_align('left')
      #   .font_size('16pt')
      # .select_e
