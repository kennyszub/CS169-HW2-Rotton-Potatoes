class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @movies = Movie.all

    if session.length == 0
      session[:checked_ratings] = @all_ratings
    end
    
    # checked ratings
    if params.has_key?(:ratings)
      @movies = Movie.where(rating: params[:ratings].keys)
      @checked_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
      
      #@rating_keys = Movie.where(rating: params[:ratings].keys).map { |movie| movie.id }
    else
      @movies = Movie.where(rating: session[:ratings].keys)
      @checked_ratings = session[:ratings].keys
    end
    
    # sorting
    if params.has_key?(:sort)
      if (params[:sort] == "movie_name")
        @title_highlight = true
        @movies = Movie.find(:all, :order => "title ASC")
      elsif (params[:sort] == "release_date")
        @release_highlight = true
        @movies = Movie.find(:all, :order => "release_date ASC")
      end
    #else
    # remove this
    #  @movies = Movie.all
    end
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
