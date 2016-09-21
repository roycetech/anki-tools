unless defined? Assert
  require '../assert'
  require '../utils/oop_Utils'
  Object.class_eval { include Assert, OopUtils }
end


# This is not recursive for the sake of simplicity.
# This class do not have attributes except for the outer most element.
class HtmlDsl

  include Assert


  alias_method :global_select, :select


  attr_accessor :elements, :element_name, :text, :element_names


  def initialize(element_name: nil, attrs: nil, text: nil)
    @element_name = element_name
    @attributes = attrs || {}
    @children = []
    @newline = true

    @elements = {}
    @element_names = []
  end


  def text(value)
    @children << value
  end


  def method_missing(method_name_symbol, *args, &block)
    puts("Method Name: #{ method_name_symbol }, args: #{ args }")

    method_name = method_name_symbol.to_s
    if block
      @children << html(method_name, args, &block)
      puts("Blocked!")
    else
      @element_names << method_name
      @elements[method_name_symbol] = args[0]
      puts("Non-Block")
    end

  end


  def to_s
    str = "<#{ element_name }"
    klass = @attributes[:klass]
    str += %Q( class="#{ klass }") if klass
    str += '>'
    str += "\n" if @newline
    if @text
      str += @text
    else
      @element_names.each do |element_name|
        element_value = @elements[element_name]
        puts("  #{ element_name }:#{ element_value }")  
      end
    end
    str += "</#{ element_name }>"
  end


end  # class


# DSL Entry
def html(element_name=:div, attrs={ klass: :main }, &block)
  html_dsl = HtmlDsl.new(element_name: element_name, attrs: attrs)
  html_dsl.instance_eval(&block) if block_given?
  html_dsl
end


# input1 = html do
# end
# puts input1.to_s


input2 = html do
  code :well do
    text 'var string = "Hello World"'
  end
  br
  span :answer_only, 'Answer Only'
end
puts input2.to_s
