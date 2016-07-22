module RegextrationStore


  class CommentBuilder


    RE_COMMENT_C = /\/\/.*|\/\*.*\*\//
    RE_COMMENT_PERL = /#.*/


    def initialize
      @regexp = nil      
      @c = nil
      @perl = nil
    end


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