module Assert

  def assert(expr, message = 'AssertionError')
    raise message unless expr
  end
  
end