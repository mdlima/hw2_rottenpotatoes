class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # session.clear
        
    if !params[:commit] && (!params[:order_by] && session[:order_by]) || (!params[:ratings] && session[:ratings])
      redirect_to movies_path(:order_by => session[:order_by] , :ratings => session[:ratings] ) 
    end
    
    session[:order_by] = params[:order_by] if params.has_key? :order_by
    session[:ratings]  = params[:ratings]  if params.has_key? :ratings
    
    @order_by = params[:order_by]
    @movies = Movie.order @order_by

    @header_classes = Hash.new
    @header_classes[@order_by] = "hilite"
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || Hash.new(false)
    @movies = @movies.where(:rating => params[:ratings].keys) if params[:ratings]
    
    # flash[:notice] = "session: order_by=#{session[:order_by]}, ratings=#{session[:ratings]} \n\n\n params: #{params}\n, all_ratings: #{@all_ratings}, selected_ratings: #{@selected_ratings}"
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
