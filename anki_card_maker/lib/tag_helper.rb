require './lib/utils/oper_utils'
require './lib/assert'


# unit tested
class TagHelper

  include OperUtils
  
  HIDDEN = %i[FB BF]  
  FRONT_ONLY = %i[FB Enum Practical Bool Abbr Syntax EnumU EnumO Terminology]


  attr_reader :front_only, :back_only, :tags


  # tags - list of Symbols 
  def initialize(tags: nil, tag_line: nil)
    
    assert xor(tags, tag_line), message: 'Must set either :tags or :tag_line but not both'

    @tags = TagHelper.parse(tag_line) if tag_line
    
    if tags
      @tags = tags.clone if tags
      @tags.each do |item|
        assert item.class == Symbol, message: 'Should be array of symbols, not strings'
      end
    end


    @enum = @tags.select { |tag| [:EnumO, :EnumU].include? tag }.first

    @front_only = @tags.select { |tag| FRONT_ONLY.include? tag }.size > 0
    @back_only = @tags.include? :BF
  end


  # parses a comma separated tags into array of tag symbols
  def self.parse(string)
    string[/@Tags: (.*)/, 1].split(',').collect do |element|
      element.strip.to_sym
    end
  end


  def index_enum(back_card)
    if has_enum?
      multi_tag = "Enum#{ol? ? 'O' : 'U' }:#{back_card.size}".to_sym
          
      unless @tags.include? multi_tag
        @tags.push(multi_tag)
        @tags.delete(@enum)
      end
    end
  end


  def add(tag)
    @tags.push tag unless @tags.include? tag
  end


  def include?(tag)
    @tags.include? tag
  end


  def one_sided?
    @front_only or @back_only
  end


  def is_front_only?
    @front_only
  end


  def is_back_only?
    @back_only
  end


  def visible_tags
    @tags.select { |tag| !HIDDEN.include? tag }
  end


  def figure?
    @tags.include? :'Figure ☖'
  end


  def ol?
    @enum == :EnumO
  end


  def ul?
    @enum == :EnumU
  end


  def untagged?
    tags.empty?
  end


  def has_enum?
    ul? or ol?
  end


end
