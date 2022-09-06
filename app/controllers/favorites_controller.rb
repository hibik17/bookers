# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @favorite = Favorite.create(user_id: current_user.id, book_id: @book.id)
    render 'replace_btn'
  end

  def destroy
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @book.id)
    @favorite.destroy
    render 'replace_btn'
  end
end
