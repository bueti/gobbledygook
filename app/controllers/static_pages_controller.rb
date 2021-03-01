class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about, :privacy, :license]

  def home
    @entries = Entry.all.limit(3)
    @latest_entries = Entry.all.without_drafts.order(created_at: :desc).limit(3)
  end
end
