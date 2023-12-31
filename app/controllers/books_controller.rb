class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def index
    @book = Book.new
    @books = Book.all
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day

    case params[:order]
    when 'favorites'
      @books = Book.includes(:favorited_users).
        sort_by { |x| x.favorited_users.includes(:favorites).where(created_at: from...to).size }.
        reverse
      when 'oldest'
        @books = Book.order(created_at: :asc)
    else
      @books = Book.order(created_at: :desc)
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to @book
    else
      @books = Book.all
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end

end
