require "unirest"

system "clear"

puts "Choose an option"
puts "[1] First Product"
puts "[2] All Products"

input_option = gets.chomp
if input_option == "1"
  response = Unirest.get("http://localhost:3000//show_first_product_url")
  product = response.body
  p product
elsif input_option == "2"
  response = Unirest.get("http://localhost:3000/show_all_products_url""http://localhost:3000/second_contact_url")
  products = response.body
  p products
end