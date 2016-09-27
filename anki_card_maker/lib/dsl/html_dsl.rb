class HTMLDSL

  LEAF_TAGS = [:br, :hr]
  
  LF = "\n"  # Used only to alias, not to dry.

  # single for single-line
  # options to hold single style classes.
  def initialize (element_name = 'html', options: nil, level: 0, single: false, first: false, &block)
    @level = level
    @element_name = element_name
    @class = options || {}
    @contents = []

    if options && @class[:text]
      @contents << @class[:text]
      @class.delete(:text)
    end

    self.instance_eval(&block) if block
    @single = single
    @first = first
  end


  def text (value)
    @contents << "#{ indent(@level + 1) }#{ value }"
  end


  # allows repeating of elements
  def times(count, &block)
    count.times { |i|
      yield(i)
    }
  end


  def merge(html_text)
    indented = html_text.lines.collect do |line|
      "#{indent(1)}#{ line.chomp }"
    end.join("\n")
    # @contents << "#{indent(1)}#{ html_text }\n"
    # @contents << indented + "\n"
    @contents << "#{ indented }\n"
  end


  def indent(i) "#{'  ' * i}" end


  def method_missing (name, *args, &block)
    
    attrs = HTMLDSL.parse(*args)

    @contents << if block
      HTMLDSL.build(name, options: attrs, level: @level + 1, single: false, first: @contents.empty?, &block)
    elsif name == :br
      HTMLDSL.build(name, level: @level + 1, single: false, first: @contents.empty?, &block)
    else
      proc = Proc.new { text args.last }
      class_opt = args[0] && args[0].class.to_s == 'Symbol' && {:class => args[0]}
      HTMLDSL.build(name, options: class_opt, level: @level + 1, single: true, first: @contents.empty?, &proc)
    end
  end


  def self.build (*args, &block)
    builder = self.new(*args, &block)
    builder.to_s
  end


  def to_s
    attrs = if @class.empty?
      ""
    else
      @class.map {|k, v| %Q<#{k}="#{v}"> } .join(" ")
    end

    tag = "#{ indent(@level) }<#{@element_name}#{ " " unless attrs.empty? }#{ attrs }>"  

    return "#{tag}\n" if LEAF_TAGS.include?(@element_name.to_sym) && !@first
    return "#{tag}" if LEAF_TAGS.include?(@element_name.to_sym)

    if @contents.empty? or @single      
      output = "#{tag}#{ @contents.join(LF).strip }</#{@element_name}>\n"
      return output unless @single
            "#{output}"
    else
<<-HD.chomp
#{tag}
#{@contents.join.rstrip}
#{indent(@level)}</#{@element_name}>\n
HD
    end
  end


  def self.parse(*args)

    param1 = args[0] unless args.empty?
    param2 = args[1] unless args.length < 2

    attrs = {} if param1 or param2

    if param1.class.to_s == 'Symbol'
      attrs = param1 && { :class => param1 }

      if param2.class.to_s == 'String'
        attrs[:text] = param2 if param2
      end

    elsif param1.class.to_s == 'String'
      attrs[:text] = param1
    end
    attrs

  end

end


# text is available only for single liner.
def html(element_name, param1=nil, param2=nil, &block)
  attrs = HTMLDSL.parse(param1, param2)
  single = true if param1.class.to_s == 'String' or param2.class.to_s == 'String'
  HTMLDSL.new(element_name, options: attrs, level: 0, single: single, &block).to_s.strip
end



# output1 = html :div, :main do
#   div :tags do
#     times(3) { |i| span :"cls#{i}", "Tag#{i}" }
#   end
#   ul do
#     times(4) { |i| li "list#{i}" }
#   end
#   br
#   span :tag3, "one"
#   span :tag, "one"
#   merge('<h1>merged portion</h1>')
#   span "two"
# end

# puts(output1)


# output2 = html :div, 'yo'
# puts(output2)

# output3 = html :div, :single, 'yo'
# puts(output3)
