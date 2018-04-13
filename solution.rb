def normalize_data(item)
  item.each do |k, v|
    case k
    when :year
      return item if !(item[:year].to_i >= 1900 && item[:year].to_i <= Time.now.year)
      if item[:year].class != Integer
        item[:year] = item[:year].to_i
      end
    when :make
      if item[:make].downcase.include?('fo')
        item[:make] = 'Ford'
      end
      if item[:make].downcase.include?('ch')
        item[:make] = 'Chevrolet'
      end
    when :model
      if item[:model].split(" ").length > 1
        split_model = item[:model].split(" ")
        item[:model] = split_model[0]
        item[:trim] = split_model[1]
      end
      item[:model] = item[:model].downcase.capitalize
    when :trim
      item[:trim] = item[:trim].upcase
    end
    if v.downcase == 'blank'
      item[k] = nil
    end
  end
end

examples = [
  [{ :year => '2018', :make => 'fo', :model => 'focus', :trim => 'blank' },
   { :year => 2018, :make => 'Ford', :model => 'Focus', :trim => nil }],
  [{ :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' },
   { :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' }],
  [{ :year => '1999', :make => 'Chev', :model => 'IMPALA', :trim => 'st' },
   { :year => 1999, :make => 'Chevrolet', :model => 'Impala', :trim => 'ST' }],
  [{ :year => '2000', :make => 'ford', :model => 'focus se', :trim => '' },
   { :year => 2000, :make => 'Ford', :model => 'Focus', :trim => 'SE' }]
]

examples.each_with_index do |(input, expected_output), index|
  if (output = normalize_data(input)) != expected_output
    puts "Example #{index + 1} failed,
          Expected: #{expected_output.inspect}
          Got:      #{output.inspect}"
  end
end