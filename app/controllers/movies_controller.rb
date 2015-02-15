class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    
    if params[:sort].nil? && params[:ratings].nil? &&
        (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    @sort = params[:sort]
    @ratings = params[:ratings] 
    
    @all_ratings = Movie.arr
    @checked_ratings = (params[:ratings].present? ? params[:ratings] : [])
    @movies = Movie.scoped

    if @sort && Movie.attribute_names.include?(@sort)
      @movies = @movies.order @sort
    end
    if @checked_ratings.empty?
      @checked_ratings = @all_ratings
    else
      if @checked_ratings == Array
        @movies = @movies.where :rating => @checked_ratings
      else
        @movies = @movies.where :rating => @checked_ratings.keys
      end
    end
    
    session[:sort] = @sort
    session[:ratings] = @ratings
    
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
