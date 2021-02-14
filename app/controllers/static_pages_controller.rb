class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @entries = Entry.all.limit(3)
    @latest_entries = Entry.all.order(created_at: :desc).limit(3)
  end
end
