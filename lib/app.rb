require 'json'
require 'date'

def start
  setup_files # load, read, parse and create the files
  create_report # create the report!
end

def close_file
  $report_file.close
end

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("../report.txt", "w+")
end

def create_report
  asc_sales
  print_today
  asc_products
  product_data
  asc_brands
  brand_data 
end

def product_data
   $products_hash["items"].each do |toy|
     name_toy(toy)
     
		 retail_price = retail_price(toy).to_f
     print_retail_price(retail_price)
     
		 number_purchase_each = number_purchase_each(toy)
     print_number_purchase_each(number_purchase_each)
     
     total_sales = total_sales(toy)
     print_total_sales(total_sales)
     
     average = average_price_sold(total_sales, number_purchase_each)
     print_average_price_sold(average)
    
     discount = average_discount(retail_price,average)
     print_average_discount(discount)
     
     rate = discount_rate(retail_price, discount)
     print_rate(rate)
     $report_file.puts "------------------------------------------" 
  end
end

def brand_data
  brands = brand_list
  brands.each do |b|
    $report_file.puts b
    total_stock = 0
    total_price = 0.0
    average_price = 0.0
    total_sales = 0.0
    n = 0
    $products_hash["items"].each do |toy|
      if toy["brand"] == b
        n = n + 1
        total_stock = total_stock + toy["stock"]
        total_price = total_price + toy["full-price"].to_f
        toy["purchases"].each do |p|
          total_sales = total_sales + p["price"]
        end
      end
    end
    print_stocks_brand(total_stock)
    print_average_price_brand(total_price, n)
    print_total_brand(total_sales)
    $report_file.puts "------------------------------------------"
  end
end

# Print "Sales Report" in ascii art
def asc_sales
  $report_file.puts "  ____        _             ____                       _  " 
  $report_file.puts " / ___|  __ _| | ___  ___  |  _ \\ ___ _ __   ___  _ __| |_ "
  $report_file.puts " \\___ \\ / _` | |/ _ \\/ __| | |_) / _ \\ '_ \\ / _ \\| '__| __| "
  $report_file.puts "  ___) | (_| | |  __/\\__ \\ |  _ <  __/ |_) | (_) | |  | |_ "
  $report_file.puts " |____/ \\__,_|_|\\___||___/ |_| \\_\\___| .__/ \\___/|_|   \\__|"
  $report_file.puts "                                     |_|                   "
end

# Print today's date
def print_today
  date = DateTime.now
  day = date.day
  month = date.month
  year = date.year
  $report_file.puts "Date : #{day}/#{month}/#{year}"
end

# Print "Products" in ascii art
def asc_products
  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       "
end

# For each product in the data set:
	# Print the name of the toy
def name_toy(toy)
  $report_file.puts "Title: #{toy["title"]}"
end

	# Print the retail price of the toy
def retail_price(toy)
  return toy["full-price"]
end

def print_retail_price(amount)
  $report_file.puts "Retial price: $#{amount}"
end

	# Calculate and print the total number of purchases

def number_purchase_each(toy)
  return toy["purchases"].length
end

def print_number_purchase_each(number)
  $report_file.puts "Number of purchases: #{number}"
end

	# Calculate and print the total amount of sales
def total_sales(toy)
  total_sales = 0.0
  toy["purchases"].each do |p|
    total_sales = total_sales + p["price"]
  end
  return total_sales
end

def print_total_sales(amount)
  $report_file.puts "Total sales: $#{amount}"
end

	# Calculate and print the average price the toy sold for
def average_price_sold(total,number)
  average_price = total / number
  return average_price
end

def print_average_price_sold(average)
  $report_file.puts "Average price sold: $#{average}"
end

	# Calculate and print the average discount (% or $) based off the average sales price

def average_discount(price,average)
  average_discount = price - average
  return average_discount
end

def print_average_discount(discount)
  $report_file.puts "Average discount: $#{discount}"
end

def discount_rate(full_price, discount)
  rate = discount/full_price*100
  return rate
end

def print_rate(rate)
  $report_file.puts "Discount rate: #{rate.round(2)}%"
end

# Print "Brands" in ascii art
def asc_brands
  $report_file.puts " _                         _     "
  $report_file.puts "| |                       | |    "
  $report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
  $report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  $report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
  $report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  $report_file.puts ""
end
# For each brand in the data set:
	# Print the name of the brand

def brand_list
  brands = [ ]
  $products_hash["items"].each do |toy|
    brands.push(toy["brand"])
  end
  brands = brands.uniq
  return brands
end	

  # Count and print the number of the brand's toys we stock
def print_stocks_brand(number)
  $report_file.puts "Number of stocks: #{number}"
end
  # Calculate and print the average price of the brand's toys
def print_average_price_brand(total, n)
  average = total/n
  $report_file.puts "Average price: $#{average.round(2)}"
end
	# Calculate and print the total sales volume of all the brand's toys combined
def print_total_brand(total_sales)
  $report_file.puts "Total sales: $#{total_sales.round(2)}"
end

start

close_file
