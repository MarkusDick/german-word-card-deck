require 'squib'

# Load the shuffled words
data = Squib.csv(file: 'shuffled_words.csv')

Squib::Deck.new(cards: data['category_id'].size + 1) do
  # Front side and text at the top row
  svg file: 'assets/frontside.svg', x: 35, y: 35, width: width - 35 * 2, height: height - 35 * 2, range: (0..data['category_id'].size).select { |num| num % 6 < 3 }

  # Add text for each word on the front side
  (0..5).each do |j|
    rect y: 112.5 + (700 / 6 + 40) * j, x: (width / 2) - (width * 0.7 / 2), height: 700 / 6, width: width * 0.70, fill_color: '#00121d', radius: 5, range: (0..data['category_id'].size).select { |num| num % 6 < 3 }
    text str: data["word#{j + 1}"], font: 'Grundschrift weight=900 16', color: :white,
         y: 137.5 + (700 / 6 + 40) * j, x: (width / 2) - (width * 0.7 / 2), width: width * 0.70, align: :center, range: (0..data['category_id'].size).select { |num| num % 6 < 3 }
  end

  # Back side at the bottom row
  svg file: 'assets/backside.svg', width: :deck, height: :deck, range: (0..data['category_id'].size).select { |num| num % 6 > 2 }
  
  # Different background colors for the category icons
  colors = ['#5363E7', '#4B733E', '#BF3D3B', '#D8862E', '#808080', '#B9AB00', '#B0578D']

  # Place category icon on the back side
  (1..7).each do |k|
    color = colors[k - 1]

    # Add a circle for the icon 
    circle x: width / 2, y: height / 2, radius: 200, fill_color: color, stroke_width: 0,
      range: (0..data['category_id'].size).select { |num| data['category_id'][num - 3] == k }

    # Add category icon
    svg file: "assets/#{k}.svg", x: (width - 300) / 2, y: (height - 300) / 2, height: 300, width: 300, 
      range: (0..data['category_id'].size).select { |num| data['category_id'][num - 3] == k }
  end

  # cut_zone stroke_color: :purple, radius: 0
  # safe_zone stroke_color: :green, radius: 0
  save_pdf file: 'deck.pdf'
end