class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :entries

  def username
    self.email.split(/@/).first
  end

  def to_s
    email
  end

end
