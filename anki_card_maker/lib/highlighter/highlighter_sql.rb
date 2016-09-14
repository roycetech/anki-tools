class SqlHighlighter < BaseHighlighter


  def initialize() super(HighlightersEnum::SQL) end  
  def keywords_file() 'keywords_sql.txt'; end
  def comment_regex() RegextrationStore::CommentBuilder.new.c.sql.build end
  def string_regex() RE_QUOTE_SINGLE end

  def regexter_blocks(parser)
  
    # parser.regexter('optional param', /\[.*\]/, lambda { |token, regexp| 
    #   HtmlUtil.span('opt', token) })

    wrappexter(parser, 'optional param', /\[.*\]/, :opt)

    # parser.regexter('datatype', /\bTIMESTAMP(?: WITH(?: LOCAL)? TIME ZONE)?/, lambda { |token, regexp| 
    #   HtmlUtil.span('keyword', token) })

    wrappexter(parser, 'datatype', /\bTIMESTAMP(?: WITH(?: LOCAL)? TIME ZONE)?/, :keyword)

    parser.regexter('WITHIN GROUP', /WITHIN GROUP/)

    ym_re = /INTERVAL(?: '\d+(?:-\d+)?')? (?:YEAR|MONTH)(?:\(\d\))?(?: TO MONTH)?/
    # parser.regexter('INTERVAL_YM', ym_re, lambda { |token, regexp| 
    #   HtmlUtil.span('keyword', token) })
    wrappexter(parser, 'INTERVAL_YM', ym_re, :keyword)

    ds_re = /INTERVAL(?: '[\d: \.]+')? (?:DAY|HOUR|MINUTE|SECOND)(?:\(\d+(?:,\d+)?\))?(?: TO (?:HOUR|MINUTE|SECOND)(?:\(\d+\))?)?/
    # parser.regexter('INTERVAL_DS', ds_re, lambda { |token, regexp| 
    #   HtmlUtil.span('keyword', token) })
    wrappexter(parser, 'INTERVAL_DS', ds_re, :keyword)


  end

end
