# Terminology:
#   style - refers to the select block (selector and styles inside)

class SelectorDSL


  attr_accessor :selector, :styles_hash, :style_names


  def initialize(selector)
    @selector = selector

    @styles_hash = {}  # :symbol => string
    @style_names = []  # list of :symbol
  end


  def method_missing(method_name_symbol, *args)
    method_name = method_name_symbol.to_s.gsub('_', '-')
    @styles_hash[method_name.to_sym] = args[0]
    @style_names.push(method_name.to_sym)
    self
  end


  # :nocov:
  def to_s
    str = "#{ @selector } {\n"
    @styles_hash.each_pair { |key, value| str += "  #{ key }: #{ value };\n" }
    str += "}"
  end
  # :nocov:


end  # class


# DSL Entry
def select(selector, &block)
  style = SelectorDSL.new(selector)
  style.instance_eval(&block)
  style
end


# Example
select 'div.main' do
  text_align 'left'
  font_size '16pt'
end

      # .select('div.main')
      #   .text_align('left')
      #   .font_size('16pt')
      # .select_e
