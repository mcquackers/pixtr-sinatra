require "sinatra"
require "sinatra/reloader"

get "/" do
  erb :home
end

get "/projects/:id" do
  @project_id = params["id"]
  erb :project_id
end
