# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'better_errors'

require 'json'
require 'open-uri'
require 'uri'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path("..", __FILE__)
end
# refractor code for calling SQLite3
before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end

get '/' do     #home directory
  erb :home
end

get '/users' do   #to show all users
  
  @rs = @db.prepare('SELECT * FROM users;').execute
  erb :show_users
end
 
get '/products' do   #to show all products
  
  @rs = @db.prepare('SELECT * FROM products;').execute
  erb :show_products

end

get '/products/manage' do
  @rs = @db.prepare('SELECT * FROM products;').execute
  erb :manage_products
end

get '/products/new' do  # page that shows form to add a new product ***done

  erb :create_products
end

get '/products/:id' do   # to show individual product
  @id = params[:id]

  rs = @db.prepare("SELECT * FROM products WHERE id = '#{@id}';").execute
  @row = rs.first
  erb :product_info
end

get '/products/:id/update' do    #page to enter info to edit product
   @id = params[:id]
   @name = params[:name]
   @price = params[:price]
   @on_sale = params[:on_sale]
   rs = @db.prepare("SELECT * FROM products WHERE id = '#{@id}';").execute
   @row = rs.first
   erb :update_product
end

post '/products/:id/update' do     # to update product
  @id = params[:id]
  @name = params[:name]
  @price = params[:price]
  @on_sale = params[:on_sale]
  rs = @db.prepare("UPDATE products SET name = '#{@name}', price = '#{@price}', on_sale = '#{@n_sale}' WHERE id = '#{@id}';").execute
  erb :manage_products
end

get '/products/:id/destroy' do
  erb :delete_product
end

post '/products/:id/destroy' do
  @id = params[:id]
  
  @rs = @db.prepare("DELETE FROM products WHERE id = '#{@id}';").execute
  erb :product_deleted
end

post '/products/new' do    # to create new product
  @name = params[:name]
  @price = params[:price]
  @on_sale = params[:on_sale]
  @rs = @db.prepare("INSERT INTO products ('name', 'price', 'on_sale') VALUES ('#{@name}', '#{@price}', '#{@on_sale}');").execute
  erb :product_created
end

get 'products/search' do
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results
end

get 'products' do
  @q = params[:q]
  file = open("https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyAVctk-qzBQFBR2kyfAMKstIWU-Cs8nsJE&country=US&q=#{URI.escape(@q)}&alt=json",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
  @results = JSON.load(file.read)
  erb :google_results
end








 
 
 
 
 
 
