require "sinatra"
if development?
  require "sinatra/reloader"
end
require "pg"
require "active_record"

GALLERIES = {
  "cats" => ["colonel_meow.jpg", "grumpy_cat.png"],
  "dogs" => ["shibe.png"]
}
#database = PG.connect({ dbname: "photo_gallery" })
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "photo_gallery")

class Gallery < ActiveRecord::Base
  has_many :images
end

class Image < ActiveRecord::Base

end

get "/" do
  @galleries = Gallery.all
  @gallery_names = @galleries.map{ |gallery| gallery.name.upcase }
  #galleries = database.exec_params("
  #                                      SELECT name FROM galleries")
  #@gallery_names = galleries.map{ |gallery|
    #gallery["name"]}
  #puts @gallery_names
  erb :home
end

get "/galleries/new" do
  erb :new_gallery
end

get "/galleries/:id/images/new" do
  id = params[:id]
  @gallery = Gallery.find(id)
  erb :new_image
end

post "/galleries" do
  new_gallery_name = params[:gallery][:name]
  Gallery.create(name: new_gallery_name)

  redirect to("/")
end
post "/galleries/:id" do
  gallery_id = params[:id]
  gallery = Gallery.find(gallery_id)
  gallery.images.create(params[:image])
  redirect to("/galleries/#{gallery_id}")
end

delete "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(id)
  gallery.destroy
  redirect to("/")
end

delete "/galleries/:id/images/:image_id" do
  id = params[:id]
  image_id = params[:image_id]
  image = Image.find(image_id)
  image.destroy
  redirect to("/galleries/#{id}")
end

get "/galleries/:id/images/:image_id/edit" do
  @image = Image.find(params[:image_id])
  @gallery = Gallery.find(params[:id])
  erb :edit_image
end

patch "/galleries/:id/images/:image_id" do
  gallery_id = params[:id]
  image = Image.find(params[:image_id])
  image.update(params[:image])
  redirect to("/galleries/#{gallery_id}")
end
get "/galleries/:id" do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = Image.where(gallery_id: id)
  #query = "SELECT * FROM galleries WHERE id = $1"
  #images = database.exec_params(query, [id])
  #@name = images.first["name"]
  erb :gallery
end

get "/galleries/:id/edit" do
  @gallery = Gallery.find(params[:id])
  erb :edit_gallery
end
patch "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(id)
  gallery.update(params[:gallery])
  redirect to("/galleries/#{id}")
end
