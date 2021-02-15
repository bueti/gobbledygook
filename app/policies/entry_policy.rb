class EntryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    user&.has_any_role?(:admin, :editor) || record.user == @user
  end

  def update?
    user&.has_any_role?(:admin, :editor) || record.user == @user
  end

  def new?
    user&.has_role?(:contributor)
  end

  def create?
    user&.has_role?(:contributor)
  end

  def destroy?
    user&.has_role?(:admin) || record.user == @user
  end

end
