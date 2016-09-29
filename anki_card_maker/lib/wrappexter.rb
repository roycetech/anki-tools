module Wrappexter

  extend HtmlUtils

  def wrappexter(parser, description, regexp, klass)
    parser.regexter(description, regexp, ->(token, regexp) do
      wrap(klass, token)
    end)
  end

end