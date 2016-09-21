#!/usr/bin/ruby

class HTMLBuilder

  def initialize (tag_name = 'html', attrs={}, indent = 0, single = false, &block)
    @indent = indent
    @tag_name = tag_name
    @attrs = attrs || {}
    @contents = []
    self.instance_eval(&block) if block
    @single = single
  end

  def method_missing (name, *args, &block)

    @contents << if block
      HTMLBuilder.build(name, {:class => args[0]}, @indent + 1, &block)
    elsif name == :br
      HTMLBuilder.build(name, nil, @indent + 1, &block)
    else
      proc = Proc.new { text args.last }
      class_opt = args[0] && {:class => args[0]}
      HTMLBuilder.build(name, class_opt, @indent + 1, true, &proc)
    end
  end

  def text (value)
    @contents << "#{'  ' * (@indent + 1)}#{value}"
  end

  def self.build (*args, &block)
    builder = self.new(*args, &block)
    builder.meow
  end

  def meow
    # puts("meow>>> #{@tag_name} #{@single}")

    attrs = if @attrs.empty?
      ""
    else
      @attrs.map {|k, v| %Q<#{k}="#{v}"> } .join(" ")
    end

    tag = "#{'  ' * @indent}<#{@tag_name}#{" " unless attrs.empty?}#{attrs}>"
    return tag if @contents.empty?
    
    indent = '  ' * @indent
    
    if @single
      "#{tag}#{ @contents.join("\n").strip() }</#{@tag_name}>"
    else
<<-HD.chomp
#{tag}
#{@contents.join("\n")}
#{indent}</#{@tag_name}>
   HD
    end
  end
end


def html(element_name, klass=nil, &block)
  HTMLBuilder.new(element_name, { :class => klass }, &block).meow
end


html1 = html :div, :main do
  text 'Yes or No?'
  2.times { br }
  span :answer_only, 'Answer Only'
end
puts html1




html2 = html :div, :main do
  code :well do
    text 'var string = "Hello World"'
  end
  ul do
    4.times do |num|
      li nil, "Number#{num}"
    end
  end
  pre :fig do
    text 'one'
    text 'two'
  end
  br
  span :answer_only, 'Answer Only'
end
puts html2


