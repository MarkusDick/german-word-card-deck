require 'csv'

# Read the CSV file
rows = CSV.read('words.csv')
header = rows.shift

# Function to randomize words in a category
def randomize_words(category_rows)
  (1...category_rows[0].length).each do |i|
    words = category_rows.map { |row| row[i] }
    words.shuffle!
    category_rows.each_with_index { |row, j| row[i] = words[j] }
  end
  category_rows
end

# Group by category_id and apply the randomize_words function
grouped_rows = Hash.new { |hash, key| hash[key] = [] }
rows.each { |row| grouped_rows[row[0]] << row }

randomized_rows = grouped_rows.flat_map { |_, group| randomize_words(group) }

# Add three empty lines after each three lines of data
output_rows = []
randomized_rows.each_with_index do |row, i|
  output_rows << row
  output_rows.concat([[], [], []]) if (i + 1) % 3 == 0
end

# Pad with empty lines if needed
remaining_empty_lines = 5 - (output_rows.length % 6)
output_rows.concat([[], [], [], [], []]) if remaining_empty_lines.positive?

# Write the randomized data with empty lines to a new CSV file
CSV.open('shuffled_words.csv', 'w', write_headers: true, headers: header) do |csv|
  output_rows.each { |row| csv << row }
end
