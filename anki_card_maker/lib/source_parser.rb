# require './assert'


# This class is designed to parse a string token only once until no more regex
# can parse it.
#
# regex name will serve as better ID for readability.
class SourceParser

  include Assert


  def initialize

    @regex_lambda = {}
    @regex_name = {}

  end


  # Register a regex
  def regexter(name, regex, lambda)
    @regex_name[regex] = name
    @regex_lambda[regex] = lambda
  end


  def parse(text)

    # $logger.debug(text)

    assert !@regex_name.empty?, 'You must regexter a lambda to handle a regex match'

    processed_array = [text]
    processedflag_array = [false]

    begin
      found = false
      processed_array.each_with_index do |element, index|

        # puts "#{index}: #{element}"

        unless processedflag_array[index]

          map = check_pattern(element)
          partition = map[:partition]

          unless partition_missed(partition)
            lambda = map[:lambda]
            regex_name = map[:regex_name]
            processed = lambda.call(partition[1], regex_name)
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

      # unless found
      #   $logger.debug("#{processed_array}")
      #   $logger.debug("#{processedflag_array}")
      # end

    end while(found)

    return processed_array.inject('') do |result, element|
       result += element
     end
  end


  # Returns a tuple partition as array, and the matching lambda
  def check_pattern(string)

    return_value = Hash.new
    @regex_lambda.each do |pattern, proc|
      return_value[:partition] = string.partition(pattern)
      return_value[:lambda] = proc
      return_value[:regex_name] = @regex_name[pattern]
      break unless partition_missed(return_value[:partition])
    end

    return_value.delete(:lambda) if partition_missed(return_value[:partition])
    # if return_value[:lambda]
    #   $logger.debug("Pattern Found: #{return_value[:regex_name]}, String: #{string}")
    # else
    #   $logger.debug("Pattern Not Found: #{return_value[:regex_name]}, String: #{string}")
    # end

    return_value
  end


  # unit tested.
  def partition_missed(array)
    return !array[0].empty? && array[1].empty? && array[2].empty?
  end

  def partition_begin(array)
    return array[0].empty? && !array[1].empty? && !array[2].empty?
  end

  def partition_mid(array)
    return !array[0].empty? && !array[1].empty? && !array[2].empty?
  end

  def partition_end(array)
    return !array[0].empty? && !array[1].empty? && array[2].empty?
  end

  def partition_all(array)
    return array[0].empty? && !array[1].empty? && array[2].empty?
  end

end


# parser = SourceParser.new
# parser.regexter('all', /one two three four/, lambda{ |token, regex| "(#{token})" })
# # parser.regexter('four', /four/, lambda{ |token, regex| "<#{token}>" })
# puts(parser.parse('one two three four'))
# test.print_result

# re = /o/
# puts test.partition_missed("hello".partition(re))
# puts "hello".partition(re)


# test.process
# test.print_result


# puts "Result: #{test.check_pattern('one two three four')}"
# test.process() do |id, token|
#   "(#{id}:#{token})"
# end
# test.print_result
