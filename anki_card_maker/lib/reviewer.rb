require './lib/tag_helper'


# Counts sentence so you can review complexity
# Checks if fron card appears at the back of the card.
class Reviewer


  def initialize
    @all_multi = []
    @all_sellout = []

    @all_front = [] # will be used to review if duplicates are valid.
    @all_front_tag_map = {} # will be used to review if duplicates are valid.

    @all_multi = [] # will be used to review complex cards
    @all_sellout = [] # will be used to review of question that appear in answer

  end


  # Detect single word front cards that appears in back card.
  def detect_sellouts(front_array, back_array)
    if front_array.length == 1
      front_card = front_array[0].downcase
      if %r(#{Regexp.quote(front_card)}) =~ back_array.join("\n").downcase
        @all_sellout.push(front_array[0])
      end
    end
  end

  def count_sentence(tag_helper, front_array, back_array)
    count = 0

    if tag_helper.include? 'Syntax'
      sentence_count = 1 # Consider syntax as a single statement.
    else
      sentence_count = back_array.inject(0) do
      |total, element|
        total +=
            element.downcase
              .gsub('.h', 'h')  # c header.
              .gsub('e.g.', 'eg')
              .gsub(/(?:[a-zA-Z]*)(?:\.[a-zA-Z]+)+/, 'javapackage')
              .gsub('i.e', 'ie')
              .gsub('...', '')
              .gsub('..', '')
              .gsub('node.js', 'nodejs')
              .gsub('package.json', 'packagejson')
              .count('.')
      end
    end

    if sentence_count > 1 and not tag_helper.has_enum?
      multi_tag = 'Multi:%s' % sentence_count
      if not tag_helper.include? multi_tag
        tag_helper.add(multi_tag) unless tag_helper.has_enum?
        @all_multi.push(front_array.join("\n") + '(%d)' % sentence_count) if sentence_count > 1
      end
    end
    if back_array.length == 0
      return 0
    else
      return sentence_count == 0 ? 1 : sentence_count
    end
  end

  def addFrontCard(tags, front_card)
    front_key =  tags.join(',') + front_card.join("\n")    
    @all_front.push(front_key)
    @front_tag_map[front_key] = front_card.join("\n")
  end

  def show_multi
    @all_multi.sort! {
        |a, b|
      a[/\((\d*)\)/, 1].to_i <=> b[/\((\d*)\)/, 1].to_i
    }
    puts("Multi Tags: %s\n\n" % @all_multi.to_s)
  end

  def print_card_count
    puts('Total cards: %s' % @all_front.size)
  end  

  def print_sellout
    puts("Sellout: %s\n" % @all_sellout.to_s)
  end

  def print_duplicate
    puts("Potential Duplicates: %s\n" % @all_front.select { |e| @all_front.count(e) > 1 }.uniq.to_s)
  end

end
