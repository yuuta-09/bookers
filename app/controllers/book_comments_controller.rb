class BookCommentsController < ApplicationController
  before_action :is_matching_posted_user?, only: [:destroy]
  
  def create
    book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = book.id
    @comment.save
  end

  def destroy
    @comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
    @comment.destroy
    book = Book.find(params[:book_id])
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:body)
  end

  def is_matching_posted_user?
    unless current_user == BookComment.find_by(id: params[:id], book_id: params[:book_id]).user
      redirect_to request.referer
    end
  end
end
