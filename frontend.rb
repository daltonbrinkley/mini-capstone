require "unirest"
# require "tty-table"

system "clear"

puts "Choose an option"
puts "[1] First Product"
puts "[2] All Products"
puts "[3] Products Index (all products)"
puts "[4] Find Product by ID"
puts "[5] Create a recipe!" 

input_option = gets.chomp
if input_option == "1"
  response = Unirest.get("http://localhost:3000/v1/show_first_product_url")
  product = response.body
  p product
elsif input_option == "2"
  response = Unirest.get("http://localhost:3000/v1/show_all_products_url")
  products = response.body
  p products
elsif input_option == "3"
  response = Unirest.get("http://localhost:3000/v1/products")
  product = response.body
  puts JSON.pretty_generate(product)

elsif input_option == "4"
  print "Please enter product ID:"
  id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{id}")
  product = response.body
  puts JSON.pretty_generate(product)
elsif input_option == "5"
  print "Enter product name: "
  product_name = gets.chomp
  print "Enter product price: "
  product_price = gets.chomp
  print "Enter product URL: "
  product_URL = gets.chomp
  print "Enter product description:"
  product_description = gets.chomp
  print "

  Adding your new product!

  "

  params = {
    "input_name" => product_name,
    "input_price" => product_price,
    "input_url" => product_URL,
    "input_description" => product_description
  }
  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  puts JSON.pretty_generate(product)
end

  # table_header = ['Name:','Price:','Image URL:','Description:']
  
  # table_body = 
  #   products.each do |product|
  #   array = []
  #   array << products["name"], products["price"], products["image_url"], products["description"]
  #   end

  # p table_body



  # table = TTY::Table.new table_header, table_body
  # puts table.render(:ascii)