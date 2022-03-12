class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:edit]

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id

    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.new
    @book_one = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def edit
    @book_one = Book.find(params[:id])
  end

  def update
    @book_one = Book.find(params[:id])
    if @book_one.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book_one)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def search
    @books = Book.search(params[:word])
    @book = Book.new
    if @books.count != 0
      render :index
    else
      flash[:notice] = "検索対象にヒットしたものはありませんでした。"
      redirect_to books_path
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def check_user
    @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
  end
end
