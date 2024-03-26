class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:tasks]

  def tasks
    render json: @user.tasks
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
