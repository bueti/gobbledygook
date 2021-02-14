class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
  rolify

  has_many :entries

  def username
    email.split(/@/).first
  end

  def to_s
    email
  end

  after_create :assign_default_role
  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:editor)
      self.add_role(:contributor)
    else
      self.add_role(:contributor) if self.roles.blank?
    end
  end

  private

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role.")
    end
  end

end
