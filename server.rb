require 'sinatra'
require "CSV"
require "pry"

#display submitted articles
#every article should have description, title, and url
#url should link to relevant page inside new tab

#display for index
get "/index" do 
  @articles = []
  CSV.foreach('articles.csv', headers: true, header_converters: :symbol) do |row|
  	@articles << row.to_hash  
  end
  erb :index	
end

#redirect host to index page
get "/" do 
  redirect "/index"
end

#display for comments
get "/comments" do 
  erb :comments	
end

#display for submit
get "/submit" do
  erb :submit
end

#accepting sent data and creating a csv
post "/submit" do
  title = params["title"]
  url = params["url"]
  description = params["description"]
  CSV.open("articles.csv", "a") do |file|
    file << [title, url, description]
  end
  redirect "/index"
end
