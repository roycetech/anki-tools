#!/usr/bin/ruby
#[=c= ruby -rubygems % ]

class HTMLBuilder
  def initialize (tag_name = 'html', indent = 0, &block)
    @indent = indent
    @tag_name = tag_name
    @attrs = {}
    @contents = []
    self.instance_eval(&block)
  end

  def method_missing (name, *args, &block)
    if block
      @contents << HTMLBuilder.build(name, @indent + 1, &block)
    else
      @attrs[name] = args.join
      puts "KKKK #{@attrs[name]}"
    end
  end

  def text (value)
    @contents << value
  end

  def self.build (*args, &block)
    builder = self.new(*args, &block)
    builder.meoooooooooooooooow
  end

  def self.tag (name, attrs, empty = false)
  end

  def meoooooooooooooooow
    attrs =
      if @attrs.empty?
        ""
      else
        @attrs.map {|k, v| %Q<#{k}="#{v}"> } .join(" ")
      end
    tag = "#{'  ' * @indent}<#{@tag_name}#{" " unless attrs.empty?}#{attrs}#{" /" if @contents.empty?}>"
    return tag if @contents.empty?
    indent = '  ' * @indent
    return <<-"EOM".chomp
#{tag}
#{@contents.join("\n")}
#{indent}</#{@tag_name}>
    EOM
  end
end


html = HTMLBuilder.build {
  body {
    p {
      text "hoge"
    }
    a {
      href "http://snca.net"
      target "_blank"
      text "宇宙忍者猫団"
    }
    hr {}
    ul {
      2.times do |t|
        li {
          text t
        }
      end
    }
  }
}


puts html

=begin Result
<html>
  <body>
    <a href="http://snca.net">
宇宙忍者猫団
    </a>
<hr />
    <ul>
      <li>
0
      </li>
      <li>
1
      </li>
    </ul>
  </body>
</html>
=end