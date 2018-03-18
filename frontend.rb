require "unirest"

system "clear"

puts "Choose an option"
puts "[1] Products Index (all products)"
puts "[1.1] Search Products by Name: "
puts "[1.2] Sort products by price ascending"
puts "[2] Find Product by ID"
puts "[3] Create a product!" 
puts "[4] Update a product!"
puts "[5] Delete a product!"

input_option = gets.chomp
if input_option == "1"
  response = Unirest.get("http://localhost:3000/v1/products")
  product = response.body
  puts JSON.pretty_generate(product)

elsif input_option == "1.1"
  print "Please search names:"
  name_search = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products?input_name_search=#{name_search}")
  product = response.body
  puts JSON.pretty_generate(product)

elsif input_option == "1.2"
  print "Products sorted by price:"
  response = Unirest.get("http://localhost:3000/v1/products?sort_by_price=true")
  products = response.body
  puts JSON.pretty_generate(products)

elsif input_option == "2"
  print "Please enter product ID:"
  id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{id}")
  product = response.body
  puts JSON.pretty_generate(product)

elsif input_option == "3"
  params = {}
  print "Enter product name: "
  params["input_name"] = gets.chomp
  print "Enter product price: "
  params["input_price"] = gets.chomp
  print "Enter product URL: "
  params["input_url"] = gets.chomp
  print "Enter product description: "
  params["input_description"] = gets.chomp

  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  if product["errors"] 
    puts "Uh oh! Something is wrong!"
    p product["errors"]
  else
    puts "Here is your product info:"
    puts JSON.pretty_generate(product)
  end

elsif input_option == "4"
  print "Please enter product ID:"
  id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{id}")  
  product = response.body
  params = {}
  print "Name (#{product["name"]}: "
  params["input_name"] = gets.chomp
  print "Price (#{product["price"]}: "
  params["input_price"] = gets.chomp
  print "Product URL (#{product["image_url"]}): "
  params["input_url"] = gets.chomp
  print "Product description (#{product["description"]}): )"
  params["input_description"] = gets.chomp
  params.delete_if {|_key, value| value.empty? }
  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  product = response.body
  if product["errors"] 
    puts "Uh oh! Something is wrong!"
    p product["errors"]
  else
    puts "Here is your product info:"
    puts JSON.pretty_generate(product)
  end

elsif input_option == "5"
  print "Please enter product ID:"
  id = gets.chomp
  response = Unirest.delete("http://localhost:3000/v1/products/#{id}")  
  product = response.body
  puts JSON.pretty_generate(product)
end