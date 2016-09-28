require './lib/source_parser'

module CommandlineModule


  def regexter(parser)
    parser.regexter('cmd', /```\w*\n(^\$ .*\n)+```/, ->(t, r) do
      CommandHighlighter.new.high
    end)
  end

end