require "sinatra"
require "sinatra/reloader"

get "/" do
  "Welcome to my domain."
end

get "/foo" do
  redirect(to("/bar"))
end

get "/bar" do
  "This is bar.  No this is Patrick"
end

get "/*" do
  "We love ruby"
end
