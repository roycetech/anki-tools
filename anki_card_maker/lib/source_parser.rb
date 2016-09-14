# This class is designed to parse a string token only once until no more regexp
# can parse it.
#
# regexp name will serve as better ID for readability.
class SourceParser

  include Assert


  def initialize

    @regexp_lambda = {}
    @regexp_name = {}

  end


  # Register a regular expression.  Omit 3rd parameter to preserve the match
  def regexter(name, regexp, lambda=->(token, regexp) { token })
    @regexp_name[regexp] = name
    @regexp_lambda[regexp] = lambda
  end


  # def token_snatcher(parser, description, regexp )
  #   parser.regexter(description, regexp, ->(token, regexp) { token })
  # end


  # # Convenience method to match a regular expression, but does not make any modifications
  # def snatch()
  #   description, regexp
  # end


  def parse(text)

    assert @regexp_name.any?, 'You must regexter a lambda to handle a regexp match'

    processed_array = [text]
    processedflag_array = [false]

    begin
      found = false
      processed_array.each_with_index do |element, index|

        unless processedflag_array[index]

          map = check_pattern(element)
          partition = map[:partition]

          unless partition_missed(partition)
            lambda, regexp = map[:lambda], map[:regexp]
            processed = lambda.call(partition[1], regexp)

            found = true
            if partition_begin(partition)
              processed_array[index] = partition[2]
              processedflag_array[index] = false
              processed_array.insert(index, processed)
              processedflag_array.insert(index, true)
            elsif partition_mid(partition)
              processed_array[index] = partition[2]
              processed_array.insert(index, processed)
              processedflag_array.insert(index, true)
              processed_array.insert(index, partition[0])
              processedflag_array.insert(index, false)
            elsif partition_end(partition)
              processed_array[index] = processed
              processedflag_array[index] = true
              processed_array.insert(index, partition[0])
              processedflag_array.insert(index, false)
            elsif partition_all(partition)
              processed_array[index] = processed
              processedflag_array[index] = true
            end

            break
          end

        end

      end  # array loop

    end while(found)

    processed_array.inject('') do |result, element|
       result += element
     end
  end

  alias_method :format, :parse


  # Returns a tuple partition as array, and the matching lambda
  def check_pattern(string)

    return_value = Hash.new
    @regexp_lambda.each do |pattern, proc|
      return_value[:partition] = string.partition(pattern)
      return_value[:lambda] = proc
      return_value[:regexp_name] = @regexp_name[pattern]
      return_value[:regexp] = pattern
      break unless partition_missed(return_value[:partition])
    end

    return_value.delete(:lambda) if partition_missed(return_value[:partition])
    return_value
  end


  # unit tested.
  # def partition_missed(array)
  #   !array[0].empty? && array[1].empty? && array[2].empty?
  # end

  # def partition_begin(array)
  #   array[0].empty? && !array[1].empty? && !array[2].empty?
  # end

  # def partition_mid(array)
  #   !array[0].empty? && !array[1].empty? && !array[2].empty?
  # end

  # def partition_end(array)
  #   !array[0].empty? && !array[1].empty? && array[2].empty?
  # end

  # def partition_all(array)
  #   array[0].empty? && !array[1].empty? && array[2].empty?
  # end

  def partition_missed(array)
    _partition_common(array, false, true, true)
  end

  def partition_begin(array)
    _partition_common(array, true, false, false)
  end

  def partition_mid(array)
    _partition_common(array, false, false, false)
  end

  def partition_end(array)
    _partition_common(array, false, false, true)
  end

  def partition_all(array)
    _partition_common(array, true, false, true)
  end

  # pass false if it is !empty?
  def _partition_common(array, bon, boo, bri)
    array[0].empty? == bon && array[1].empty? == boo && array[2].empty? == bri
  end

end
