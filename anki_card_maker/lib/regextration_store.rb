module RegextrationStore


  class CommentBuilder


    RE_COMMENT_C = /\/\/.*|\/\*.*\*\//
    RE_COMMENT_PERL = /#.*/
    RE_COMMENT_NONE = /(?!.*)/

    def initialize
      @regexp = nil      
      @c = nil
      @perl = nil
      @none = nil
    end


    def none() comment('@none', RE_COMMENT_NONE); end
    def c() comment('@c', RE_COMMENT_C); end
    def perl() comment('@perl', RE_COMMENT_PERL); end


    def build
      return @regexp
    end


    private
    def comment(flag_name, regexp)      
      if !instance_variable_get(flag_name)
        if @regexp
          @regexp += regexp
        else
          @regexp = regexp
        end
        instance_variable_set(flag_name, true)
      end
      return self
    end


  end

end