require "sinatra"
require "CSV"
require "net/HTTP"
require "URI"
require "pry"

def not_already_submitted(current_url, previous_urls)
  previous_urls.any? {|submission| submission[:url] == current_url } ? false : true
end

def not_blank(*forms)  
  forms.any? {|input| input == nil} ? false : true
end

def not_too_short(description)
  description.length < 20 ? false : true
end

def not_invalid(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response.code != 200 #Don't use ternaries with statements that already return true or false ... that equates to if true is true return X if true is false return Y etc...
end

def get_csv_data
  articles = []
  CSV.foreach('articles.csv', headers: true, header_converters: :symbol) do |row|
    articles << row.to_hash  
  end
  articles
end

def append_csv_data(title, url, description)
  CSV.open("articles.csv", "a") do |file|
        file << [title, url, description]
  end
end

get "/index" do 
  @articles = get_csv_data
  erb :index	
end

get "/" do 
  redirect "/index"
end

get "/comments" do 
  erb :comments	
end

get "/submit" do
  @title = params["title"]
  @url = params["url"] 
  @description = params["description"] 
  
  @error_message = ""
  if not_blank(@title, @url, @description) == false
    @error_message = "No blank forms please."
  elsif not_too_short(@description) == false
    @error_message = "Please enter a description of at least 20 characters." 
  elsif not_already_submitted(@url) == false
    @error_message = "Sorry, that article has already been submitted!"
  elsif not_invalid(@url) == false
    @error_message = "Please enter a valid URL."
  else
    @error_message = "" 
  end

  erb :submit
end

post "/submit" do
  @articles = []
  CSV.foreach('articles.csv', headers: true, header_converters: :symbol) do |row|
    @articles << row.to_hash  
  end

  @title = params["title"] || ""
  @url = params["url"] || ""
  @description = params["description"] || ""
  
  if not_blank(@title, @url, @description) && not_already_submitted(@url, @articles) && not_too_short(@description) && not_invalid(@url)
    append_csv_data(@title, @url, @description)
    redirect "/index"
  else
    redirect "/submit"
  end
end

#If all of these tests pass then you can run the block to write to CSV
#If not, output unique message for each (in view)
#Must set default values for forms to their respective params values
