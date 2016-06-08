text = "Element Reference—Retrieves the value object corresponding to the key object. If not found, returns the default value (see Hash::new for details)."


if text[/ \(see/]
  text[/ \(see.*?\)/] = '';

  puts text

  puts SCRIPT_LINES__
end