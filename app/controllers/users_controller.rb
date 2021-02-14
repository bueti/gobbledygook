class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    if current_user&.has_role?(:admin)
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true)
    else
      redirect_to root_path, alert: 'You don\'t have access!'
    end

  end

  def edit
    # authorize @user
  end

  def update
    # authorize @user
    if @user.update(user_params)
      redirect_to users_path, notice: "Roles for #{@user.username} were successfully updated."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit({role_ids: []})
  end

end