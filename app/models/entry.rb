class Entry < ApplicationRecord
  scope :without_drafts, -> { where('draft = false') }

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 50 }

  belongs_to :user

  has_rich_text :description

  def to_s
    title
  end

  extend FriendlyId
  friendly_id :title, use: :slugged
end
