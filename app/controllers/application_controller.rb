class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :set_global_variables
  def set_global_variables
    @ransack_entries = Entry.ransack(params[:entries_search], search_key: :entries_search)
  end

  # private
  #
  # def user_not_authorized
  #   flash[:alert] = 'You are not authorized to perform this action.'
  #   redirect_to(request.referrer || root_path)
  # end
end
