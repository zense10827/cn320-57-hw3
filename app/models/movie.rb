class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  def Movie.arr 
    return ['G','PG','PG-13','NC-17','R']  
  end
end