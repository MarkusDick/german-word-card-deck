require 'csv'

def check_duplicates(csv_file)
  all_words = Set.new
  duplicates = Set.new

  CSV.foreach(csv_file, headers: true) do |row|
    word_columns = row.headers[1..-1]  # Exclude the first column "category_id"
    
    word_columns.each do |column|
      word = row[column].to_s.strip
      unless word.empty?
        if all_words.include?(word)
          duplicates.add(word)
        else
          all_words.add(word)
        end
      end
    end
  end

  duplicates.to_a
end

if __FILE__ == $PROGRAM_NAME
  csv_file_path = 'words.csv'

  unless File.exist?(csv_file_path)
    puts "Error: File '#{csv_file_path}' not found."
    exit
  end
  
  result = check_duplicates(csv_file_path)

  if result.any?
    puts "Doppelte Begriffe gefunden: #{result.join(', ')}"
  else
    puts "Keine doppelten Begriffe gefunden."
  end
end
