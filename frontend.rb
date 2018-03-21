require "unirest"
require "tty-prompt"
prompt = TTY::Prompt.new

# Login and set jwt as part of Unirest requests
print "You are required to log in.  Please enter your email: "
email = gets.chomp
password = prompt.mask("Please enter your password: ") 

response = Unirest.post(
  "http://localhost:3000/user_token",
  parameters: {
    auth: {
      email: "#{email}",
      password: "#{password}"
    }
  }
)
jwt = response.body["jwt"]
Unirest.default_header("Authorization", "Bearer #{jwt}")

system "clear"

puts "Your jwt is #{jwt}"

puts "Choose an option"
puts "[1] Products Index (all products)"
puts "[1.1] Search Products by Name: "
puts "[1.2] Sort products by price ascending"
puts "[2] Find Product by ID"
puts "[3] Create a product!" 
puts "[4] Update a product!"
puts "[5] Delete a product!"
puts "[signup] Create a user account!"
puts "[6] Start an order!"
puts "[7] Show your orders!"

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

elsif input_option == "signup"
  params = {}
  print "Please enter full name: "
  params["name"] = gets.chomp
  print "Enter your email: "
  params["email"] = gets.chomp
  # print "Create your password: "
  # params["password"] = gets.chomp
  params["password"] = prompt.mask("What is your password?")
  # print "Re-enter your new password: "
  # params["password_confirmation"] = gets.chomp
  params["password_confirmation"] = prompt.mask("Please re-enter your new password for verification: ")

  response = Unirest.post("http://localhost:3000/v1/users", parameters: params)
  p response.body  

elsif input_option == "6"
  params = {}
  print "Please enter the product id: "
  params["product_id"] = gets.chomp
  print "Please enter the quantity: "
  params["quantity"] = gets.chomp

  response = Unirest.post("http://localhost:3000/v1/orders", parameters: params)
  order = response.body
  puts JSON.pretty_generate(order) 

elsif input_option == "7"
  puts "Here are all your orders: "
  response = Unirest.get("http://localhost:3000/v1/orders")
  orders = response.body
  puts JSON.pretty_generate(orders)
end