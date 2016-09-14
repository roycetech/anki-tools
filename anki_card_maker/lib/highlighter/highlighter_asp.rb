class AspHighlighter < CSharpHighlighter


  @@html_tags = nil


  def initialize()
    @@html_tags ||= FileReader.read_as_list('html_element_names.txt')
    super(HighlightersEnum::ASP)
  end


  def regexter_blocks(parser)

    parser.regexter('commandline', /^\$.*$/, lambda { |outtoken, outregexp| 
      cmd_parser = SourceParser.new

      cmd_parser.regexter('optional', /\[.*\]/, lambda { |token, regexp| 
        HtmlUtil.span('opt', token) })

      cmd_parser.regexter('optional param', /(?!<\w)-[A-Za-z]\b/, lambda { |token, regexp| 
        HtmlUtil.span('opt', token) })

      cmd_parser.regexter('optional param', /\$ (\w+)\b/, lambda { |token, regexp| 
        HtmlUtil.span('cmd', token[regexp, 1])
      })

      "<span class=\"cmdline\">$ #{cmd_parser.parse(outtoken)}</span>"
    })

    parser.regexter('skip_br', /<br>/, lambda { |token, regexp|
      token
    })

    pattern = Regexp.new("<\\/?(#{@@html_tags.join('|')}).*?>")    
    parser.regexter('html', pattern, lambda { |blocktoken, blockregexp|

      parser_inner = SourceParser.new

      parser_inner.regexter('html_tag', /(?<=<|<\/)(\w+)(?=\s|>)/, 
        lambda { |token, regexp|
          HtmlUtil.span('html', token)
        }
      )

      parser_inner.regexter('quote', /(?<=)((["']).*?\2)/, 
        lambda { |token, regexp| HtmlUtil.span('quote', token)}
      )

      parser_inner.regexter('attr', /[\w-]+/, 
        lambda {|token, regexp| HtmlUtil.span('attr', token)}
      )

      parser_inner.regexter('symbols', /<\/?|>|=/, 
        lambda {|token, regexp| 
          HtmlUtil.span('symbol', token.gsub('<', '&lt;').gsub('>', '&gt;'))
        }
      )

      parser_inner.parse(blocktoken)
    })
  end


  def regexter_singles(parser)

    parser.regexter('razor_model', /@(model) (\S+)/, lambda { |token, regexp| 
      "@#{ HtmlUtil.span('html', token[regexp, 1]) } #{ token[regexp, 2].gsub('<', '&lt;').gsub('>', '&gt;') }"
    })

    parser.regexter('razor_expr', /@\S+/, lambda { |token, regexp| 
      token      
    })

  end 

end
