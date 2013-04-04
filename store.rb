# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
 
 
get '/users' do
  db = SQLite3::Database.new "store.sqlite3"
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM users;').execute
  erb :show_users
end
 
 
get '/' do
  erb :home
end
 
get '/products' do
  pr = SQLite3::Database.new 'store.sqlite3'
  pr.results_as_hash = true
  @pr = pr.prepare('SELECT * FROM products;').execute
  erb :show_products

end

 
 
 
 
 
 
 
=begin
 
  <form method='post' action='/create'>
    <input type='text' name='name' autofocus>
    <input type='text' name='photo'>
    <input type='text' name='breed'>
    <button>dog me!</button>
  </form>
 
 
  post '/create' do
  end
 
 
  redirect '/'
 
=end