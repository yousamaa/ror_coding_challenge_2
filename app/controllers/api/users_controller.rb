class Api::UsersController < ApplicationController
  before_action :set_user

  def tasks
    render json: @user.tasks
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
