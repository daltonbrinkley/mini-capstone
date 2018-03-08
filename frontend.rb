require "unirest"
# require "tty-table"

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

  # table_header = ['Name:','Price:','Image URL:','Description:']
  
  # table_body = 
  #   products.each do |product|
  #   array = []
  #   array << products["name"], products["price"], products["image_url"], products["description"]
  #   end

  # p table_body



  # table = TTY::Table.new table_header, table_body
  # puts table.render(:ascii)