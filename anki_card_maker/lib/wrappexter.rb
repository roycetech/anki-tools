module Wrappexter

  extend HtmlUtils

  def wrappexter(parser, description, regexp, klass)
    parser.regexter(description, regexp, ->(ltoken, lregexp) do
      wrap(klass, ltoken)
    end)
  end

end