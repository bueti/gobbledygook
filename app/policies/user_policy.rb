class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    @user&.has_role?(:admin)
  end

  def update?
    @user&.has_role?(:admin) || record.user == @user
  end

end
