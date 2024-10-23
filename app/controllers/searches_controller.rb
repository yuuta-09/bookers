class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == 'User'
      @users = User.search(params[:how], params[:word])
    elsif @range == 'Book'
      @books = Book.search(params[:how], params[:word])
    else
      @range = "Tag"
      @books = Book.tag_search(params[:word])
    end

    render :index
  end
end
