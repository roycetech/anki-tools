class SourceReader

  def initialize(file)
    @file = file
  end


  def each_card(&block)

    space_counter = 0
    is_question = true

    front, back, tags = [[], [], []]
    card_began = false # Marks the start of the first card.


    while line = @file.gets

      line.rstrip!

      unless card_began
        if line[0, 1] == '#' or line.strip.empty?
          next
        else
          card_began = true
        end
      end

      space_counter += 1 if line == ''

      if space_counter >= 2
        is_question = true
      elsif space_counter == 1 and is_question
        is_question = false
        space_counter = 0
      end

      if is_question

        if space_counter >= 2  # write to file

          yield tags, front, back

          # reset variables
          space_counter = 0

          front, back, tags = [], [], []
        else

          # Check for mistyped @TagS
          if line[0, 7].downcase == '@tags: ' and line[0, 7] != '@Tags: '
            $logger.warn('Misspelled @Tags: @Line' || __LINE__)
          end

          if line[0, 7] == '@Tags: '
            tags = TagHelper.parse(line)
          elsif tags.include? 'Abbr'
            front.push(line + ' abbreviation')
          else
            front.push(line)
          end
        end

      else
        if not line.empty? or not back.empty?
          back.push(line)
          space_counter = 0 unless line == ''
        end

      end
    end
    
    yield tags, front, back

  end

end
