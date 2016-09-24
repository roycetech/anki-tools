
# TODO: Remove reliance to TagHelper?
class SourceReader


  def initialize(file)
    @file = file
  end


  def blank_or_comment?(line)
    true if line[/^#/] or line.strip.empty?
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

      space_counter += 1 if line.empty?

       if space_counter >= 2
        is_question = true
      elsif space_counter == 1 and is_question
        space_counter = 0
        is_question = false
      end

      # puts("XXX #{ line } is question: #{ is_question } space_counter #{ space_counter } line.empty? #{ line.empty? }")

      if is_question

        if space_counter >= 2  # write to file
          
          back.pop if back.last.empty?
          yield tags, front, back
          space_counter, front, back, tags = 0, [], [], []
        else

          validate_tag_declaration(line, line_number: line_number)

          if line[/@Tags: .*/]
            tags = TagHelper.parse(line)
          elsif tags.include? :Abbr
            front.push(line + ' abbreviation')
          else
            front.push(line)
          end

        end

      else

        unless line.empty? && back.empty?
          back.push(line)
          space_counter = 0 unless line.empty?
        end

      end

    end

    yield tags, front, back unless front.empty? or front[0].strip.empty?
  end


  # def delete_last_blank!(string_list)
  #   string_list.pop if string_list.last.empty?
  # end


  def validate_tag_declaration(line, line_number: 0)
      raise "ERROR: Misspelled @Line #{ line_number }:#{ line }" if line[/@tags/i] && !line[/@Tags: .*/]
  end


end
