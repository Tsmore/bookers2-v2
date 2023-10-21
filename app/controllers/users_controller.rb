class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  privete

  def user_params
    params.require(:user).permit(:name, :introduction, :prifile_image)
  end
end
