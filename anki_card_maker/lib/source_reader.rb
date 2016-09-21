
# TODO: Remove reliance to TagHelper?
class SourceReader


  def initialize(file)
    @file = file
  end


  def blank_or_comment?(line)
    true if line[/^#/] or line.empty?
  end


  def each_card(&block)

    front, back, tags = [], [], []
    is_question = true

    card_began = false  # Marks the start of the first card.    
    line_number = 0
    space_counter = 0

    while line = @file.gets

      line_number += 1
      line.rstrip!

      card_began = !blank_or_comment?(line) unless card_began
      next unless card_began

      # unless card_began
      #   if line[0, 1] == '#' or line.strip.empty?
      #     next
      #   else
      #     card_began = true
      #   end
      # end

      space_counter += 1 if line.empty?

      is_question = if space_counter >= 2
        true
      elsif space_counter == 1 and is_question
        space_counter = 0
        false
      end

      if is_question

        if space_counter >= 2  # write to file
          yield tags, front, back
          space_counter, front, back, tags = 0, [], [], []
        else

          validate_tag_declaration(line)

          if line[/@Tags: .*/]
            tags = TagHelper.parse(line)
          elsif tags.include? 'Abbr'
            front.push(line + ' abbreviation')
          else
            front.push(line)
          end

        end

      else

        unless line.empty? and back.empty?
          back.push(line)
          space_counter = 0 unless line.empty?
        end

      end

    end
    yield tags, front, back unless front.empty? or front[0].strip.empty?
  end


  def validate_tag_declaration(line)
      raise "ERROR: Misspelled @Line #{line_number}:#{line}" if line[/@tags/i] && !line[tags[/@Tags: .*/]]
  end


end
