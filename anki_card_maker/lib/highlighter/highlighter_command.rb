require './lib/file_reader'
require './lib/utils/html_utils'


class CommandHighlighter < BaseHighlighter

  include HtmlUtils

  
  @@html_tags = nil


  def initialize() 
    @@html_tags = FileReader.read_as_list('html_element_names.txt') unless @@html_tags
    super; 
  end


  def comment_regex() /^\$.*$/ end


  def regexter_blocks(parser)
        
    pattern = /&lt;\/?(?:#{@@html_tags.join('|')}).*&gt;/
    parser.regexter('html', pattern, ->(bt, br) do
      
      parser_inner = SourceParser.new
      parser.regexter('expression', /\{\{.*?\}\}/, lambda { |blocktoken, regex_name|
        blocktoken  # no markup
      })

      parser_inner.regexter('quote', /(?<=)((["']).*?\2)/, 
        lambda { |token, re_name| HtmlUtil.span('quote', token)})

      # optionally grab expression

      parser_inner.regexter('html_tags', /&lt;\/?(\w+)(?:&gt;)?|&gt;$/, 
        lambda {
          |token, re_name|
          element_name = token[/&lt;\/?(\w+)(?:&gt;)?/, 1]

          if (@@html_tags.include? element_name) || element_name.nil?
            HtmlUtil.span('html', token)
          else
            token
          end
        })

      parser_inner.regexter('attr', /[\w\-]+/, 
        lambda {|token, re_name| HtmlUtil.span('attr', token)})

      parser_inner.parse(blocktoken)
    })
  end


  def regexter_singles(parser)
      ngattr_lambda = lambda{ |token, re_name| wrap(:attr, token) }
      parser.regexter('ng_attr', /ng-\w+/, ngattr_lambda)
  end
  

end
