require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'

before do
  sql = "SELECT DISTINCT genre FROM videos;"
  @nav_rows = run_sql(sql)
end

get '/artists/:genre' do
  sql = "SELECT * FROM videos WHERE genre = '#{params['genre']}';"
  @rows = run_sql(sql)
  erb :artists
end

post '/artists/:artist_id/delete' do
  sql = "DELETE FROM videos WHERE id = #{params['artist_id']};"
  run_sql(sql)
  redirect to('/artists')
end

get '/artists/:artist_id/edit' do
  sql = "SELECT * FROM videos WHERE id = #{params['artist_id']};"
  rows = run_sql(sql)
  @row = rows.first
  erb :new
end

post '/artists/:artist_id' do
  sql = "UPDATE videos SET title='#{params[:title]}', description='#{params[:description]}', url='#{params[:url]}', genre='#{params[:genre]}' WHERE id ='#{params[:artist_id]}'"
  run_sql(sql)
  redirect to('/artists')
end

get '/' do
 erb :home
end

get '/new' do
  erb :new
end

get '/artists' do
  sql = "SELECT * FROM videos;"
  @rows = run_sql(sql)
  erb :artists
end

post '/create' do
  sql = "INSERT INTO videos (title, description, url, genre) VALUES ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{params['genre']}');"
  run_sql(sql)
  redirect(to'/artists')
end

def run_sql(sql)
  conn = PG.connect(:dbname =>'videos', :host => 'localhost')
  result = conn.exec(sql)
  conn.close

  result
end


