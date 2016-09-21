class HTMLDSL

  LEAF_TAGS = [:br, :hr]
  
  LF = "\n"  # Used only to alias, not to dry.

  # single for single-line
  def initialize (tag_name = 'html', attrs={}, level=0, single = false, first=false, &block)
    @level = level
    @tag_name = tag_name
    @attrs = attrs || {}
    @contents = []
    if attrs && attrs[:text]
      @contents << attrs[:text]
      attrs.delete(:text)
    end
    self.instance_eval(&block) if block
    @single = single
    @first = first
  end


  def text (value)
    @contents << "#{ indent(@level + 1) }#{ value }"
  end


  def merge(html_text)
    @contents << "\n#{indent(1)}#{ html_text }"
  end

  def indent(i) "#{'  ' * i}" end


  def method_missing (name, *args, &block)
    @contents << if block
      HTMLDSL.build(name, {:class => args[0]}, @level + 1, false, @contents.empty?, &block)
    elsif name == :br
      HTMLDSL.build(name, nil, @level + 1, false, @contents.empty?, &block)
    else
      proc = Proc.new { text args.last }
      class_opt = args[0] && {:class => args[0]}
      HTMLDSL.build(name, class_opt, @level + 1, true, @contents.empty?, &proc)
    end
  end


  def self.build (*args, &block)
    builder = self.new(*args, &block)
    builder.to_s
  end


  def to_s
    attrs = if @attrs.empty?
      ""
    else
      @attrs.map {|k, v| %Q<#{k}="#{v}"> } .join(" ")
    end

    tag = "#{ indent(@level) }<#{@tag_name}#{ " " unless attrs.empty? }#{ attrs }>"  

    return "\n#{tag}" if LEAF_TAGS.include?(@tag_name.to_sym) && !@first
    return "#{tag}" if LEAF_TAGS.include?(@tag_name.to_sym)

    if @contents.empty? or @single      
      output = "#{tag}#{ @contents.join(LF).strip }</#{@tag_name}>" 
      return output unless @single
      
      # puts(">>> #@tag_name #@child #@single")

      "#{output}"
    else
<<-HD.chomp
#{tag}
#{@contents.join}
#{indent(@level)}</#{@tag_name}>
HD
    end
  end
end


# text is available only for single liner.
def html(element_name, klass=nil, text=nil, &block)
  attrs = klass && { :class => klass }
  attrs[:text] = text if text
  single = true if text
  HTMLDSL.new(element_name, attrs, 0, single, &block).to_s
end


one_liner = html :span, :answer, 'Answer Only'

html1 = html :div, :main do
  code :well do
    text 'pass'
  end
  br
  merge(one_liner)
end.to_s

puts(html1)


html2 = html :div, :main do
  hr
  # two do
  #   text 'f'
  # end
end.to_s

puts(html2)


