class AspHighlighter < BaseHighlighter


  @@html_tags = nil


  def initialize()
    @@html_tags = FileReader.read_as_list('html_element_names.txt') unless @@html_tags
    super(HighlightersEnum::ASP)
  end

  
  def keywords_file() return 'keywords_csharp.txt'; end
  def comment_regex
    RegextrationStore::CommentBuilder.new.c.build
  end

  def string_regex
    quote_double_regex()
  end

  def regexter_blocks(parser)

    parser.regexter('commandline', /^\$.*$/m, lambda { |outtoken, outregexp| 
      cmd_parser = SourceParser.new

      cmd_parser.regexter('optional', /\[.*\]/, lambda { |token, regexp| 
        HtmlUtil.span('opt', token) })

      cmd_parser.regexter('optional param', /(?!<\w)-[A-Za-z]\b/, lambda { |token, regexp| 
        HtmlUtil.span('opt', token) })

      cmd_parser.regexter('optional param', /\$ (\w+)\b/, lambda { |token, regexp| 
        HtmlUtil.span('cmd', token[regexp, 1])
      })

      "  <span class=\"cmdline\">$ #{cmd_parser.parse(outtoken)}</span>"
    })

    parser.regexter('skip_br', /<br>/, lambda { |token, regexp|
      token
    })

    pattern = Regexp.new("<\\/?(?:#{@@html_tags.join('|')}).*?>")    
    parser.regexter('html', pattern, lambda { |blocktoken, regexp|

      parser_inner = SourceParser.new

      parser_inner.regexter('html_tags', /<\/?(\w+)(?:>)?|>$/m, 
        lambda {
          |token, regexp|

          element_name = token[/<\/?(\w+)(?:>)?/, 1] 

          if (@@html_tags.include? element_name) || element_name.nil?
            HtmlUtil.span('html', token.gsub('<', '&lt;').gsub('>', '&gt;'))
          else
            token
          end
        })

      parser_inner.regexter('quote', /(?<=)((["']).*?\2)/, 
        lambda { |token, regexp| HtmlUtil.span('quote', token)})

      parser_inner.regexter('attr', /[\w-]+/, 
        lambda {|token, regexp| HtmlUtil.span('attr', token)})

      parser_inner.parse(blocktoken)
    })

    parser.regexter('annotations', /^\[.*\]$/m, lambda { |token, regexp| 
      HtmlUtil.span('ann', token) })

  end


  def regexter_singles(parser)
    parser.regexter('razor_model', /@model \S+/, lambda { |token, regexp| 
      token
    })

    parser.regexter('razor_expr', /@\S+/, lambda { |token, regexp| 
      token      
    })

  end 

end
