require 'sinatra'
require "CSV"
require "pry"

def already_submitted(url, previous_urls)
  
end

get "/index" do 
  @articles = []
  CSV.foreach('articles.csv', headers: true, header_converters: :symbol) do |row|
  	@articles << row.to_hash  
  end
  erb :index	
end

get "/" do 
  redirect "/index"
end

get "/comments" do 
  erb :comments	
end

get "/submit" do
  erb :submit
end

post "/submit" do
  title = params["title"]
  url = params["url"]
  description = params["description"]
  # @short_desc_error = ensure_length(description)
  CSV.open("articles.csv", "a") do |file|
      file << [title, url, description]
    end
    redirect "/index"
end

# def ensure_valid(url)
#   if url 
#     ok_to_save_submission? == false
#     url_error = "Enter a valid URL, please : )"
#   end 
# end

# def ok_to_save_submission?
#   false
# end

# def ensure_no_blank(*forms)
#   forms.any? {|input| input == nil} ? "No blank fields please :-)" : ok_to_save_submission? == true
# end

# def ensure_length(description)
#   description.length < 20 ? "Enter a description of at least 20 characters, please :-)" : ok_to_save_submission? == true
# end

# @blank_form_error = ensure_no_blank(title, url, description)
  # @short_desc_error = ensure_length(description)
  # if ok_to_save_submission?
  #   CSV.open("articles.csv", "a") do |file|
  #     file << [title, url, description]
  #   end
  #   redirect "/index"
  # else
  #   redirect "/submit"
  # end