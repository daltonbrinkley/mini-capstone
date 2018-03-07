require "unirest"
require "tty-table"

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
  response = Unirest.get("http://localhost:3000/show_all_products_url")
  products = response.body
  p products
end

  table_header = ['Name:','Price:','Image URL:','Description:']
  
  # products.length.times do
  #   index = 0

  table_body = [[products[0]["name"], products[0]["price"], products[0]["image_url"], products[0]["description"]]]
#     index = index + 1
# end

  table = TTY::Table.new table_header, table_body
  puts table.render(:ascii)


# table = TTY::Table.new ['Name:','Price:','Image URL:','Description:'], [[Product.first[name:], 'a2'], ['b1', 'b2']]
# p table.render(:ascii)
