class SystemTagCounter


  # Will use the system tag "Concept(2) if there are a total of 2 Concept tags in the deck."
  # @tag_count - hash of tag name => count
  def count(tag_helper, map: {})
    if tag_helper.untagged?
      :untagged.to_s
    else      
      tags_numbered = tag_helper.tags.map do |tag|
        count = map[tag]
        if count == 1
          tag
        else
          "#{tag}(#{count})"
        end
      end
      tags_numbered.join(',')
    end
  end

end
