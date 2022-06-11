class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    binding.pry
    # @favorite = current_user.favorites.new(book_id: @book.id)
    @favorites = @book.favorites.users << current_user
    @favorite.save
    render 'replace_btn'
  end

  def destroy
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @book.id)
    @favorite.destroy
    render 'replace_btn'
  end
end
