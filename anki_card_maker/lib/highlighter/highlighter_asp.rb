require './lib/highlighter/highlighter_csharp'


class AspHighlighter < CSharpHighlighter


  @@html_tags = nil


  def initialize()
    @@html_tags ||= FileReader.read_as_list('html_element_names.txt')
    super(HighlightersEnum::ASP)
  end


  def regexter_blocks(parser)

    parser.regexter('commandline', /^\$.*$/, ->(outtoken, outregexp) do
      cmd_parser = SourceParser.new

      wrappexter(cmd_parser, 'optional', /\[.*\]/, :opt)
      # cmd_parser.regexter('optional', /\[.*\]/, ->(token, regexp) do
      #   wrap(:opt, token)
      # end)

      cmd_parser.regexter('opt param', /(?!<\w)-[A-Za-z]\b/, ->(token, regexp) do
        wrap(:opt, token) 
      end)

      cmd_parser.regexter('command', /\$ (\w+)\b/, ->(token, regexp) do
        wrap(:cmd, token[regexp, 1])
      end)

      %Q(<span class="cmdline">$ #{ cmd_parser.parse(outtoken) }</span>)
    end)

    parser.regexter('skip_br', /#{ BR }/)

    # token_snatcher(parser, 'skip_br', /#{ BR }/)

    pattern = /<\/?(#{ @@html_tags.join('|') }).*?>/
    parser.regexter('html', pattern, lambda { |blocktoken, blockregexp|

      parser_inner = SourceParser.new

      parser_inner.regexter('html_tag', /(?<=<|<\/)(\w+)(?=\s|>)/, 
        ->(token, regexp) { wrap(:html, token) }
      )

      parser_inner.regexter('quote', /(?<=)((["']).*?\2)/, 
        ->(token, regexp) { wrap(:quote, token) }
      )

      parser_inner.regexter('attr', /[\w-]+/, 
        ->(token, regexp) { wrap(:attr, token) }
      )

      parser_inner.regexter('symbols', /<\/?|>|=/, 
        ->(token, regexp) { wrap(:symbol, escape_angles(token)) }
      )

      parser_inner.parse(blocktoken)
    })
  end


  def regexter_singles(parser)

    parser.regexter('razor_model', /@(model) (\S+)/, ->(token, regexp) do 
      "@#{ wrap(:html, token[regexp, 1]) } #{ escape_angles(token[regexp, 2]) }"
    end)

    parser.regexter('razor_expr', /@\S+/, ->(token, regexp) { token } )

  end 

end
