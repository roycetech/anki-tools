# Terminology:
#   style - refers to the select block (selector and styles inside)

require './selector_dsl' unless defined?(SelectorDSL)


class StyleDSL

  alias_method :global_select, :select

  attr_accessor :styles


  def initialize
    @styles = []
  end


  def select(selector, &block)
    @styles << global_select(selector, &block)
  end


  # :nocov:
  def to_s
    str = "<style>\n"
    @styles.each do |item| 
      str += "#{ item }\n"
    end
    str += "</style>"
  end
  # :nocov:


end  # class


# DSL Entry
def style(&block)
  style = StyleDSL.new
  style.instance_eval(&block)
  style
end


# Example
puts(style do
  select 'div.main' do
    text_align 'left'
    font_size '16pt'
  end
  select 'input' do
    width '100%'
  end
end)