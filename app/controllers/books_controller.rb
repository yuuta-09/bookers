class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    # 閲覧数を更新(+1)
    @book.increment!(:view_count)
    @book_comment = BookComment.new
  end

  def index
    # いいねの多い順にソート
    @books = Book.all.sort{|a, b| a.favorites.count <=> b.favorites.count}.reverse
    if params[:sort] == 'day'
      @books = Book.all.order(created_at: :desc)
    elsif params[:sort] == 'rate'
      @books = @books.sort_by{|x| x.rate.to_i}.reverse
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
